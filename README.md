# docker-rust-tools

> Multi-Arch Docker images containing pre-built tools for Rust

[![build](https://github.com/masnagam/docker-rust-tools/actions/workflows/build.yml/badge.svg)](https://github.com/masnagam/docker-rust-tools/actions/workflows/build.yml)
[![debian/bullseye](https://img.shields.io/docker/image-size/masnagam/rust-tools/debian-bullseye?label=Debian/Bullseye)](https://hub.docker.com/r/masnagam/rust-tools/tags?page=1&name=debian-bullseye)

## Usage

Run a tool:

```shell
docker run --rm masnagam/rust-tools cargo audit --version
```

List tools contained in a Docker image:

```shell
docker run --rm masnagam/rust-tools list-tools
```

Export tools from a Docker image:

```shell
docker run --rm masnagam/rust-tools export-tools | tar -tvz
```

Use `get-rust-tools` for installation:

```shell
curl -fsSL https://raw.githubusercontent.com/masnagam/docker-rust-tools/main/get-rust-tools | \
  sh -s | tar -xz -C $CARGO_HOME/bin --no-same-owner
```

For details, see the help message shown by the following command:

```shell
curl -fsSL https://raw.githubusercontent.com/masnagam/docker-rust-tools/main/get-rust-tools | \
  sh -s -- -h
```

## License

MIT
