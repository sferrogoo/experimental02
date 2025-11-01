# Dockerfile for the Image Gallery Web Application

# Stage 1: Build the React frontend
FROM node:18-alpine AS build-client

WORKDIR /app/client

# Copy package.json and package-lock.json
COPY client/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the client-side code
COPY client/ ./

# Build the React app
RUN npm run build

# Stage 2: Build the Node.js backend
FROM node:18-alpine AS build-server

WORKDIR /app/server

# Copy package.json and package-lock.json
COPY server/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the server-side code
COPY server/ ./

# Stage 3: Create the final image
FROM node:18-alpine

WORKDIR /app

# Copy the built frontend from the build-client stage
COPY --from=build-client /app/client/build ./client/build

# Copy the backend from the build-server stage
COPY --from=build-server /app/server ./server

# Expose the port the app will run on
EXPOSE 3000

# Set the command to start the server
CMD ["node", "server/server.js"]
