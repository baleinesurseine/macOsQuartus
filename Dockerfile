FROM ubuntu:trusty

ARG _base_url="https://download.altera.com/akdlm/software/acdsinst"
ARG _mainver=20.1
ARG _patchver=.1
ARG _buildver=720
ARG pkgver=${_mainver}${_patchver}.${_buildver}
ARG source=${_base_url}/${_mainver}std${_patchver:-.0}/${_buildver}/ib_installers/QuartusLiteSetup-${pkgver}-linux.run
ARG cyclone10lp=${_base_url}/${_mainver}std${_patchver:-.0}/${_buildver}/ib_installers/cyclone10lp-${pkgver}.qdz

WORKDIR /quartus
RUN apt-get update && \
    apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# RUN wget ${source}
# RUN wget ${cyclone10lp}
COPY QuartusLiteSetup-${pkgver}-linux.run .
COPY cyclone10lp-${pkgver}.qdz .
RUN chmod +x QuartusLiteSetup-${pkgver}-linux.run
RUN ./QuartusLiteSetup-${pkgver}-linux.run \
  --mode unattended \
  --unattendedmodeui none \
  --installdir . \
  --disable-components quartus_help,modelsim_ase,modelsim_ae \
  --accept_eula 1
RUN rm -rf ./QuartusLiteSetup-${pkgver}-linux.run \
    && rm -rf ./cyclone10lp-${pkgver}.qdz


FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -y \
    software-properties-common

RUN add-apt-repository ppa:mozillateam/ppa
RUN apt-get update && apt-get install -y \
    firefox \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /quartus
COPY --from=0 /quartus /quartus/
CMD /quartus/quartus/bin/quartus
