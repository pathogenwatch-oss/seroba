FROM continuumio/miniconda3
LABEL authors="Anthony Underwood" \
      description="Docker image containing all requirements for seroba analysis"

RUN apt update; apt install -y gcc git

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/seroba/bin:$PATH 
RUN mkdir /seroba && \
    cd  /seroba && \
    git clone https://github.com/sanger-pathogens/seroba.git repo && \
    cp -r repo/database database && \
    rm -r repo &&\
    seroba createDBs database/ 71
COPY run_seroba.sh /root/bin/run_seroba.sh
CMD ["/root/bin/run_seroba.sh"]

      