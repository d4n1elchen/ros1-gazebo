FROM ros:melodic-ros-base-bionic

# Install dependencies
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    ros-melodic-ros-control=0.18.1-1* \
    ros-melodic-gazebo-ros-control=2.8.7-1* \
    ros-melodic-ros-controllers=0.17.0-1* \
    ros-melodic-ackermann-msgs=1.0.1-0* \
    python-empy \
    python-opencv \
    libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /race-on-ws/src

# Install Source Code
RUN git clone https://github.com/wjwwood/serial.git && cd serial && git checkout cbcca7c && cd .. && \
    git clone https://github.com/mit-racecar/racecar.git && cd racecar && git checkout 5fce2cc && cd .. && \
    git clone https://github.com/mit-racecar/vesc.git && cd vesc && git checkout 5127d60 && cd .. && \
    git clone https://github.com/d4n1elchen/raceon.git && cd raceon && git checkout 952a596 && cd .. && \
    git clone https://github.com/d4n1elchen/raceon_simulation.git && cd raceon_simulation && git checkout 6f7ca8e && cd .. && \
    git clone https://github.com/d4n1elchen/raceon_visualizer.git && cd raceon_visualizer && git checkout 0326a7b && cd .. && \
    git clone https://github.com/d4n1elchen/racecar_gazebo.git && cd racecar_gazebo && git checkout bfe03fe
    
WORKDIR /race-on-ws

RUN ["bash", "-c", "source /opt/ros/melodic/setup.bash && catkin_make"]

RUN rosdep update --rosdistro $ROS_DISTRO
 
# To run on GitHub actions
ENTRYPOINT ["bash", "/github/workspace/run.sh"]
