# Stage 1: Build the React application
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the application using Vite's preview server
FROM node:18-alpine
WORKDIR /app

# Copy built assets and necessary files
COPY --from=builder /app/dist ./dist
COPY package.json ./
COPY vite.config.js ./

# Install dependencies needed for vite preview
# We install all dependencies from package.json as vite preview might need them
RUN npm install --omit=dev

# Expose port 80
EXPOSE 80

# Start the application using vite preview on port 80
CMD ["npm", "run", "preview", "--", "--port", "80"] 