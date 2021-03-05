FROM ubuntu:trusty

ARG _base_url="https://download.altera.com/akdlm/software/acdsinst"
ARG _mainver=20.1
ARG _patchver=.1
ARG _buildver=720
ARG pkgver=${_mainver}${_patchver}.${_buildver}
ARG source=${_base_url}/${_mainver}std${_patchver:-.0}/${_buildver}/ib_installers/QuartusLiteSetup-${pkgver}-linux.run
ARG cyclone=${_base_url}/${_mainver}std${_patchver:-.0}/${_buildver}/ib_installers/cyclone10lp-${pkgver}.qdz

WORKDIR /quartus
RUN apt-get update && \
    apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# RUN wget ${source}
# RUN wget ${cyclone}
COPY QuartusLiteSetup-20.1.1.720-linux.run .
COPY cyclone10lp-20.1.1.720.qdz .
RUN chmod +x QuartusLiteSetup-20.1.1.720-linux.run
RUN ./QuartusLiteSetup-20.1.1.720-linux.run \
  --mode unattended \
  --unattendedmodeui none \
  --installdir . \
  --disable-components quartus_help,modelsim_ase,modelsim_ae \
  --accept_eula 1

RUN rm -rf ./QuartusLiteSetup-20.1.1.720-linux.run
RUN rm -rf ./cyclone10lp-20.1.1.720.qdz


FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y \
    # libglib2.0-0 \
    software-properties-common \
    # wget \
    # build-essential \
    # zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# RUN wget https://altushost-swe.dl.sourceforge.net/project/libpng/libpng12/1.2.59/libpng-1.2.59.tar.gz
# # COPY libpng-1.2.59.tar.gz .
# RUN tar xf libpng-1.2.59.tar.gz -C /tmp
# WORKDIR /tmp/libpng-1.2.59
# RUN ./configure --prefix=/usr/local \
#     && make \
#     && make install \
#     && ldconfig

RUN add-apt-repository ppa:mozillateam/ppa
RUN apt-get update && apt-get install -y \
    #libidn11 \
    #libfreetype6 \
    #libsm6 \
    #libxrender1 \
    #libfontconfig1 \
    #libxext6 \
    firefox \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /quartus
# RUN rm -rf /tmp/libpng-1.2.59 && rm -rf /libpng-1.2.59.tar.gz
COPY --from=0 /quartus /quartus/
CMD /quartus/quartus/bin/quartus
