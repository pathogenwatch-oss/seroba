ARG VERSION=2.0.4

FROM sangerbentleygroup/seroba:${VERSION}

LABEL authors="Anthony Underwood & Corin Yeats" \
      description="Docker image containing all requirements for seroba analysis"

RUN apt --allow-releaseinfo-change update \
    && apt install -y make g++ gcc zlib1g-dev libboost-dev git wget curl unzip jq \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


RUN wget https://github.com/galaxy001/pirs/archive/v2.0.2.tar.gz && \
    tar xvfz v2.0.2.tar.gz && \
    cd pirs-2.0.2 && \
    make && \
    cp src/pirs/pirs /usr/local/bin && \
    mkdir -p /usr/local/share/pirs && \
    cp -r src/pirs/Profiles/* /usr/local/share/pirs && \
    cd .. && \
    rm -f v2.0.2.tar.gz

COPY run_seroba.sh /root/bin/run_seroba.sh

ENTRYPOINT ["/root/bin/run_seroba.sh"]

#FROM continuumio/miniconda3
#LABEL authors="Anthony Underwood" \
#      description="Docker image containing all requirements for seroba analysis"
#
#ARG VERSION=v1.0.2
#
#RUN apt  --allow-releaseinfo-change update \
#    && apt install -y make g++ gcc zlib1g-dev libboost-dev ariba python3-pip git wget unzip jq \
#    && rm -rf /var/lib/apt/lists/*
#

#RUN git clone --depth 1 --branch ${VERSION} https://github.com/sanger-pathogens/seroba.git && \
#    cd seroba  && \
#    ./install_dependencies.sh
#ENV PATH /seroba/build:$PATH
#RUN export PATH
#RUN cd seroba && \
#    python3 setup.py install && \
#    seroba createDBs database 71
#COPY run_seroba.sh /root/bin/run_seroba.sh
#CMD ["c"]

      
