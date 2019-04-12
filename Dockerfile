FROM continuumio/miniconda3
LABEL authors="Anthony Underwood" \
      description="Docker image containing all requirements for seroba analysis"

RUN apt update; apt install -y make g++ gcc zlib1g-dev libboost-dev ariba python3-pip git wget unzip jq
RUN wget https://github.com/galaxy001/pirs/archive/v2.0.2.tar.gz && \
    tar xvfz v2.0.2.tar.gz && \
    cd pirs-2.0.2 && \
    make && \
    cp src/pirs/pirs /usr/local/bin && \
    mkdir -p /usr/local/share/pirs && \
    cp -r src/pirs/Profiles/* /usr/local/share/pirs

RUN git clone https://github.com/aunderwo/seroba && \
    cd seroba  && \
    ./install_dependencies.sh
ENV PATH /seroba/build:$PATH
RUN export PATH
RUN cd seroba && \
    python3 setup.py install && \
    seroba createDBs database 71
COPY run_seroba.sh /root/bin/run_seroba.sh
CMD ["/root/bin/run_seroba.sh"]

      