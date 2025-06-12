ARG UBUNTU_VERSION=24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Europe/London

FROM ubuntu:${UBUNTU_VERSION}

##########################################
# Arguments
##########################################

# Requirements to Verify Python Install
ARG CURL_VERSION="8.5.0-2ubuntu10.6" # https://packages.ubuntu.com/noble/curl
ARG CA_CERTIFICATES_VERSION="20240203" # https://packages.ubuntu.com/noble/ca-certificates
ARG GOLANG_GO_VERSION="2:1.22~2build1" # https://packages.ubuntu.com/noble/golang-go
ARG TAR_VERSION="1.35+dfsg-3build1" # https://packages.ubuntu.com/noble/tar
ARG TUF_VERSION="v0.7.0" # https://pkg.go.dev/github.com/theupdateframework/go-tuf/cmd/tuf-client
ARG COSIGN_VERSION="v2.5.0" # https://github.com/sigstore/cosign/releases

# Python Requirements from (https://devguide.python.org/getting-started/setup-building/#install-dependencies)
ARG PYTHON_VERSION="3.9.21" # https://github.com/krentzd/napari-clemreg requires python3.9
ARG BUILD_ESSENTIAL_VERSION="12.10ubuntu1" # https://packages.ubuntu.com/noble/build-essential
ARG GDB_VERSION="15.0.50.20240403-0ubuntu1" # https://packages.ubuntu.com/noble/gdb
ARG LCOV_VERSION="2.0-4ubuntu2" # https://packages.ubuntu.com/noble/lcov
ARG PKG_CONFIG_VERSION="1.8.1-2build1" # https://packages.ubuntu.com/noble/pkg-config
ARG LIBBZ2_DEV_VERSION="1.0.8-5.1build0.1" # https://packages.ubuntu.com/noble/libbz2-dev # After testing required to add build0.1
ARG LIBFFI_DEV_VERSION="3.4.6-1build1" # https://packages.ubuntu.com/noble/libffi-dev
ARG LIBGDBM_DEV_VERSION="1.23-5.1build1" # https://packages.ubuntu.com/noble/libgdbm-dev
ARG LIBGDBM_COMPAT_DEV_VERSION="1.23-5.1build1" # https://packages.ubuntu.com/noble/libgdbm-compat-dev
ARG LIBLZMA_DEV_VERSION="5.6.1+really5.4.5-1ubuntu0.2" # https://packages.ubuntu.com/noble/liblzma-dev
# LIBNCURSES5 is not used as it is not supported on ubuntu 24.04 so libncurses-dev is used instead
ARG LIBNCURSES_DEV_VERSION="6.4+20240113-1ubuntu2" # https://packages.ubuntu.com/noble/libncurses-dev
# libreadline6-dev is a virtual package so no VERSION is provided however it is from libreadline-dev so this is specified instead
# see https://packages.ubuntu.com/noble/libreadline6-dev
ARG LIBREADLINE_DEV_VERSION="8.2-4build1" # https://packages.ubuntu.com/noble/libreadline-dev
ARG LIBSQLITE3_DEV_VERSION="3.45.1-1ubuntu2.3" https://packages.ubuntu.com/noble/libsqlite3-dev
ARG LIBSSL_DEV_VERSION="3.0.13-0ubuntu3.5" https://packages.ubuntu.com/noble/libssl-dev
ARG LZMA_VERSION="9.22-2.2" # https://packages.ubuntu.com/noble/lzma
ARG LZMA_DEV_VERSION="9.22-2.2" # https://packages.ubuntu.com/noble/lzma-dev
ARG TK_DEV_VERSION="8.6.14build1" # https://packages.ubuntu.com/noble/tk-dev
ARG LZMA_VERSION="9.22-2.2" # https://packages.ubuntu.com/noble/lzma
ARG LIBBZ2_DEV_VERSION="1.0.8-5.1build0.1" # https://packages.ubuntu.com/noble/libbz2-dev # After testing required to add build0.1
ARG TK_DEV_VERSION="8.6.14build1" # https://packages.ubuntu.com/noble/tk-dev
ARG UUID_DEV_VERSION="2.39.3-9ubuntu6.2" # https://packages.ubuntu.com/noble-updates/uuid-dev
ARG ZLIB1G_DEV_VERSION="1:1.3.dfsg-3.1ubuntu2.1" # https://packages.ubuntu.com/noble-updates/zlib1g-dev
ARG LIBZSTD_DEV_VERSION="1.5.5+dfsg2-2build1.1" # https://packages.ubuntu.com/noble-updates/libzstd-dev

ARG PIP_VERSION="25.1.1"
ARG NAPARI_VERSION="0.4.18"
ARG CLEMREG_VERSION="0.2.1"
ARG EMPANADA_VERSION="1.1.1"

