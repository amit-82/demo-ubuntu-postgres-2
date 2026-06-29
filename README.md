# express-axios-app

A TypeScript application with an Express server and a Vue 3 client, organized as
npm workspaces. The Express server serves the built Vue app at `/` and exposes a
`GET /api/ping` endpoint that returns `pong`.

## Project structure

```
express-axios-app/
├── packages/
│   ├── server/   # Express + TypeScript (serves the client build + /api routes)
│   └── client/   # Vue 3 + Vite + TypeScript
├── Dockerfile
└── docker-compose.yml
```

## Docker

The image is a multi-stage build based on `alpine:3.23.0`. The server listens on
port **3011** inside the container.

### npm scripts

Convenience scripts are defined in `package.json`:

```bash
npm run docker:build        # docker build -t express-vue-app .
npm run docker:run          # docker run --name express-vue-app-container -p 3011:3011 express-vue-app
npm run docker:stop-remove  # docker stop express-vue-app-container && docker rm express-vue-app-container
```

### Build the image

```bash
docker build -t express-vue-app .
```

### Run the container

```bash
docker run -p 3011:3011 express-vue-app
```

Then open:

- App (Vue client): http://localhost:3011/
- Ping endpoint: http://localhost:3011/api/ping → `pong`

Run it detached and give it a name:

```bash
docker run -d --name express-vue-app -p 3011:3011 express-vue-app
```

Map a different host port (e.g. expose on 8080 locally):

```bash
docker run -p 8080:3011 express-vue-app
```

Stop and remove the container:

```bash
docker stop express-vue-app && docker rm express-vue-app
```

### Using docker compose

```bash
docker compose up --build      # build and start
docker compose up -d           # start detached
docker compose down            # stop and remove
```
