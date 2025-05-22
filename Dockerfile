# Stage 1: Build the React application
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the application using a lightweight server
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist /app/dist

# Install serve globally
RUN npm install -g serve

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["serve", "-s", "dist", "-l", "80"] 
