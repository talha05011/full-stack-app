# Stage 1: Build
FROM node:16-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Runtime
FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app .
# Inject build version
ARG DEPLOY_VERSION
ENV DEPLOY_VERSION=${DEPLOY_VERSION}
EXPOSE 5000
CMD ["node", "server.js"]
