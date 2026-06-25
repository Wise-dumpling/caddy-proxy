#!/usr/bin/env sh
set -eu

cd /opt/caddy-proxy

if [ -d .git ]; then
  : "${GIT_SSH_COMMAND:=ssh -i /root/.ssh/aerolog_deploy -o IdentitiesOnly=yes}"
  export GIT_SSH_COMMAND

  git fetch --prune origin
  git reset --hard origin/main
fi

if [ ! -f .env ]; then
  cp .env.example .env
fi

docker network inspect caddy_proxy >/dev/null 2>&1 || docker network create caddy_proxy
docker compose --env-file .env -f docker-compose.prod.yml up -d
docker image prune -af --filter "until=24h"
