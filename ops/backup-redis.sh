#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

BACKUP_DIR="$HOME/backups/redis"
FILE="$BACKUP_DIR/dump-$(date +%Y%m%d-%H%M%S).rdb"
KEEP_COUNT=7

mkdir -p "$BACKUP_DIR"

echo "== Save Redis data =="
docker compose exec redis redis-cli BGSAVE

sleep 1

echo "== Copy dump.rdb to backup dir =="
docker cp prod-redis:/data/dump.rdb "$FILE"

echo "== Backup created =="
ls -lh "$FILE"

echo "== Cleanup old backups, keep latest $KEEP_COUNT =="
ls -t "$BACKUP_DIR"/*.rdb 2>/dev/null | tail -n +$((KEEP_COUNT + 1)) | xargs -r rm -f

echo "== Current backups =="
ls -lh "$BACKUP_DIR"
