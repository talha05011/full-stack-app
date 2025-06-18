# Stage 1: Install dependencies
FROM node:16-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Run the application
FROM node:16-alpine

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/ ./

EXPOSE 5000
CMD ["npm", "start"]
