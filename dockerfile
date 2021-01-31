FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setting timezone 
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Dependencies
RUN apt-get update

RUN apt-get install -yq g++  make  automake libtool xutils-dev m4  libreadline-dev \
  libgsl0-dev libglu-dev libgl1-mesa-dev freeglut3-dev  libopenscenegraph-dev \
	libqt4-dev libqt4-opengl libqt4-opengl-dev qt4-qmake  libqt4-qt3support gnuplot \
	gnuplot-x11 libncurses5-dev libgl1-mesa-dev mesa-utils libgl1-mesa-glx binutils
	
# Install lpzrobots
COPY lpzrobots /lpzrobots
COPY Makefile.conf /lpzrobots/
WORKDIR /lpzrobots
RUN make all -j4

# Get clangd-11
RUN apt-get install -yq wget software-properties-common
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-11 main"
RUN apt-get update
RUN apt-get install -yq clangd-11

# Cmake
run apt-get install -yq cmake 

# Clean up
RUN apt-get remove -yq wget software-properties-common
RUN apt-get autoremove -yq
RUN rm -rf /var/lib/apt/lists/*

# Setup user 
RUN useradd -m user -p user
RUN usermod -aG sudo user 

USER user

