FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setting timezone 
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Dependencies
RUN apt-get update

RUN apt-get install -yq g++ wget make git  automake libtool xutils-dev m4  libreadline-dev \
  libgsl0-dev libglu-dev libgl1-mesa-dev freeglut3-dev  libopenscenegraph-dev \
	libqt4-dev libqt4-opengl libqt4-opengl-dev qt4-qmake  libqt4-qt3support gnuplot \
	gnuplot-x11 libncurses5-dev libgl1-mesa-dev mesa-utils libgl1-mesa-glx binutils
	
#Prepare workspace
WORKDIR /workspace

# Install lpzrobots
RUN git clone https://github.com/pmanoonpong/lpzrobots.git
WORKDIR /workspace/lpzrobots
RUN wget https://raw.githubusercontent.com/askebm/TAI-Docker/master/Makefile.conf
RUN make all -j6

# INSTALL gorobots
RUN ln -sf /home/user/workspace/lpzrobots/opende/ode/src/.libs/libode_dbl.so.1 /lib/libode_dbl.so.1
WORKDIR /workspace
RUN git clone https://github.com/pmanoonpong/gorobots_edu.git
RUN cp lpzrobots/ode_robots/simulations/template_amosii/Makefile gorobots_edu/practices/amosii
WORKDIR /workspace/gorobots_edu/practices/amosii
RUN make

# Get clangd-11
RUN apt-get install -yq wget software-properties-common
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-11 main"
RUN apt-get update
RUN apt-get install -yq clangd-11

# Get cmake
RUN apt-get install -yq cmake 

# Clean up
RUN apt-get remove -yq wget software-properties-common
RUN apt-get autoremove -yq
RUN rm -rf /var/lib/apt/lists/*

# Setup user 
RUN useradd -m user -p user	
RUN usermod -aG sudo user 
USER user

#Paths and stuff
RUN export PATH=/home/user/bin:$PATH
