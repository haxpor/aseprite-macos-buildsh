#!/bin/bash
#
# Script to automate building latest release of Aseprite (it can be release or beta build)
# This is for macOS build version.

POSTFIXPATH_SDKROOT=Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
CCPATH_TOOLCHAIN=Toolchains/XcodeDefault.xctoolchain/usr/bin/cc
CXXPATH_TOOLCHAIN=Toolchains/XcodeDefault.xctoolchain/usr/bin/c++
SDK_ROOT=`xcode-select -p`
TARGET="/Applications"

# temporary value for returned value from function
TEMP_RET=""

# find value of target param --xxx if there's any, if not then TEMP_RET will still be empty "", else it will contain value from finding
# param 1 - parameter key name
# param 2 - program list of param, usually is $@
# return 1 if it found, and TEMP_RET is set, otherwise return 0. TEMP_RET will be always set to "" (empty) at the beginning of this function.
function findValueOfParam() {
	# set empty to temporary return variable first
	TEMP_RET=""

	count=$#
	argv=($@)

	for (( i=1; i<count; i++ )); do
		if [ ${argv[i]} = "$1" ]; then
			TEMP_RET=${argv[i+1]}
			return 0
		fi
	done

	return 1
}

# check if there's any input parameters
if [ $(($# % 2)) -ne 0 ]; then
	echo "Missing some parameter value"
	exit 1
fi

# set the input argument
if [ "$#" -ne 0 ]; then
	# if only one parameter
	findValueOfParam "--sdk-root" $@

	if [ $? -eq 0 ]; then
		# orvewrite set sdk-root
		SDK_ROOT=$TEMP_RET

		# set to xcode-select as well
		sudo xcode-select -s "$SDK_ROOT"
		echo "Set SDK_ROOT to $SDK_ROOT"
	fi
	
	findValueOfParam "--target" $@
	if [ $? -eq 0 ]; then
		# orvewrite set sdk-root
		TARGET=$TEMP_RET
		echo "Set TARGET to $TARGET"
	fi
fi

# check if aseprite directory exists, so we has no need to clone from repository again
if [ ! -d aseprite ]; then
	git clone --recursive https://github.com/aseprite/aseprite.git
fi

# change to aseprite directory
cd aseprite

# checkout master branch
git checkout master

# clear the current dirty state of git repository
git reset --hard
git clean -fd

# fetch all the update down
git fetch --all
git pull
git submodule update --init --recursive

# compile skia
cd ..
# check to create deps directory if not exist
if [ ! -d deps ]; then
	mkdir deps
fi
cd deps

# check if depot_tools is already cloned
if [ ! -d depot_tools ]; then
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

# check if skia is already cloned
if [ ! -d skia ]; then
	git clone https://github.com/aseprite/skia.git
fi

# clear the dirty state of both repositories
cd depot_tools
git reset --hard
git clean -fd
git fetch --all
git pull

# change dir back
cd ../

cd skia
git reset --hard
git clean -fd
git fetch --all
git pull

# change dir back
cd ../

# continue the operation
export PATH="${PWD}/depot_tools:${PATH}"
cd skia

# get proper skia's branch to compile
SKIA_BRANCH=$(curl "https://raw.githubusercontent.com/aseprite/aseprite/master/INSTALL.md" | grep "aseprite-m[0-9][0-9]" | sed -n '1p' | perl -n -e '/(aseprite-m\d\d)/ && print $1')
git checkout $SKIA_BRANCH

python tools/git-sync-deps
gn gen out/Release-x64 --args="is_debug=false is_official_build=true skia_use_system_expat=false skia_use_system_icu=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false skia_use_sfntly=false skia_use_freetype=true skia_use_harfbuzz=true skia_pdf_subset_harfbuzz=true skia_use_system_freetype2=false skia_use_system_harfbuzz=false target_cpu=\"x64\" extra_cflags=[\"-stdlib=libc++\", \"-mmacosx-version-min=10.9\"] extra_cflags_cc=[\"-frtti\"]"
ninja -C out/Release-x64 skia modules

cd ../../

# compile aseprite
cd aseprite
# create build dir (if needed)
if [ ! -d build ]; then
	mkdir build
fi
cd build

# prepare environment variables
export CC="$SDK_ROOT/$CCPATH_TOOLCHAIN"
export CXX="$SDK_ROOT/$CXXPATH_TOOLCHAIN"

# checkout the latest tag (release or beta)
git checkout `git describe --tags`
cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_OSX_ARCHITECTURES=x86_64 \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 \
  -DCMAKE_OSX_SYSROOT="$SDK_ROOT/$POSTFIXPATH_SDKROOT" \
  -DLAF_OS_BACKEND=skia \
  -DSKIA_DIR="${PWD}/../../deps/skia" \
  -DSKIA_LIBRARY_DIR="${PWD}/../../deps/skia/out/Release-x64" \
  -DSKIA_LIBRARY="${PWD}/../../deps/skia/out/Release-x64/libskia.a" \
  -G Ninja \
  .. && \
ninja aseprite # when finish, build file will be at aseprite/build/bin

# if everything went fine then do final operations
if [ $? -eq 0 ]; then
	# remove existing Aseprite if installed
	if [ -d "$TARGET/Aseprite" ]; then
		rm -rf "$TARGET/Aseprite"
	fi
	# move result to default ~/Applications
	mv bin "$TARGET/Aseprite"
  # check to create target directory
  if [ -d "$TARGET/Aseprite.app" ]; then
    # if found then copy all the contents of our template .app instead
    # this is to avoid risking removing any user' files the app might created
    echo "Target Aseprite.app directory found, copying contents of template .app to target location instead"
	  # copy application bundle to result
	  cp -Rp ../../Aseprite.app/* "$TARGET/Aseprite.app/"
    echo "All done"
  else
    # if not, then just copy the whole template .app directory to target
    echo "Copying template .app to target location"
	  # copy application bundle to result
	  cp -Rp ../../Aseprite.app "$TARGET/Aseprite.app"
    echo "All done"
  fi
else
  echo "Something went wrong"
fi
