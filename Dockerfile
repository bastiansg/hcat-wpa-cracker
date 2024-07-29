FROM nvcr.io/nvidia/cuda:12.4.1-runtime-ubuntu22.04

# ref: https://github.com/dizcza/docker-hashcat/blob/master/Dockerfile
LABEL com.nvidia.volumes.needed="nvidia_driver"
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    clinfo \
    pkgconf \
    pciutils \
    libz-dev \
    libssl-dev \
    zlib1g-dev \
    libpcap-dev \
    build-essential \
    ocl-icd-libopencl1 \
    libcurl4-openssl-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /tmp/*

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH=/usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

WORKDIR /root

RUN update-pciids

ARG HASHCAT_VERSION
RUN git clone https://github.com/hashcat/hashcat.git \
    && cd hashcat \
    && git checkout ${HASHCAT_VERSION} \
    && make install -j

ARG HASHCAT_UTILS_VERSION
RUN git clone https://github.com/hashcat/hashcat-utils.git \
    && cd hashcat-utils/src \
    && git checkout ${HASHCAT_UTILS_VERSION} && make \
    && ln -s /root/hashcat-utils/src/cap2hccapx.bin /usr/bin/cap2hccapx

ARG HCXTOOLS_VERSION
RUN git clone https://github.com/ZerBea/hcxtools.git \
    && cd hcxtools \
    && git checkout ${HCXTOOLS_VERSION} && make install

ARG HCXDUMPTOOL_VERSION
RUN git clone https://github.com/ZerBea/hcxdumptool.git \
    && cd hcxdumptool \
    && git checkout ${HCXDUMPTOOL_VERSION} && make install

ARG HCXKEYS_VERSION
RUN git clone https://github.com/hashcat/kwprocessor.git \
    && cd kwprocessor \
    && git checkout ${HCXKEYS_VERSION} && make \
    && ln -s /root/kwprocessor/kwp /usr/bin/kwp

WORKDIR /root/hcat-cracker
# ENTRYPOINT ["/bin/bash"]

COPY entrypoint.sh .
ENTRYPOINT bash entrypoint.sh
