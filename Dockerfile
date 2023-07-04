# Use the official ROS Iron image as the base image

# for arm64v8 architecture (M1 Mac, etc), use:
FROM arm64v8/ros:iron

# for other, use:
# FROM osrf/ros:iron-desktop


ARG ROS_DISTRO=iron

# Install build tools
RUN apt-get update && apt-get install -y \
	tmux \
    build-essential \
    cmake \
	ros-$ROS_DISTRO-demo-nodes-py \
	ros-$ROS_DISTRO-demo-nodes-cpp \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /ros2
 
# src/ to /ros2/src
COPY ./src ./src

# Build the workspace, install the package
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash"
#	&& colcon build --symlink-install \
#	&& source install/setup.bash"

# Source the ROS environment and your workspace in every new shell
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
#	echo "colcon build --symlink-install" >> ~/.bashrc && \
#    echo "source /ros2/install/setup.bash" >> ~/.bashrc