# NAPARI Requirements from: https://github.com/napari/napari/blob/v0.4.18x/dockerfile
ARG MESA_UTILS_VERSION="9.0.0-2" # https://packages.ubuntu.com/noble/mesa-utils
ARG X11_UTILS_VERSION="7.7+6build2" # https://packages.ubuntu.com/noble/x11-utils
ARG LIBOPENGL0_VERSION="1.7.0-1build1" # https://packages.ubuntu.com/noble/libopengl0
ARG LIBGL1_VERSION="1.7.0-1build1" # https://packages.ubuntu.com/noble/libgl1
ARG LIBGLX_MESA0_VERSION="24.2.8-1ubuntu1~24.04.1" # https://packages.ubuntu.com/noble-updates/libglx-mesa0
ARG LIBGLIB2_0_0T64_VERSION="2.80.0-6ubuntu3.4" # https://packages.ubuntu.com/noble/libglib2.0-0t64
ARG LIBFONTCONFIG1_VERSION="2.15.0-1.1ubuntu2" # https://packages.ubuntu.com/noble/libfontconfig1
ARG LIBXRENDER1_VERSION="1:0.9.10-1.1build1" # https://packages.ubuntu.com/noble/libxrender1
ARG LIBDBUS_1_3_VERSION="1.14.10-4ubuntu4" # https://packages.ubuntu.com/noble/libdbus-1-3
ARG LIBXKBCOMMON_X11_0_VERSION="1.6.0-1build1" # https://packages.ubuntu.com/noble/libxkbcommon-x11-0
ARG LIBXI6_VERSION="2:1.8.1-1build1" # https://packages.ubuntu.com/noble/libxi6
ARG LIBXCB_ICCCM4_VERSION="0.4.1-1.1build3" # https://packages.ubuntu.com/noble/libxcb-icccm4
ARG LIBXCB_IMAGE0_VERSION="0.4.0-2build1" # https://packages.ubuntu.com/noble/libxcb-image0
ARG LIBXCB_KEYSYMS1_VERSION="0.4.0-1build4" # https://packages.ubuntu.com/noble/libxcb-keysyms1
ARG LIBXCB_RANDR0_VERSION="1.15-1ubuntu2" # https://packages.ubuntu.com/noble/libxcb-randr0
ARG LIBXCB_RENDER_UTIL0_VERSION="0.3.9-1build4" # https://packages.ubuntu.com/noble/libxcb-render-util0
ARG LIBXCB_XINERAMA0_VERSION="1.15-1ubuntu2" # https://packages.ubuntu.com/noble/libxcb-xinerama0
ARG LIBXCB_XINPUT0_VERSION="1.15-1ubuntu2" # https://packages.ubuntu.com/noble/libxcb-xinput0
ARG LIBXCB_XFIXES0_VERSION="1.15-1ubuntu2" # https://packages.ubuntu.com/noble/libxcb-xfixes0
ARG LIBXCB_SHAPE0_VERSION="1.15-1ubuntu2" # https://packages.ubuntu.com/noble/libxcb-shape0


##########################################
# Building
##########################################

# Security SigStore Requirments (https://docs.sigstore.dev/cosign/system_config/installation/)
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    ca-certificates=${CA_CERTIFICATES_VERSION} \
    curl=${CURL_VERSION} \
    golang-go=${GOLANG_GO_VERSION} \
    # Clean up and remove cache to reduce the image size.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

ARG GOBIN=/usr/bin/
# Steps From https://docs.sigstore.dev/cosign/system_config/installation/#downloading-the-update-framework-tuf-client
# Lates
RUN go install github.com/theupdateframework/go-tuf/cmd/tuf-client@${TUF_VERSION} \
    && curl -o sigstore-root.json "https://raw.githubusercontent.com/sigstore/root-signing/refs/heads/main/metadata/root_history/10.root.json" \
    && tuf-client init "https://tuf-repo-cdn.sigstore.dev" sigstore-root.json \
    && tuf-client get "https://tuf-repo-cdn.sigstore.dev" artifact.pub > tmpfile && mv tmpfile artifact.pub \
    && curl -o cosign-release.sig -L "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64.sig" \
    && base64 --decode cosign-release.sig > cosign-release.sig.decoded \
    && curl -o cosign -L "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64" \
    && openssl dgst -sha256 -verify artifact.pub -signature cosign-release.sig.decoded cosign \
    && rm cosign-release.sig.decoded cosign-release.sig artifact.pub sigstore-root.json \ 
    && rm -rf tuf.db
# make cosign exucatble and move to binary PATH.
RUN chmod +x cosign \
    && mv cosign /usr/bin/cosign

