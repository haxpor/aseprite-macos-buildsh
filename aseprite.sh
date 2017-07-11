#!/bin/bash
#
# Script to automate building latest release of Aseprite (it can be release or beta build)
# This is for macOS build version.

# Define your build settings here
SDK_ROOT="/Volumes/Slave/Applications/Xcode8.3/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk"

git clone --recursive https://github.com/aseprite/aseprite.git
cd aseprite
git pull
git submodule update --init --recursive

# compile skia

cd ..
mkdir deps
cd deps
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
git clone https://github.com/aseprite/skia.git
export PATH="${PWD}/depot_tools:${PATH}"
cd skia
git checkout aseprite-m55
python bin/sync-and-gyp
ninja -C out/Release dm

cd ../../

# compile aseprite
cd aseprite
mkdir build
cd build
git checkout `git describe --tags`  # checkout the latest tag release
cmake -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_OSX_DEPLOYMENT_TARGET=10.7 -DCMAKE_OSX_SYSROOT=$SDK_ROOT -DUSE_ALLEG4_BACKEND=OFF -DUSE_SKIA_BACKEND=ON -DSKIA_DIR="${PWD}/../../deps/skia" -DWITH_HarfBuzz=OFF -G Ninja ..
ninja aseprite # when finish, build file will be at aseprite/build/bin

# move result to default ~/Applications
mv bin ~/Applications/Aseprite
# copy application bundle to result
cp -Rp ../../Aseprite.app ~/Applications/Aseprite.app

echo "Done!"