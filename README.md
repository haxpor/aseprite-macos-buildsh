# aseprite-macos-buildsh
Automated script to create latest release (can be beta, or release) of Aseprite for macOS

Project is updated against aseprite v.1.2.6 build workflow.

# Pre-Requisite

You need to install Xcode by downloading it [here](https://developer.apple.com/download/).

After successfully installed, you install Xcode's toolchain by executing `xcode-select --install` then follow along when popup shown up.

Now you're ready to use this script.

# How to Build

Just execute `bash aseprite.sh`. Then open `Aseprite` application.

If the application asks for root password, enter it. This is to be able to execute command to properly set environment path variable.

## Command line Configuration

In case you want to install aseprite to different path, or your `xcode-select` is not set properly, you can use either `--sdk-root` and `--target` to properly set things up before building.

* `--sdk-root`

	To set your latest MacOS SDK root as part of Xcode toolchain. By default it will query current prefix-value from `xcode-select` and append it with `/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk`. But in case, it doesn't work or `xcode-select` didn't do the work, you can use this option to manually specify it.

* `--target`

	To set you target path to install aseprite. By default it will be at `/Applications` but it might be different for some users.

So for example, you will execute

```
bash aseprite.sh --sdk-root /Volumes/Slave/Applications/Xcode8.3/Xcode.app/Contents/Developer --target ~/slave/Applications
```

Note that the current build system for aseprite only supports buliding against macOS 10.12. 10.13 didn't work as I tested it.

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
* Clone down Skia repository, and its dependencies required to bulid Aseprite
* Compile and build dependencies
* Clone down Aseprite repository, then compile and build for latest release as tagged on Github (can be either beta or release version)
* Created `.app` bundle at `~/Applications`

> `Aseprite.app` is pre-created bundle file to wrap soon-to-be-built Aseprite. It contains script to execute an aseprite binary file with default executable path at `~/Applications/Aseprite/aseprite`. Such bundle file is created with macOS's Script Editor application.

# Support Aseprite

Aseprite is cool. It is free if you build it by yourself like you did above, or you can purchase it at [official website](https://www.aseprite.org/) to avoid spending effort in manual build process.

# Credits

This automated build script gathers information from Aseprite's [INSTALL.md](https://github.com/aseprite/aseprite/blob/master/INSTALL.md) on how to build, and sum it up together as automated script you're using it here.

# License
[MIT](https://github.com/haxpor/aseprite-macos-buildsh/blob/master/LICENSE), Wasin Thonkaew
