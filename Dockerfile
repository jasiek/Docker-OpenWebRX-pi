FROM arm32v7/debian:stretch-slim
COPY qemu-arm-static /usr/bin

MAINTAINER harenberg@gmail.com

RUN apt-get update && \
    apt-get install -y wget libusb-1.0-0-dev pkg-config ca-certificates git-core cmake build-essential --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN mkdir -p /etc/modprobe.d
RUN echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/raspi-blacklist.conf && \
    git clone git://git.osmocom.org/rtl-sdr.git && \
    mkdir rtl-sdr/build && \
    cd rtl-sdr/build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && \
    make && \
    make install && \
    ldconfig && \
    rm -rf /tmp/rtl-sdr


RUN apt-get update && \
    apt-get install -y libfftw3-dev nmap python2.7 vim --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ENV commit_id 1080e4ad237ab37e7d95129ff6aae73fa118f7c5


# csdr needed a patch to compile on a Pi. I kept the patched version here
RUN git clone https://github.com/jasiek/csdr.git && \
    cd csdr && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/csdr

WORKDIR /opt

ENV commit_id 1d19b07833e63761a507bcb73e9c56f081c751a4
ENV branch master

RUN git clone https://github.com/simonyiszk/openwebrx.git && \
    cd openwebrx && \
    git checkout $branch && \
    git reset --hard $commit_id

WORKDIR /opt/openwebrx

EXPOSE 8073 8888 4951

CMD ["python2.7", "openwebrx.py"]
