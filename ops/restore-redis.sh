#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./restore-redis.sh <backup-file.rdb>"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "== Restore Redis from backup =="
echo "$BACKUP_FILE"

echo "== Stop web and redis =="
docker compose stop web redis

echo "== Copy backup into Redis container =="
docker cp "$BACKUP_FILE" prod-redis:/data/dump.rdb

echo "== Start redis =="
docker compose start redis

echo "== Wait for redis healthy =="
for i in {1..20}; do
  STATUS=$(docker inspect -f '{{.State.Health.Status}}' prod-redis 2>/dev/null || true)

  if [ "$STATUS" = "healthy" ]; then
    echo "Redis is healthy"
    break
  fi

  echo "Waiting for redis... ($i/20)"
  sleep 2

  if [ "$i" = "20" ]; then
    echo "Redis did not become healthy"
    docker compose logs redis --tail=50
    exit 1
  fi
done

echo "== Start web =="
docker compose start web

echo "== Check Redis data =="
docker compose exec redis redis-cli GET visit_count

echo "== Test Nginx entry =="
for i in {1..20}; do
  if curl -fsS http://localhost; then
    echo
    echo "== Restore check passed =="
    exit 0
  fi

  echo "Waiting for web... ($i/20)"
  sleep 2
done

echo "Restore check failed"
docker compose logs web --tail=50
exit 1
