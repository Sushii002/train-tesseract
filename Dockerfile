# Set docker image
FROM ubuntu:22.04

# Skip the configuration part
ENV DEBIAN_FRONTEND noninteractive

# Update and install depedencies
RUN apt-get update && \
    apt-get install -y wget unzip bc nano python3-pip libleptonica-dev git libhdf5-dev

# Packages to complie Tesseract
RUN apt-get install -y --reinstall make && \
    apt-get install -y g++ autoconf automake libtool pkg-config libpng-dev libjpeg8-dev libtiff5-dev libicu-dev \
        libpango1.0-dev autoconf-archive

# Set working directory
WORKDIR /app

# Copy requirements into the container at /app
COPY requirements.txt ./

# Getting tesstrain: beware the source might change or not being available
# Complie Tesseract with training options (also feel free to update Tesseract versions and such!)
# Getting data: beware the source might change or not being available
RUN mkdir src && cd /app/src && \
    wget https://github.com/tesseract-ocr/tesseract/archive/4.1.0.zip && \
	unzip 4.1.0.zip && \
    cd /app/src/tesseract-4.1.0 && ./autogen.sh && ./configure && make && make install && ldconfig && \
    make training && make training-install

# Copy the current directory contents into the container at /usr/local/share/tessdata
COPY fra.traineddata /usr/local/share/tessdata/
COPY eng.traineddata /usr/local/share/tessdata/

# Setting the data prefix
ENV TESSDATA_PREFIX=/usr/local/share/tessdata

# Upgrades
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
# wheel


# Skip RUST installation for cryptography dependence
# ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

# Install libraries using pip installer
RUN pip3 install -r requirements.txt

# Set the locale
# RUN apt-get install -y locales && locale-gen en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8
# ENV LANG=en_US.UTF-8
# ENV LANGUAGE=en_US.UTF-8

# make training MODEL_NAME=dws START_MODEL=fra PSM=7 TESSDATA=/usr/local/share/tessdata