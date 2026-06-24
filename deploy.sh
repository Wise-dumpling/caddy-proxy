#!/usr/bin/env sh
set -eu

cd /opt/caddy-proxy

if [ -d .git ]; then
  git fetch --prune origin
  git reset --hard origin/main
fi

if [ ! -f .env ]; then
  cp .env.example .env
fi

docker compose --env-file .env -f docker-compose.prod.yml up -d
docker image prune -af --filter "until=24h"
