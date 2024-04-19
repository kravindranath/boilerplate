# syntax=docker/dockerfile:1.4

# 2. For Nginx setup
FROM nginx:alpine

RUN apt-get update && apt-get install -y \
    docker \
    docker-compose \

    # Set working directory
    WORKDIR /app

# Copy Docker tools from the builder stage
COPY --from=builder /usr/bin/docker /usr/bin/docker
COPY --from=builder /usr/bin/docker-compose /usr/bin/docker-compose
# Add any other tools you copied in the builder stage here

# Copy config nginx
COPY --from=build /app/config/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
COPY . /app

ENV CI=true
ENV PORT=3000

# Same as npm install
RUN npm ci

WORKDIR /usr/share/nginx/html

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]

CMD [ "npm", "start" ]

FROM development AS build

RUN npm run build

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


