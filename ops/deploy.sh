#!/usr/bin/env bash
set -e

echo "== Pull latest images =="
docker compose pull

echo "== Start containers =="
docker compose up -d --force-recreate

echo "== Container status =="
docker compose ps

echo "== Test Nginx entry =="
for i in {1..20}; do
  if curl -fsS http://localhost; then
    echo
    echo "== Health check passed =="
    break
  fi

  echo "Waiting for service... ($i/20)"
  sleep 2

  if [ "$i" = "20" ]; then
    echo "Health check failed"
    docker compose logs web --tail=50
    exit 1
  fi
done

echo
echo "== Web logs =="
docker compose logs web --tail=20
