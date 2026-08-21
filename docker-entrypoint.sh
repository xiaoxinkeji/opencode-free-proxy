#!/bin/sh
set -eu

mkdir -p "$(dirname "${KEYS_FILE:-/app/data/api-keys.json}")"
chown -R node:node /app/data 2>/dev/null || true

if [ "$(id -u)" = "0" ]; then
  exec su-exec node ./start.sh
fi
exec ./start.sh
