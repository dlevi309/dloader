CC = xcrun -sdk iphoneos gcc
SIGN   := codesign -s -

all:
	$(CC) -arch arm64 -Os -dynamiclib dloader.m -o dloader.dylib -Wall -O3 -shared -miphoneos-version-min=8.0 -Wl,-install_name,@executable_path/dloader.dylib -Wl,-no_warn_inits -framework Foundation -framework UIKit -Wl,-reexport-lSystem -shared -current_version 1.0.0 -compatibility_version 1.0.0 -fPIC
	$(SIGN) dloader.dylib