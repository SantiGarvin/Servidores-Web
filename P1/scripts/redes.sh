#!/bin/bash

# Check if network name and IP address are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Network name and IP address are required."
  exit 1
fi

# Set network name and IP address from arguments
network_name=$1
ip_address=$2

# Create the network with the specified IP address and subnet mask
docker network create --subnet $ip_address $network_name
