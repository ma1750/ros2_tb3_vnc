FROM dorowu/ubuntu-desktop-lxde-vnc:focal
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get update && apt-get install -y curl gnupg2 lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" keyboard-configuration ros-foxy-desktop
RUN apt-get install -y ros-foxy-gazebo-* ros-foxy-cartographer ros-foxy-cartographer-ros ros-foxy-navigation2 ros-foxy-nav2-bringup ros-foxy-dynamixel-sdk ros-foxy-turtlebot3-msgs ros-foxy-turtlebot3 python3-colcon-common-extensions git
RUN mkdir -p /root/turtlebot3_ws/src/ && \
    cd /root/turtlebot3_ws/src/ && \
    git clone -b foxy-devel --depth 1 https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git && \
    cd /root/turtlebot3_ws && \
    source /opt/ros/foxy/setup.bash && \
    colcon build --symlink-install
RUN apt-get update && \
    apt-get install -y python3-cairocffi && \
    mkdir -p /root/bag_tool_ws/src && \
    cd /root/bag_tool_ws/src && \
    git clone --depth 1 https://github.com/ros2/rcl_interfaces.git -b foxy && \
    git clone --depth 1 https://github.com/ros2/test_interface_files.git -b foxy && \
    git clone --depth 1 https://github.com/ros2/pybind11_vendor.git -b foxy && \
    git clone --depth 1 https://github.com/ros2/rosbag2.git -b foxy-future && \
    git clone --depth 1 https://github.com/ros-visualization/rqt_bag.git -b ros2 && \
    cd /root/bag_tool_ws && \
    source /opt/ros/foxy/setup.bash && \
    colcon build --symlink-install
RUN echo "export LANG=en_US.UTF-8" >> /root/.bashrc && \
    echo "export XDG_RUNTIME_DIR=/root" >> /root/.bashrc && \
    echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc && \
    echo "source /root/turtlebot3_ws/install/setup.bash" >> /root/.bashrc && \
    echo "source /root/bag_tool_ws/install/setup.bash" >> /root/.bashrc && \
    echo "export ROS_DOMAIN_ID=30" >> /root/.bashrc && \
    echo "export TURTLEBOT3_MODEL=burger" >> /root/.bashrc && \
    source /root/.bashrc
RUN mkdir -p /root/.config/lxpanel/LXDE/panels && \
    cd /root/.config/lxpanel/LXDE/panels && wget -O panel -q https://gist.githubusercontent.com/ma1750/baddf8885f8e8bd4e957118039b09ffc/raw/c2b3ad1fc8234b8ec337c6cd034712386d12a5d1/panel

