#!/bin/bash

# Actualizar paquetes
apt-get update
apt-get upgrade -y
apt-get clean

# Limpiar logs
find /var/log/cron -type f -ctime +30 -exec rm {} \;

# Get the container's hostname
container_name=$(hostname)

# Check the container's health
container_health=$(docker inspect --format "{{.State.Health.Status}}" $container_name)

if [[ $container_health != "healthy" ]]; then
  echo "Container $container_name is not healthy. Restarting..."
  docker restart $container_name
fi