ARG UBUNTU_VERSION=24.04
ARG PYTHON_VERSION=3.10
ARG NAPARI_VERSION=0.4.19.post1
ARG CLEMREG_VERSION=0.2.1
ARG EMPANADA_VERSION=1.1.0
# empanada-dl 0.1.7 imports cztile.fixed_total_area_strategy, which cztile 2.0.0 removed
ARG CZTILE_VERSION=1.0.0

FROM ubuntu:${UBUNTU_VERSION} AS base
ARG UBUNTU_VERSION
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Europe/London
ENV TZ=${TZ}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates software-properties-common gpg-agent tzdata locales \
    libgl1 libglu1-mesa libglx-mesa0 libegl1 libopengl0 mesa-utils \
    libglib2.0-0t64 libfontconfig1 libxrender1 libdbus-1-3 libxi6 \
    libxkbcommon-x11-0 libxcb-cursor0 libxcb-icccm4 libxcb-image0 \
    libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-shape0 \
    libxcb-xfixes0 libxcb-xinerama0 libxcb-xinput0 libxcb-xkb1 x11-utils \
    && sed -i 's/^# *\(en_GB.UTF-8\)/\1/' /etc/locale.gen && locale-gen \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
       python${PYTHON_VERSION} \
    && apt-get purge -y software-properties-common gpg-agent \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

FROM base AS builder
ARG PYTHON_VERSION
ARG DEBIAN_FRONTEND=noninteractive
ARG NAPARI_VERSION
ARG CLEMREG_VERSION
ARG EMPANADA_VERSION
ARG CZTILE_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python${PYTHON_VERSION}-dev python${PYTHON_VERSION}-venv \
    && rm -rf /var/lib/apt/lists/*

# N.B. torch is not pinned (napari-clemreg appears to take 2.0.1, CUDA 11)
RUN python${PYTHON_VERSION} -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir \
       "napari[all]==${NAPARI_VERSION}" \
       "napari-clemreg==${CLEMREG_VERSION}" \
       "empanada-napari==${EMPANADA_VERSION}" \
       "cztile==${CZTILE_VERSION}" \
    && /opt/venv/bin/pip freeze > /opt/venv/freeze.txt

# Catch failure with import check
RUN /opt/venv/bin/pip check \
    && /opt/venv/bin/python -c "import napari, napari_clemreg, empanada_napari; from empanada.inference.tile import Tiler"

FROM base
ARG UBUNTU_VERSION
ARG PYTHON_VERSION
ARG NAPARI_VERSION
ARG CLEMREG_VERSION
ARG EMPANADA_VERSION
ARG IMAGE_VERSION="${NAPARI_VERSION}"
ARG IMAGE_REVISION=""
ARG IMAGE_CREATED=""

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:${PATH}" \
    QT_X11_NO_MITSHM=1 \
    QT_XCB_NO_MITSHM=1 \
    NAPARI_ASYNC=1

LABEL org.opencontainers.image.title="RFI/CCP-volumeEM napari with clemreg and empanada" \
      org.opencontainers.image.description="Ubuntu container with napari, napari-clemreg and empanada-napari" \
      org.opencontainers.image.authors="The Rosalind Franklin Institute, The Collaborative Computational Project for Volume Electron Microscopy" \
      org.opencontainers.image.source="https://github.com/rosalindfranklininstitute/napari-clemreg-empanada" \
      org.opencontainers.image.documentation="https://rosalindfranklininstitute.github.io/volume-em-container-documentation/software/napari/" \
      org.opencontainers.image.licenses="Apache-2.0 AND BSD-3-Clause AND MIT" \
      org.opencontainers.image.base.name="docker.io/library/ubuntu:${UBUNTU_VERSION}" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.created="${IMAGE_CREATED}" \
      uk.ac.rfi.napari.version="${NAPARI_VERSION}" \
      uk.ac.rfi.napari.source="https://github.com/napari/napari" \
      uk.ac.rfi.napari-clemreg.version="${CLEMREG_VERSION}" \
      uk.ac.rfi.napari-clemreg.source="https://github.com/krentzd/napari-clemreg" \
      uk.ac.rfi.empanada-napari.version="${EMPANADA_VERSION}" \
      uk.ac.rfi.empanada-napari.source="https://github.com/volume-em/empanada-napari" \
      uk.ac.rfi.python.version="${PYTHON_VERSION}"

CMD ["napari"]
