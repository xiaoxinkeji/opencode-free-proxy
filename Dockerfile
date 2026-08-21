# syntax=docker/dockerfile:1
FROM node:22-alpine AS runtime

ENV NODE_ENV=production \
    PROXY_PORT=6446 \
    KEYS_FILE=/app/data/api-keys.json

WORKDIR /app

RUN apk add --no-cache su-exec
COPY package*.json ./
RUN npm ci --omit=dev --no-audit --no-fund \
    && npm cache clean --force

COPY --chown=node:node server.mjs cluster.mjs start.sh docker-entrypoint.sh ./
RUN chmod 0755 start.sh docker-entrypoint.sh \
    && mkdir -p /app/data \
    && chown -R node:node /app

VOLUME ["/app/data"]
EXPOSE 6446

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:'+(process.env.PROXY_PORT||6446)+'/health').then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"

ENTRYPOINT ["./docker-entrypoint.sh"]
