set -eu

TOOL=grcov
VERSION_PREFIX=v

BASEDIR=$(cd $(dirname $0); pwd)
DISTRO=$1
BUILDPLATFORM=$2
TARGETPLATFORM=$3
OUTDIR=$4

. $BASEDIR/vars.sh
. $BASEDIR/helper.sh

SRCDIR=$(mktemp -d)
trap 'rm -rf $SRCDIR' EXIT

VERSION="$(get_crate_latest_version $TOOL)"
echo "Installing $TOOL $VERSION..."

GIT_URL="$(get_crate_repository_url $TOOL)"
echo "fetching src from $GIT_URL..."
fetch_src $GIT_URL "${VERSION_PREFIX}${VERSION}" $SRCDIR

echo "Building $TOOL..."
(cd $SRCDIR; cargo build --release --target=$RUST_TARGET_TRIPLE)

mkdir -p $OUTDIR
cp $SRCDIR/target/$RUST_TARGET_TRIPLE/release/$TOOL $OUTDIR/
