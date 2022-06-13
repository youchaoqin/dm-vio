# base image from nvcr.io, ubuntu20.04
ARG FROM_IMAGE=nvcr.io/nvidia/cuda:11.0.3-devel-ubuntu20.04
FROM $FROM_IMAGE

# add aliyun source
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list


############# ros1-noetic, including cmake, opencv, boost, eigen, pcl, ... #############
# http://wiki.ros.org/noetic/Installation/Ubuntu

ARG DEBIAN_FRONTEND=noninteractive

# setup source to USTC, it's faster than the original one in China
RUN apt update && apt install -y \
      lsb-release \
    && rm -rf /var/lib/apt/lists/*
RUN sh -c '. /etc/lsb-release && echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'

# setup keys
# RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
COPY ./ros.asc /tmp/
RUN apt-key add /tmp/ros.asc && rm /tmp/ros.asc

# install ros1 packages
RUN apt update && apt install -y \
      ros-noetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# install dependencies for building packages
RUN apt update && apt install -y \
      python3-rosdep \
      python3-rosinstall \
      python3-rosinstall-generator \
      python3-wstool \
      build-essential \
    && rm -rf /var/lib/apt/lists/*

############## usefull tools ##############
RUN apt-get update && apt-get install -y \
      vim \
      curl \
    && rm -rf /var/lib/apt/lists/*

############# Required Dependencies #############
RUN apt update && apt install -y \
      libsuitesparse-dev \
      libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

############# GTSAM #############
RUN apt-get update && apt-get install -y \
      libtbb-dev \
    && rm -rf /var/lib/apt/lists/*

COPY ./packages/gtsam-4.2a6.zip /tmp
RUN cd /tmp \
    && unzip gtsam-4.2a6.zip \
    && cd gtsam-4.2a6 \
    && mkdir build \
    && cd build \
    && cmake .. \
        -DGTSAM_POSE3_EXPMAP=ON \
        -DGTSAM_ROT3_EXPMAP=ON \
        -DGTSAM_USE_SYSTEM_EIGEN=ON \
        -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF .. \
        -DCMAKE_INSTALL_PREFIX=/usr/local/gtsam-4.2a6 \
    && make "-j$(($(nproc)-1))" \
    && make install \
    && cd /tmp \
    && rm -r gtsam-4.2a6 \
    && rm gtsam-4.2a6.zip

############# Pangolin #############
RUN apt-get update && apt-get install -y \
      libgl1-mesa-dev \
      libglew-dev \
      pkg-config \
      libegl1-mesa-dev \
      libwayland-dev \
      libxkbcommon-dev \
      wayland-protocols \
    && rm -rf /var/lib/apt/lists/*

COPY ./packages/Pangolin-0.6.tar.gz /tmp
RUN cd /tmp \
    && tar -xf Pangolin-0.6.tar.gz \
    && cd Pangolin-0.6 \
    && mkdir build \
    && cd build \
    && cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr/local/Pangolin-0.6 \
    && cmake --build . \
    && make install \
    && cd /tmp \
    && rm -r Pangolin-0.6 \
    && rm Pangolin-0.6.tar.gz

############# setup ENVs #############
ENV NVIDIA_DRIVER_CAPABILITIES compute,graphics,utility,video,display

############# make dirs, files #############
RUN cd / \
    && mkdir /slam \
    && chmod -R 777 /slam

############# setup ENTRYPOINT #############
ENTRYPOINT ["/bin/bash"]

