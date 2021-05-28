set -eu

TOOL=cargo-audit
VERSION_PREFIX=cargo-audit/v

BASEDIR=$(cd $(dirname $0); pwd)
DISTRO=$1
BUILDPLATFORM=$2
TARGETPLATFORM=$3
OUTDIR=$4

. $BASEDIR/vars.sh
. $BASEDIR/helper.sh

SRCDIR=$(mktemp -d)
trap 'rm -rf $SRCDIR' EXIT

echo "Installing packages..."
apt-get install -y --no-install-recommends \
  libssl-dev:$DEBIAN_ARCH pkg-config:$DEBIAN_ARCH

VERSION="$(get_crate_latest_version $TOOL)"
echo "Installing $TOOL $VERSION..."

GIT_URL="$(get_crate_repository_url $TOOL)"
echo "fetching src from $GIT_URL..."
fetch_src $GIT_URL "${VERSION_PREFIX}${VERSION}" $SRCDIR

echo "Building $TOOL..."
# Simply remove the rust-toolchain file.
#
# The rust-toolchain file enforces to use a toolchain to build BUILDPLATFORM's binary
# even though the --target=$RUST_TARGET_TRIPLE is specified.
#
# Probably, we need to override the toolchain as described in:
# https://rust-lang.github.io/rustup/overrides.html.
rm $SRCDIR/rust-toolchain
(cd $SRCDIR; \
 cargo build --release --target=$RUST_TARGET_TRIPLE --bin=cargo-audit --features=fix)

mkdir -p $OUTDIR
cp $SRCDIR/target/$RUST_TARGET_TRIPLE/release/$TOOL $OUTDIR/
