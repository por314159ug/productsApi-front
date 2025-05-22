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

# Copy built assets, package files, and vite config
COPY --from=builder /app/dist ./dist
COPY package*.json ./
COPY vite.config.js ./

# Change ownership of the /app directory to the node user
# This allows npm install (if it creates/modifies files in /app outside node_modules) 
# and vite preview to write necessary files (like the timestamp file).
RUN chown -R node:node /app

# Switch to the node user explicitly, good practice though often default for CMD
USER node

# Install production dependencies (vite is needed for vite preview)
# This will now run as the 'node' user, writing to node_modules within /app
RUN npm install --omit=dev

# Expose port 8080 (as defined in the start script)
EXPOSE 8080

# Start the application using npm start
CMD ["npm", "run", "start"] 