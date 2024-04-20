# syntax=docker/dockerfile:1

# Use the official Node.js runtime as the base image
# 1. For build React app
FROM node:lts AS development

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# Install dependencies
RUN npm ci

# Copy application folder
COPY . /app

# Set port and CI variables
ENV CI=true
ENV PORT=3000

# Start the react application
CMD [ "npm", "start" ]

# Get ser
FROM development AS build

# Build the React app for production
RUN npm run build

# Install git in the docker container
FROM development as dev-envs
RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends git
EOF

RUN <<EOF
useradd -s /bin/bash -m vscode
groupadd docker
usermod -aG docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
CMD [ "npm", "start" ]

# 2. For Nginx setup
FROM nginx:alpine

# Copy config nginx
COPY --from=build /app/src/config/nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]





