#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake             \
    clang             \
    fmt               \
    libdecor          \
    lld               \
    ninja             \
    pipewire-audio    \
    pipewire-jack     \
    python            \
    python-setuptools \
    qt6-base          \
    qt6-declarative   \
    sdl3              \
    vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
echo "Making nightly build of FEX-Emu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/FEX-Emu/FEX"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./FEX
echo "$VERSION" > ~/version

cd FEX
mkdir build && cd build
CC=clang CXX=clang++ cmake .. \
    -DCMAKE_AR=/usr/bin/ar \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_LINKER=lld \
    -DENABLE_LTO=True \
    -DBUILD_TESTING=False \
    -DENABLE_ASSERTIONS=False \
    -G Ninja
ninja
ninja install
ninja binfmt_misc
