# Check preconditions
if [ "$BUILDPLATFORM" != 'linux/amd64' ]; then
  echo "Unsupported BUILDPLATFORM: $BUILDPLATFORM" >&2
  exit 1
fi

case "$TARGETPLATFORM" in
  'linux/386')
    DEBIAN_ARCH='i386'
    ;;
  'linux/amd64')
    DEBIAN_ARCH='amd64'
    ;;
  'linux/arm/v5' | 'linux/arm/v6')
    DEBIAN_ARCH='armel'
    ;;
  'linux/arm/v7')
    DEBIAN_ARCH='armhf'
    ;;
  'linux/arm64/v8' | 'linux/arm64')
    DEBIAN_ARCH='arm64'
    ;;
  *)
    echo "Unsupported TARGETPLATFORM: $TARGETPLATFORM" >&2
    exit 1
    ;;
esac

BUILD_DEPS=$(cat <<EOF | tr '\n' ' '
ca-certificates
curl
git
jq
EOF
)

# Import distro-specific variables
. $BASEDIR/vars.$DISTRO.sh

cat <<EOF
BUILD_DEPS
  $BUILD_DEPS
GCC_HOST_TRIPLE
  $GCC_HOST_TRIPLE
GCC_ARCH
  $GCC_ARCH
GCC
  $GCC
GXX
  $GXX
RUST_TARGET_TRIPLE
  $RUST_TARGET_TRIPLE
EOF
