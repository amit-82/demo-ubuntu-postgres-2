# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM alpine:3.23.0 AS builder

RUN apk add --no-cache nodejs npm

WORKDIR /app

# Copy manifests first to leverage Docker layer caching for dependencies.
COPY package.json package-lock.json ./
COPY packages/server/package.json packages/server/
COPY packages/client/package.json packages/client/

RUN npm ci

# Copy sources and build both workspaces.
COPY . .
RUN npm run build

# Drop dev dependencies from the hoisted node_modules.
RUN npm prune --omit=dev

# ---- Runtime stage ----
FROM alpine:3.23.0

RUN apk add --no-cache nodejs

ENV NODE_ENV=production \
    PORT=3011

# Run as an unprivileged user.
RUN addgroup -S app && adduser -S app -G app

WORKDIR /app

# Copy production deps and the built workspace, preserving the layout the
# server expects (packages/server/dist -> ../../client/dist).
COPY --from=builder --chown=app:app /app/node_modules ./node_modules
COPY --from=builder --chown=app:app /app/package.json ./package.json
COPY --from=builder --chown=app:app /app/packages/server/package.json ./packages/server/package.json
COPY --from=builder --chown=app:app /app/packages/server/dist ./packages/server/dist
COPY --from=builder --chown=app:app /app/packages/client/dist ./packages/client/dist

USER app

EXPOSE 3011

CMD ["node", "packages/server/dist/index.js"]
