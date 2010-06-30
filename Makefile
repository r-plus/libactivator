ifeq ($(shell [ -f ./framework/makefiles/common.mk ] && echo 1 || echo 0),0)
all clean package install::
	git submodule update --init --recursive
	$(MAKE) $(MAKEFLAGS) MAKELEVEL=0 $@
else

# libactivator.dylib (/usr/lib)
LIBRARY_NAME = libactivator
libactivator_OBJC_FILES = Events.m LAEvent.m LAApplicationListener.m LASimpleListener.m LARemoteListener.m LAListener.m ListenerSettingsViewController.m libactivator.m LAToggleListener.m LASettingsViewController.m ActivatorEventViewHeader.m LAWebSettingsController.m LARootSettingsController.m LAModeSettingsController.m LAEventSettingsController.m LAEventGroupSettingsController.m
libactivator_FRAMEWORKS = UIKit CoreGraphics QuartzCore
libactivator_PRIVATE_FRAMEWORKS = AppSupport GraphicsServices

# LibActivator.bundle (/System/Library/PreferenceBundles)
BUNDLE_NAME = LibActivator
LibActivator_OBJC_FILES = Preferences.m ActivatorAdController.m
LibActivator_INSTALL_PATH = /System/Library/PreferenceBundles
LibActivator_FRAMEWORKS = UIKit CoreGraphics QuartzCore
LibActivator_PRIVATE_FRAMEWORKS = Preferences
LibActivator_LDFLAGS = -L$(FW_OBJ_DIR) -lactivator

ADDITIONAL_CFLAGS = -std=c99

ifeq ($(PROFILING),1)
	ADDITIONAL_CFLAGS += -DCHEnableProfiling
endif

ifeq ($(DEBUG),1)
	ADDITIONAL_CFLAGS += -DCHDebug
endif

LOCALIZATION_PROJECT_NAME = libactivator
LOCALIZATION_DEST_PATH = /Library/Activator/

include framework/makefiles/common.mk
include framework/makefiles/library.mk
include framework/makefiles/bundle.mk
include Localization/makefiles/common.mk

internal-package::
	mkdir -p $(FW_STAGING_DIR)/usr/include/libactivator
	mkdir -p $(FW_STAGING_DIR)/Library/Activator/Listeners
	cp -a libactivator.h $(FW_STAGING_DIR)/usr/include/libactivator/
	- find $(FW_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

endif
