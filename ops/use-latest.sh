#!/usr/bin/env bash
set -e

IMAGE="ghcr.io/boxi-wangji/compose-redis-demo-web:latest"

echo "== Use latest image =="
echo "$IMAGE"

sed -i "s|ghcr.io/boxi-wangji/compose-redis-demo-web:.*|$IMAGE|" compose.yaml

grep image compose.yaml

./deploy.sh
