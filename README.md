# aseprite-macos-buildsh
Automated script to create latest release (whatever it will be either development snapshot commit, beta, or release) of Aseprite for macOS

Update : Added support x64 Architecture build for SKIA on MacOS

Project is updated against aseprite v.1.2.10 build workflow.

# Pre-Requisite

You need

* Xcode
* [CMake](http://www.cmake.org/) (3.4 or greater)
* [Ninja](https://ninja-build.org/) build system
* Python 2.x ([version 3](https://github.com/haxpor/aseprite-macos-buildsh/issues/2) didn't work)

For Xcode, you need to install it by downloading [here](https://developer.apple.com/download/). After successfully installed, execute `xcode-select --install` to install its toolchain, then finally follow along as dialog popup shows up.

Now you're ready to use this script.

# How to Build

Just execute `bash aseprite.sh`. Then open `Aseprite` application.

If the script asks for root password, enter it. This is to be able to execute command to properly set environment path variable. It's safe, the script never try to do anything beside trying to build the app successfully.

## Command line Configuration

In case you want to install aseprite to different path, or your `xcode-select` is not set properly, you can use either `--sdk-root` and `--target` to properly set things up before building.

* `--sdk-root`

	To set your latest macOS SDK root as part of Xcode toolchain. By default it will query current prefix-value from `xcode-select` and append it with `/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk`. But in case, it doesn't work or `xcode-select` didn't do the work, you can use this option to manually specify it.

* `--target`

	To set you target path to install aseprite. By default it will be at `/Applications` but some users might want it differently. In case you use this parameter, please see [#3](https://github.com/haxpor/aseprite-macos-buildsh/issues/3).

So for example, you will execute

```
bash aseprite.sh --sdk-root /Volumes/Slave/Applications/Xcode8.3/Xcode.app/Contents/Developer --target ~/slave/Applications
```
**note** if you use `--target`, please see [#3](https://github.com/haxpor/aseprite-macos-buildsh/issues/3).

Normal, barebone version with no parameters.

```shell
bash aseprite.sh
```

With custom parameters to specify SDK_ROOT and TARGET
```shell
bash aseprite.sh --sdk-root /Volumes/Slave/Applications/YourCustomDir/Xcode.app/Contents/Developer --target ~/YourCustomDir/Appliations
```

# Behind the Scene

The script will proceed with following
* Clone down Aseprite and Skia repository, and its dependencies required to bulid Aseprite.
* Compile and build dependencies
* Clone down Aseprite repository, then compile and build for latest release as tagged on Github (can be either beta or release version)
* Created `.app` bundle at `~/Applications`

> `Aseprite.app` is pre-created bundle file to wrap soon-to-be-built Aseprite. It contains script to execute an aseprite binary file with default executable path at `~/Applications/Aseprite/aseprite`. Such bundle file is created with macOS's Script Editor application.

# Notes

## for building v1.2.9

* If you previously clone any dependencies, the script will know and will instead try to update it from upstream for you. So you're ensured that it will operate on the most latest __release state__ version of Aseprite.
* Updated version of Aseprite might break cloned dependencies's build workflow especially error about `CC` or `CXX` environment variables are not set to correct path. If this is a case, it's likely that you re-build on previously compiled source code of dependencies in which `cmake` still keeps the old configurations used in successful compile. To resolve the problem, remove the whole build folder namedly `aseprite` then start it all over again. 
* ~~In case you want to build older version of Aseprite, take a look at [Releases](https://github.com/haxpor/aseprite-macos-buildsh/releases) section then find a corresponding target version of Aseprite you look for.~~ - won't work, will stick to latest version only

# Support Aseprite

Aseprite is cool. It is free if you build it by yourself like you did above, or you can purchase it at [official website](https://www.aseprite.org/) to avoid spending effort in manual build process.

# Credits

This automated build script gathers information from Aseprite's [INSTALL.md](https://github.com/aseprite/aseprite/blob/master/INSTALL.md) on how to build, and sum it up together as automated script you're using here.

# License
[MIT](https://github.com/haxpor/aseprite-macos-buildsh/blob/master/LICENSE), Wasin Thonkaew
