export ARCHS = arm64

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = dloader

dloader_FILES = dloader.m
dloader_INSTALL_PATH = @executable_path
dloader_FRAMEWORKS = UIKit Foundation

dloader_LDFLAGS = -Wl,-reexport-lSystem -shared -current_version 1.0.0 -compatibility_version 1.0.0
dloader_CFLAGS = -fPIC -g

include $(THEOS_MAKE_PATH)/library.mk
