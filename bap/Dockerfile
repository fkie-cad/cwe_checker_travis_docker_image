# based on https://github.com/BinaryAnalysisPlatform/bap/blob/master/docker/Dockerfile
FROM phusion/baseimage:18.04-1.0.0

RUN apt-get -y update \
    && install_clean sudo \
    && useradd -m cwe \
    && echo "cwe:cwe" | chpasswd \
    && adduser cwe sudo \
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
USER cwe

WORKDIR /home/cwe

ENV PATH="/home/cwe/.opam/4.08.0/bin/:${PATH}"
ENV PATH="/home/cwe/.cargo/bin/:${PATH}"

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
        llvm-9-dev \
        m4 \
        pkg-config \
        software-properties-common \
        unzip \
        wget \
        zlib1g-dev \
        libncurses5-dev \
        python2.7 \
        radare2 \
	# install Rust
	&& curl https://sh.rustup.rs -sSf | sh -s -- --profile minimal -y \
    && rustup component add rustfmt clippy \
    # install opam
    && wget https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh \
    && yes /usr/local/bin | sudo sh install.sh \
    # install ocaml and bap
    && opam init --auto-setup --comp=4.08.0 --disable-sandboxing --yes \
    && opam update \
    && opam install depext --yes \
    && OPAMJOBS=1 opam depext --install bap.2.2.0 --yes \
    && OPAMJOBS=1 opam install yojson alcotest dune ppx_deriving_yojson --yes \
    && opam clean -acrs \
    # delete 6 GB (!!) of unnecessary data
    && rm -rf /home/cwe/.opam/4.07.1/.opam-switch/sources/* \
    && rm -rf /home/cwe/.opam/repo/*

ENTRYPOINT ["opam", "config", "exec", "--"]
