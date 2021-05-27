set -eu

TOOL=rust-analyzer

BASEDIR=$(cd $(dirname $0); pwd)
DISTRO=$1
BUILDPLATFORM=$2
TARGETPLATFORM=$3
OUTDIR=$4

. $BASEDIR/vars.sh
. $BASEDIR/helper.sh

SRCDIR=$(mktemp -d)
trap 'rm -rf $SRCDIR' EXIT

LATEST_URL=https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest
VERSION="$(curl -fsSL $LATEST_URL | jq -r .tag_name)"
echo "Installing $TOOL $VERSION..."

GIT_URL=https://github.com/rust-analyzer/rust-analyzer.git
echo "fetching src from $GIT_URL..."
fetch_src $GIT_URL $VERSION $SRCDIR

echo "Building $TOOL..."
(cd $SRCDIR; \
 cargo build --release --target=$RUST_TARGET_TRIPLE --bin=rust-analyzer --features=force-always-assert)

mkdir -p $OUTDIR
cp $SRCDIR/target/$RUST_TARGET_TRIPLE/release/$TOOL $OUTDIR/
