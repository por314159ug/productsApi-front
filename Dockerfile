# Stage 1: Build the React application
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the application using the start script
FROM node:20-alpine
WORKDIR /app

# Copy built assets and necessary files
COPY --from=builder /app/dist ./dist
COPY package*.json ./
COPY vite.config.js ./

# Install production dependencies (vite is needed for vite preview)
RUN npm install --omit=dev

# Expose port 8080 (as defined in the start script)
EXPOSE 8080

# Start the application using npm start
CMD ["npm", "run", "start"] 