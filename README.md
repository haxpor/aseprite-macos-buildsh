# aseprite-macos-buildsh
Automated script to create latest release (can be beta, or release) of Aseprite for macOS

# How to Build

Just execute `aseprite.sh`. 

It will finally create `Aseprite.app` at `~/Applications` which is default.  
Next, you can open Aseprite by either search through Spotlight, or double click on such file.

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