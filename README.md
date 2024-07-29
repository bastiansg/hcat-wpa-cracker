# Hashcat WPA Cracker
A Dockerized tool for cracking WPA/WPA2 passwords using Hashcat.

## Setup
#### 1. Clone the Repository:
```bash
$ git clone https://github.com/bastiansg/hcat-wpa-cracker.git
```

#### 2. Install Make:
```bash
$ sudo apt update
$ sudo apt install make
```

#### 3. Install Docker
Follow the instructions [here](https://docs.docker.com/engine/install/ubuntu/) to install Docker and include the `compose plugin`. Ensure that Buildkit is enabled as described [here](https://docs.docker.com/build/buildkit/).

#### 4. Install NVIDIA Container Toolkit:
Follow the installation guide [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html).

## Build
To build the Docker image, run:
```bash
$ make build
```

## Usage
To run the WPA cracker, use:
```bash
$ make run PCAP_FILE=[PCAP_FILE] DICT_FILE=[DICT_FILE]
```
Replace **PCAP_FILE** with the path to the capture file containing at least one handshake, and **DICT_FILE** with the path to the dictionary file used for cracking.

#### Example
```bash
$ make run PCAP_FILE=handshake.pcap DICT_FILE=dictionary.txt
```
