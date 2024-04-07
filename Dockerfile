# Use an official Python runtime as a parent image
FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

# Install Python 3.8 and pip
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3-pip \
    python3.8-dev \
    python3.8-venv \
    && rm -rf /var/lib/apt/lists/*

# Update alternatives to prioritize Python 3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Update pip and ensure it is associated with Python 3.8
RUN python3.8 -m pip install --upgrade pip && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Set python3.8 as the default python
RUN update-alternatives --set python3 /usr/bin/python3.8

# Make python3 and pip commands available as python and pip
RUN if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi && \
    if [ ! -f /usr/bin/pip ]; then ln -s /usr/bin/pip3 /usr/bin/pip; fi

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV HOME /tmp


