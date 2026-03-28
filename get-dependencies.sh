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
    qt5-base          \
    qt5-declarative   \
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

git clone --recursive --depth 1 https://github.com/FEX-Emu/FEX.git
cd FEX
mkdir build && cd build
CC=clang CXX=clang++ cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DUSE_LINKER=lld -DENABLE_LTO=True -DBUILD_TESTING=False -DENABLE_ASSERTIONS=False -G Ninja ..
ninja
ninja install
ninja binfmt_misc
