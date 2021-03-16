FROM ubuntu:trusty AS quartus

ARG _base_url="https://download.altera.com/akdlm/software/acdsinst"
ARG _mainver=20.1
ARG _patchver=.1
ARG _buildver=720
ARG pkgver=${_mainver}${_patchver}.${_buildver}
ARG source=${_base_url}/${_mainver}std${_patchver:-.0}/${_buildver}/ib_installers/QuartusLiteSetup-${pkgver}-linux.run
ARG cyclone10lp=${_base_url}/${_mainver}std${_patchver:-.0}/${_buildver}/ib_installers/cyclone10lp-${pkgver}.qdz

WORKDIR /quartus
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common \
    gcc-multilib g++-multilib lib32z1 \
    lib32stdc++6 lib32gcc1 libxt6:i386 libxtst6:i386 expat:i386 \
    fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 \
    libgtk-3-0:i386 libcanberra0:i386 libice6:i386 libsm6:i386 \
    libncurses5:i386 zlib1g:i386 libx11-6:i386 libxau6:i386 \
    libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 \
    && rm -rf /var/lib/apt/lists/*

# RUN wget ${source}
# RUN wget ${cyclone10lp}
COPY QuartusLiteSetup-${pkgver}-linux.run .
COPY ModelSimSetup-${pkgver}-linux.run .
COPY cyclone10lp-${pkgver}.qdz .
RUN chmod +x QuartusLiteSetup-${pkgver}-linux.run \ 
    && ./QuartusLiteSetup-${pkgver}-linux.run \
  --mode unattended \
  --unattendedmodeui none \
  --installdir . \
  --disable-components quartus_help,quartus_help,modelsim_ase,modelsim_ae \
  --accept_eula 1

RUN chmod +x ModelSimSetup-${pkgver}-linux.run \ 
    && ./ModelSimSetup-${pkgver}-linux.run \
  --mode unattended \
  --unattendedmodeui none \
  --installdir . \
  --accept_eula 1

RUN chmod u+w /quartus/modelsim_ase/vco \
    && cp /quartus/modelsim_ase/vco /quartus/modelsim_ase/vco_original \
    && sed -i 's/linux\_rh[[:digit:]]\+/linux/g' /quartus/modelsim_ase/vco \
    && sed -i 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:-"32"/g' /quartus/modelsim_ase/vco \
    && sed -i '/dir=`dirname "$arg0"`/a export LD_LIBRARY_PATH=${dir}/lib32' \
               /quartus/modelsim_ase/vco

COPY freetype-2.4.12.tar.bz2 .
RUN tar xjf freetype-2.4.12.tar.bz2 \
    && cd freetype-2.4.12/ \
    && ./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" \
    "CXXFLAGS=-m32" "LDFLAGS=-m32" \
    && make clean \
    && make

RUN mkdir /quartus/modelsim_ase/lib32 \
    && cp /quartus/freetype-2.4.12/objs/.libs/libfreetype.so* /quartus/modelsim_ase/lib32/

WORKDIR /quartus

RUN rm -rf ./QuartusLiteSetup-${pkgver}-linux.run \
    && rm -rf ./ModelSimSetup-${pkgver}-linux.run \
    && rm -rf ./cyclone10lp-${pkgver}.qdz \
    && rm -rf ./freetype-2.4.12 \
    && rm -rf freetype-2.4.12.tar.bz2


FROM ubuntu:trusty
LABEL maintainer="edouard.fischer@gmail.com"

COPY --from=quartus /quartus /quartus/

RUN dpkg --add-architecture i386

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    gcc-multilib g++-multilib lib32z1 \
    lib32stdc++6 lib32gcc1 libxt6:i386 libxtst6:i386 expat:i386 \
    fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 \
    libgtk-3-0:i386 libcanberra0:i386 libice6:i386 libsm6:i386 \
    libncurses5:i386 zlib1g:i386 libx11-6:i386 libxau6:i386 \
    libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 \
    libxml2:i386 libcanberra-gtk-module:i386 \
    gtk2-engines-murrine:i386 libatk-adaptor:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository ppa:mozillateam/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    firefox \
    && rm -rf /var/lib/apt/lists/*

COPY adobe.deb .
RUN dpkg -i adobe.deb \
    && rm adobe.deb



CMD /quartus/quartus/bin/quartus
