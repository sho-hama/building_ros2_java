FROM ubuntu:18.04

ARG APT_FLAGS="-q -y --no-install-recommends --no-install-suggests"

# Set Environements Variables
ENV INITRD="no" \
    DEBIAN_FRONTEND="noninteractive" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    JAVA_AWT_INCLUDE_PATH="/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64" \
    JAVA_INCLUDE_PATH="/usr/lib/jvm/java-8-openjdk-amd64/include" \
    JAVA_INCLUDE_PATH2="/usr/lib/jvm/java-8-openjdk-amd64/include/linux" \
    JAVA_AWT_LIBRARY="/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/libjawt.so" \
    JAVA_JVM_LIBRARY="/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so" \
    OSPL_URL="file:///usr/etc/opensplice/config/ospl.xml"

# Base Build Stack

RUN apt-get update && \
    apt-get install ${APT_FLAGS} \
        gnupg \
        git \
        curl \
        wget \
        apt-utils \
        locales && \
    locale-gen en_US.UTF-8 && \
    touch /usr/share/locale/locale.alias && \
    mkdir -p /usr/share/man/man1 && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# ROS2 Build Stack
RUN /usr/bin/wget -qO - http://packages.ros.org/ros.key | apt-key add - && \
    /usr/bin/wget -qO - http://packages.osrfoundation.org/gazebo.key | apt-key add - && \
    echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list && \
    echo "deb http://packages.osrfoundation.org/gazebo/ubuntu bionic  main" > /etc/apt/sources.list.d/gazebo-latest.list && \
    apt-get update && \
    apt-get install ${APT_FLAGS} \
        gradle \
        openjdk-8-jdk \
        openjdk-8-jdk-headless \
        openjdk-8-jre \
        openjdk-8-jre-headless \
        libhawtjni-runtime-java \
        build-essential \
        cppcheck \
        cmake \
        libopencv-dev \
        python3-empy \
        python3-catkin-pkg-modules \
        python3-dev \
        python3-empy \
        python3-nose \
        python3-pip \
        python3-pyparsing \
        python3-pytest \
        python3-pytest-cov \
        python3-setuptools \
        python3-vcstool \
        libtinyxml-dev \
        libeigen3-dev \
        libassimp-dev \
        libpoco-dev \
        python3-colcon-common-extensions \
        clang-format \
        pydocstyle \
        pyflakes \
        python3-coverage \
        python3-mock \
        python3-pep8 \
        uncrustify \
        libasio-dev \
        libtinyxml2-dev \
        python3-argcomplete \
        clang \
        libssl-dev \
        openssl && \
    pip3 install flake8 flake8-import-order && \
    rm -rf /var/lib/apt/lists/*

# Setup VNC
ENV USER root
RUN apt-get update && \
    apt-get install ${APT_FLAGS} ubuntu-desktop && \
    apt-get install ${APT_FLAGS} xfce4 xfce4-goodies tightvncserver && \
    mkdir /root/.vnc

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd
RUN chmod +x /root/.vnc/xstartup

CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 16 && tail -f /root/.vnc/*:1.log
EXPOSE 5901

