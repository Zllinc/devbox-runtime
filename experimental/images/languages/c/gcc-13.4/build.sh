#!/usr/bin/env bash
set -euo pipefail

GCC_VERSION="13.4"
PREFIX="/opt/gcc-${GCC_VERSION}"
TMPDIR="/tmp/gcc-build"

L10N=${L10N:-en_US}
DEFAULT_DEVBOX_USER=${DEFAULT_DEVBOX_USER:-devbox}

# Install build dependencies
# Note: wget and curl are already installed in images/debian-12.6 via install-base-pkg-deb.sh
apt-get update && apt-get install -y \
    build-essential \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    flex \
    bison \
    texinfo \
    zlib1g-dev \
    libisl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

mkdir -p "$TMPDIR" && cd "$TMPDIR"

# Download GCC source code
wget "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"
tar -xzf "gcc-${GCC_VERSION}.tar.gz"
cd "gcc-${GCC_VERSION}"

# Download prerequisite libraries
./contrib/download_prerequisites

# Create build directory
mkdir -p build && cd build

# Configure GCC build
../configure \
    --prefix="$PREFIX" \
    --disable-multilib \
    --enable-languages=c,c++ \
    --with-system-zlib

# Build and install GCC
make -j"$(nproc)"
make install

# Note: PATH and LD_LIBRARY_PATH configuration is handled in runtimes layer's entrypoint.sh
# since entrypoint.sh runs in non-interactive shell and .bashrc won't be loaded.
# If you need to use GCC 13.4 in interactive shell, manually export:
#   export PATH=/opt/gcc-13.4/bin:$PATH
#   export LD_LIBRARY_PATH=/opt/gcc-13.4/lib64:$LD_LIBRARY_PATH

# Clean up build artifacts
cd /
rm -rf "$TMPDIR"

echo "GCC ${GCC_VERSION} installed at ${PREFIX}"
echo "To use: export PATH=${PREFIX}/bin:\$PATH"

