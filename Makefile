ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = CarPlay

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BubbleLab
BubbleLab_FILES = BubbleLab.xm
BubbleLab_FRAMEWORKS = UIKit QuartzCore Foundation
BubbleLab_CFLAGS = -fobjc-arc -Werror

include $(THEOS_MAKE_PATH)/tweak.mk
