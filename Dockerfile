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

# Change group to root (0) and grant group read/write/execute permissions to /app
# This allows the arbitrary UID assigned by OpenShift (which is in group 0) to write.
RUN chgrp -R 0 /app && \
    chmod -R g+rwX /app

# Switch to the node user. The process will run as this user if not overridden by OpenShift,
# but the important part for permissions is the group ownership set above.
USER node

# Install production dependencies (vite is needed for vite preview)
RUN npm install --omit=dev

# Expose port 8080 (as defined in the start script)
EXPOSE 8080

# Start the application using npm start
CMD ["npm", "run", "start"] 