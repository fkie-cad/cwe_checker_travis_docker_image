FROM phusion/baseimage:18.04-1.0.0

RUN apt-get -y update \
    && install_clean sudo \
    && useradd -m cwe \
    && echo "cwe:cwe" | chpasswd \
    && adduser cwe sudo \
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
USER cwe

WORKDIR /home/cwe

ENV PATH="/home/cwe/.cargo/bin/:${PATH}"
ENV GHIDRA_VERSION="9.1.2_PUBLIC"

RUN sudo apt-get -y update \
    && sudo install_clean \
        build-essential \
        curl \
        unzip \
        wget \
        openjdk-11-jdk \
	# install Rust
	&& curl https://sh.rustup.rs -sSf | sh -s -- --profile minimal -y \
    && rustup component add rustfmt clippy \
    # install Ghidra
    && curl -fSL https://www.ghidra-sre.org/ghidra_9.1.2_PUBLIC_20200212.zip -o ghidra.zip \
    && unzip -q ghidra.zip \
    && mv ghidra_${GHIDRA_VERSION} /home/cwe/ghidra \
    && rm ghidra.zip \
    # add gson to the Ghidra plugins
    && mkdir -p /home/cwe/.ghidra/.ghidra_${GHIDRA_VERSION}/plugins \
    && wget https://search.maven.org/remotecontent?filepath=com/google/code/gson/gson/2.8.6/gson-2.8.6.jar -O gson-2.8.6.jar \
    && mv gson-2.8.6.jar /home/cwe/.ghidra/.ghidra_${GHIDRA_VERSION}/plugins/gson-2.8.6.jar

CMD ["sh"]
