FROM rust:buster
COPY install-tools /
RUN /install-tools
COPY list-tools export-tools /usr/local/bin/
