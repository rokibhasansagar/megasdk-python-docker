FROM python:3-slim-buster

ENV DEBIAN_FRONTEND=noninteractive
ENV MEGA_SDK_VERSION '3.8.3a'

RUN set -xe \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
        git g++ gcc autoconf automake \
        m4 libtool qt4-qmake make libqt4-dev libcurl4-openssl-dev \
        libcrypto++-dev libsqlite3-dev libc-ares-dev \
        libsodium-dev libnautilus-extension-dev \
        libssl-dev libfreeimage-dev swig libpython3-dev \
    && apt-get -y autoremove \
    && mkdir -p /tmp 2>/dev/null && cd /tmp \
    && git clone https://github.com/meganz/sdk.git sdk && cd sdk \
    && git checkout v$MEGA_SDK_VERSION \
    && ./autogen.sh && ./configure --disable-silent-rules --enable-python --with-python3 --with-sodium --disable-examples \
    && make -j$(nproc --all) \
    && ls -lAog bindings/ \
    && cd bindings/python/ && python3 setup.py bdist_wheel \
    && du -sh dist && cd dist/ && ls -lAog \
    && pip3 install --no-cache-dir megasdk-*.whl \
    && cd /tmp && rm -rf sdk