# Python Requirements from (https://devguide.python.org/getting-started/setup-building/#install-dependencies)
RUN apt-get -y update && apt-get  install -y --no-install-recommends \
    tar=${TAR_VERSION} \
    build-essential=${BUILD_ESSENTIAL_VERSION} \
    gdb=${GDB_VERSION} \
    lcov=${LCOV_VERSION} \
    pkg-config=${PKG_CONFIG_VERSION} \
    libbz2-dev=${LIBBZ2_DEV_VERSION} \
    libffi-dev=${LIBFFI_DEV_VERSION} \
    libgdbm-dev=${LIBGDBM_DEV_VERSION} \
    libgdbm-compat-dev=${LIBGDBM_COMPAT_DEV_VERSION} \
    liblzma-dev=${LIBLZMA_DEV_VERSION} \
    libncurses-dev=${LIBNCURSES_DEV_VERSION} \
    libreadline-dev=${LIBREADLINE_DEV_VERSION} \
    libsqlite3-dev=${LIBSQLITE3_DEV_VERSION} \
    libssl-dev=${LIBSSL_DEV_VERSION} \
    lzma=${LZMA_VERSION} \
    lzma-dev=${LZMA_DEV_VERSION} \
    tk-dev=${TK_DEV_VERSION} \
    uuid-dev=${UUID_DEV_VERSION} \
    zlib1g-dev=${ZLIB1G_DEV_VERSION} \
    libzstd-dev=${LIBZSTD_DEV_VERSION} \
    # Clean up and remove cache to reduce the image size.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Get and Install Python

RUN mkdir -p ${HOME}/opt 

WORKDIR ${HOME}/opt 

RUN curl -o Python-${PYTHON_VERSION}.tar.xz.sigstore -L "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz.sigstore" \
    && curl -o Python-${PYTHON_VERSION}.tar.xz -L "https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz" 

# Verifiy Python is secure.
RUN cosign verify-blob Python-${PYTHON_VERSION}.tar.xz \
        --bundle Python-${PYTHON_VERSION}.tar.xz.sigstore \
        --cert-identity lukasz@langa.pl \
        --cert-oidc-issuer "https://github.com/login/oauth" \
        && tar -xf Python-${PYTHON_VERSION}.tar.xz Python-${PYTHON_VERSION}/ \ 
        && rm Python-${PYTHON_VERSION}.tar.xz


# Remove Cosign and Go, Curl and CA-Certificates as they are no longer needed.
RUN rm /usr/bin/cosign  \
    && rm -rf go \
    && rm Python-${PYTHON_VERSION}.tar.xz.sigstore \ 
    && apt-get purge -y --auto-remove  \
        golang-go \
        curl \
        ca-certificates 

WORKDIR $HOME/opt/Python-${PYTHON_VERSION}
# Configure Python
RUN ./configure --enable-shared --enable-optimizations --with-lto --prefix=/usr/local LDFLAGS="-Wl,--rpath=/usr/local/lib" \
    # Install Python
    && make install --jobs $(nproc)


# Napari Requirements
RUN apt-get -y update && apt-get  install -y --no-install-recommends \
    mesa-utils=${MESA_UTILS_VERSION} \ 
    x11-utils=${X11_UTILS_VERSION} \
    libopengl0=${LIBOPENGL0_VERSION} \
    libgl1=${LIBGL1_VERSION} \
    libglx-mesa0=${LIBGLX_MESA0_VERSION} \
    libglib2.0-0t64=${LIBGLIB2_0_0T64_VERSION} \
    libfontconfig1=${LIBFONTCONFIG1_VERSION} \
    libxrender1=${LIBXRENDER1_VERSION} \
    libdbus-1-3=${LIBDBUS_1_3_VERSION} \
    libxkbcommon-x11-0=${LIBXKBCOMMON_X11_0_VERSION} \
    libxi6=${LIBXI6_VERSION} \
    libxcb-icccm4=${LIBXCB_ICCCM4_VERSION} \
    libxcb-image0=${LIBXCB_IMAGE0_VERSION} \
    libxcb-keysyms1=${LIBXCB_KEYSYMS1_VERSION} \
    libxcb-randr0=${LIBXCB_RANDR0_VERSION} \
    libxcb-render-util0=${LIBXCB_RENDER_UTIL0_VERSION} \
    libxcb-xinerama0=${LIBXCB_XINERAMA0_VERSION} \
    libxcb-xinput0=${LIBXCB_XINPUT0_VERSION} \
    libxcb-xfixes0=${LIBXCB_XFIXES0_VERSION} \
    libxcb-shape0=${LIBXCB_SHAPE0_VERSION} \
    # Clean up and remove cache to reduce the image size.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrading pip
RUN python3.9 -m pip install --no-cache-dir --upgrade pip==${PIP_VERSION} \
    && python3.9 -m pip install --no-cache-dir \ 
    napari[all]==${NAPARI_VERSION} \
    napari-clemreg==${CLEMREG_VERSION} \
    empanada-napari==${EMPANADA_VERSION}

ENV PATH="$PATH:/user/local/bin"
CMD ["python3.9", "-m", "napari"]
