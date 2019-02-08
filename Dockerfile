# based on https://github.com/BinaryAnalysisPlatform/bap/blob/master/docker/Dockerfile
FROM phusion/baseimage:0.11

RUN apt-get -y update \
    && install_clean sudo \
    && useradd -m bap \
    && echo "bap:bap" | chpasswd \
    && adduser bap sudo \
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
USER bap
WORKDIR /home/bap
ENV PATH="/home/bap/.opam/4.05.0/bin/:${PATH}"
COPY . /home/bap/cwe_checker/

RUN sudo apt-get -y update \
    && sudo install_clean \
        binutils-multiarch \
        build-essential \
        clang \
        curl \
        git \
        libgmp-dev \
        libx11-dev \
        libzip-dev \
        llvm-6.0-dev \
        m4 \
        pkg-config \
        software-properties-common \
        unzip \
        wget \
        zlib1g-dev \
    && wget https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh \
    && yes /usr/local/bin | sudo sh install.sh \
# install Bap
    && opam init --auto-setup --comp=4.05.0 --disable-sandboxing --yes \
    && opam update \
    && opam install depext --yes \
    && OPAMJOBS=1 opam depext --install bap.1.5.0 --yes \
    && OPAMJOBS=1 opam install yojson alcotest --yes

WORKDIR /home/bap/cwe_checker/src

ENTRYPOINT ["opam", "config", "exec", "--"]