#!/bin/bash

CONTAINER_NAME=my-ros2

NETWORK_NAME="ros-net"

# Check if the Docker network exists
if ! docker network ls | grep -q $NETWORK_NAME; then
	docker network create $NETWORK_NAME
fi


# Check if the container already exists
if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    # Check if the container is running
    if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
        echo "Container is already running"
    else
        echo "Container exists but is not running, starting container..."
        docker start $CONTAINER_NAME
    fi

    echo "Connecting to the container..."
    docker exec -it $CONTAINER_NAME bash
else
    # If the container does not exist, build the image and run the container
    echo "Building the Docker image and running the container..."
    docker build -t ros2:latest .
    docker run --network ros-net -it -v $(pwd)/src:/ros2/src --name $CONTAINER_NAME ros2:latest
fi

