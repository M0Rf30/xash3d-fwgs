#!/bin/bash

# Build custom SDL2

. scripts/lib.sh

cd $TRAVIS_BUILD_DIR/SDL2_src
export CC="ccache gcc -msse2 -march=i686 -m32 -ggdb -O2"
./configure \
	--disable-dependency-tracking \
	--disable-render \
	--disable-haptic \
	--disable-power \
	--disable-filesystem \
	--disable-file \
	--enable-alsa-shared \
	--enable-pulseaudio-shared \
	--enable-wayland-shared \
	--enable-x11-shared \
	--disable-libudev \
	--disable-dbus \
	--disable-ibus \
	--disable-ime \
	--disable-fcitx \
	--prefix / # get rid of /usr/local stuff
make -j2
mkdir -p $TRAVIS_BUILD_DIR/SDL2_linux
make install DESTDIR=$TRAVIS_BUILD_DIR/SDL2_linux

# Build engine
cd $TRAVIS_BUILD_DIR
export CC="ccache gcc"
export CXX="ccache g++"
./waf configure --sdl2=$TRAVIS_BUILD_DIR/SDL2_linux --vgui=$TRAVIS_BUILD_DIR/vgui-dev --build-type=debug --enable-stb || die
./waf build -j2 || die

# Build AppImage
scripts/build_appimage.sh
