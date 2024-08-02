# Use a minimal base image for efficiency
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all remaining application files
COPY . .

# Build step (if applicable)
# RUN npm run build  # Replace with your build command if necessary

# Switch to a smaller runtime image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy environment configuration file (optional)
COPY .env ./  # Replace with your environment file name if different

# Expose port (adjust if needed)
EXPOSE 3000

# Load environment variables from file (optional)
ENV $(cat .env)  # Replace with your environment file name if different

# Start the application
CMD [ "node", "index.js" ]
