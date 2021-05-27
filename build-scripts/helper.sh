# See https://github.com/rust-lang/crates.io/blob/master/src/router.rs for details of web endpoints
# defined in crate.io.
CRATES_IO_API_V1_URL=https://crates.io/api/v1

get_crate_latest_version() {
  curl -fsSL $CRATES_IO_API_V1_URL/crates/$1 | jq -Mr '.crate.max_stable_version'
}

get_crate_repository_url() {
  curl -fsSL $CRATES_IO_API_V1_URL/crates/$1 | jq -Mr '.crate.repository'
}

fetch_src() {
  git clone --depth=1 --branch="$2" "$1" "$3"
}

TRIPLE=$(echo "$RUST_TARGET_TRIPLE" | tr '-' '_' | tr [:lower:] [:upper:])

# Enforce to use a specific compiler in the cc crate.
export CC="$GCC"

# Use environment variables instead of creating .cargo/config:
# https://doc.rust-lang.org/cargo/reference/config.html
# https://github.com/japaric/rust-cross#cross-compiling-with-cargo
export CARGO_TARGET_${TRIPLE}_LINKER="$GCC"

# A workaround to fix the following issue:
# https://github.com/rust-lang/compiler-builtins/issues/201
if [ "$TARGETPLATFORM" = linux/arm64/v8 ] || [ "$TARGETPLATFORM" = linux/arm64 ]
then
  export CARGO_TARGET_${TRIPLE}_RUSTFLAGS='-C link-arg=-lgcc'
fi

export PKG_CONFIG_ALLOW_CROSS=1
