# Start from a Debian Bullseye image
FROM debian:bullseye

# Set non-interactive frontend for debconf
ENV DEBIAN_FRONTEND noninteractive

# Set the working directory in the container
WORKDIR /tensorflow

# Install basic dependencies and build tools
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    git \
    wget \
    unzip \
    python3 \
    python3-pip \
    cmake \
    libusb-1.0-0-dev \
    pkg-config \
    apt-transport-https \
    curl \
    gnupg \
    libabsl-dev \
    libflatbuffers-dev

# Install Bazel (required for building TensorFlow)
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg && \
    mv bazel-archive-keyring.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    apt-get update && apt-get install -y bazel-3.7.2

# Install Python and Pip
RUN apt-get update && apt-get install -y \
python3 \
python3-pip

# Create a symlink for Python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install numpy
RUN pip3 install numpy

# Verify Numpy Installation
RUN python3 -c "import numpy; print(numpy.__version__)"

# Clone the TensorFlow repository and checkout version 2.5.0
RUN git clone https://github.com/tensorflow/tensorflow.git . && \
    git checkout v2.5.0

# Configure TensorFlow build (no CUDA support)
# Add commands to handle non-interactive configuration
# Install Bazel
RUN apt-get update && apt-get install -y apt-transport-https curl gnupg
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
RUN mv bazel-archive-keyring.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
#RUN apt-get update && apt-get install -y bazel-3.7.2
RUN wget https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-linux-x86_64 -O /usr/local/bin/bazel && \
    chmod +x /usr/local/bin/bazel
# Verify Bazel Installation
RUN bazel --version
# Print PATH
RUN echo $PATH


# Build TensorFlow Lite
RUN bazel build -c opt //tensorflow/lite:libtensorflowlite.so

# Install debhelper for building libedgetpu
RUN apt-get update && apt-get install -y \
debhelper

# Set up a new working directory for libedgetpu
WORKDIR /libedgetpu

# Clone and build libedgetpu
#RUN git clone https://coral.googlesource.com/libedgetpu /libedgetpu
#WORKDIR /libedgetpu

# Clone and build libedgetpu
RUN git clone https://github.com/google-coral/libedgetpu.git /libedgetpu
WORKDIR /libedgetpu
RUN TFROOT=/tensorflow make -f makefile_build/Makefile -j$(nproc) libedgetpu

#RUN bash ./scripts/install.sh
RUN echo "Y" | bash ./scripts/install.sh


# Build libedgetpu
#RUN dpkg-buildpackage -b -uc -us

# Set environment variables to make the libraries available
ENV LD_LIBRARY_PATH=/tensorflow/bazel-bin/tensorflow/lite:/libedgetpu

# Cleanup to reduce image size (optional)
# RUN apt-get remove --purge -y <packages_to_remove> && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tensorflow /libedgetpu

# Reset the frontend to its default value
ENV DEBIAN_FRONTEND newt
