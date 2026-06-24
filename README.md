# Shared Caddy Proxy

Shared Caddy reverse proxy for public apps on `kpvlab.org`.

## Routes

- `https://aerolog.kpvlab.org` -> `aerolog-frontend:80`
- `https://aerolog.kpvlab.org/api/*` -> `aerolog-backend:8000`
- `https://iching.kpvlab.org` -> `iching-webapp:8080`

The proxy owns public ports `80` and `443` and creates the shared Docker network
`caddy_proxy`. App compose stacks must join that network and should not publish
public HTTP/HTTPS ports.

## Server Layout

- Repo: `/opt/caddy-proxy`
- Env file: `/opt/caddy-proxy/.env`
- Caddy data/certs: Docker volume `caddy-proxy_caddy_data`

## Deploy

```sh
cd /opt/caddy-proxy
cp .env.example .env
docker compose --env-file .env -f docker-compose.prod.yml up -d
```

If the old AeroLog-owned Caddy container is still running, stop it before
starting this stack because only one container can bind public ports `80` and
`443`:

```sh
docker stop aerolog-caddy
docker rm aerolog-caddy
```

For scheduled refresh:

```sh
cp deploy/systemd/caddy-proxy.* /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now caddy-proxy.timer
```

## Required App Networks

Each app production compose should include:

```yaml
networks:
  caddy_proxy:
    external: true
```
