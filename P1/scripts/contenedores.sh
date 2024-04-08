#!/bin/bash

# Check if container name and image name are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Container name and image name are required."
  exit 1
fi

# Set container name and image name from arguments
container_name=$1
image_name=$2

# Check if image exists locally
if [[ "$(docker images -q $image_name 2> /dev/null)" == "" ]]; then
  echo "Image '$image_name' not found locally. Attempting to pull from Docker Hub..."
  docker pull $image_name
  if [ $? -ne 0 ]; then
    echo "Error: Failed to pull image '$image_name' from Docker Hub."
    exit 1
  fi
fi

# Create the container with specified configuration
docker run -d \
  --name $container_name \
  -v ./web_santicolle:/var/www/html/ \
  -p 8090:80 \
  --cap-add NET_ADMIN \
  --user root \
  --restart always \
  --network red_web \
  --ip 192.168.10.10 \
  --hostname servidor-web \
  $image_name
