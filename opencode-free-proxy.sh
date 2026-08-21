#!/bin/sh
set -eu

ROOT=${OPENCODE_PROXY_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/opencode-free-proxy}
PORT=${PROXY_PORT:-6446}

if [ ! -d "$ROOT/node_modules" ]; then
  echo "Dependencies are missing. Download the matching release archive, or run: npm ci" >&2
  exit 1
fi

exec node "$ROOT/server.mjs"
