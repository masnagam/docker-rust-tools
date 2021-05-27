FROM --platform=$BUILDPLATFORM rust:slim-buster AS buildenv
ARG BUILDPLATFORM
ARG TARGETPLATFORM
ENV DEBIAN_FRONTEND=noninteractive
COPY ./build-scripts/vars.* /build-scripts/
COPY ./build-scripts/buildenv.sh /build-scripts/
RUN sh /build-scripts/buildenv.sh debian $BUILDPLATFORM $TARGETPLATFORM

FROM buildenv AS cargo-audit-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/cargo-audit.sh /build-scripts/
RUN sh /build-scripts/cargo-audit.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM buildenv AS cargo-cache-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/cargo-cache.sh /build-scripts/
RUN sh /build-scripts/cargo-cache.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM buildenv AS cargo-expand-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/cargo-expand.sh /build-scripts/
RUN sh /build-scripts/cargo-expand.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM buildenv AS cargo-license-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/cargo-license.sh /build-scripts/
RUN sh /build-scripts/cargo-license.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM buildenv AS cargo-update-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/cargo-update.sh /build-scripts/
RUN sh /build-scripts/cargo-update.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM buildenv AS grcov-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/grcov.sh /build-scripts/
RUN sh /build-scripts/grcov.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM buildenv AS rust-analyzer-build
ARG BUILDPLATFORM
ARG TARGETPLATFORM
COPY ./build-scripts/helper.sh /build-scripts/
COPY ./build-scripts/rust-analyzer.sh /build-scripts/
RUN sh /build-scripts/rust-analyzer.sh debian $BUILDPLATFORM $TARGETPLATFORM /out

FROM rust:slim-buster
LABEL maintainer="masnagam <masnagam@gmail.com>"
COPY --from=cargo-audit-build /out/* /usr/local/cargo/bin/
COPY --from=cargo-cache-build /out/* /usr/local/cargo/bin/
COPY --from=cargo-expand-build /out/* /usr/local/cargo/bin/
COPY --from=cargo-license-build /out/* /usr/local/cargo/bin/
COPY --from=cargo-update-build /out/* /usr/local/cargo/bin/
COPY --from=grcov-build /out/* /usr/local/cargo/bin/
COPY --from=rust-analyzer-build /out/* /usr/local/cargo/bin/
COPY ./scripts/* /usr/local/bin/
