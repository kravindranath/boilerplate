# Use the official Node.js image as base
FROM node:lts AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code to the working directory
COPY . .

# Run the build command
RUN npm run build

# Use NGINX image as the final base image
FROM nginx:alpine

# Copy custom NGINX configuration file with Cache-Control header
# COPY nginx.conf /etc/nginx/nginx.conf

# WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
# RUN rm -rf ./*

# Copy the built files from the previous stage to NGINX's default HTML directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run NGINX
CMD ["nginx", "-g", "daemon off;"]