#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

CONTAINER_NAME="my-ros2"
NETWORK_NAME="ros-net"

# Function to handle exit signal
on_exit() {
    echo -e "${RED}Exiting the container...${NC}"
    docker stop $CONTAINER_NAME >/dev/null 2>&1 &
}

# Set the exit trap
trap on_exit EXIT

# Check if the Docker network exists
if ! docker network ls | grep -q $NETWORK_NAME; then
    docker network create $NETWORK_NAME
fi

# Check if the container already exists
if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    # Check if the container is running
    if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
        echo -e "Container is ${GREEN}already running${NC}"
    else
        echo -e "Container exists but is ${RED}not running${NC}, starting container..."
        docker start $CONTAINER_NAME >/dev/null 2>&1
    fi

    echo -e "${GREEN}Connecting to the container...${NC}"
    docker exec -it $CONTAINER_NAME bash
else
    # If the container does not exist, build the image and run the container
    echo -e "${GREEN}Building the Docker image...${NC}"
    docker build -t ros2:latest .

    echo -e "${GREEN}Connecting to the container...${NC}"
    docker run --network ros-net -it -v $(pwd)/src:/ros2/src --name $CONTAINER_NAME ros2:latest
fi
