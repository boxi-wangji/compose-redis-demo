#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./rollback.sh <image-tag-or-sha>"
  exit 1
fi

TAG="$1"
IMAGE="ghcr.io/boxi-wangji/compose-redis-demo-web:$TAG"

echo "== Rollback to =="
echo "$IMAGE"

sed -i "s|ghcr.io/boxi-wangji/compose-redis-demo-web:.*|$IMAGE|" compose.yaml

grep image compose.yaml

./deploy.sh
