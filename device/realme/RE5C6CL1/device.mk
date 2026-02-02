# device/realme/RE5C6CL1/device.mk

# Inherit from common TWRP
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Device identifier
PRODUCT_DEVICE := RE5C6CL1
PRODUCT_NAME := twrp_RE5C6CL1
PRODUCT_BRAND := realme
PRODUCT_MODEL := RMX3785
PRODUCT_MANUFACTURER := realme

# Copy kernel
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/kernel:kernel

# Recovery packages
PRODUCT_PACKAGES += \
    twrp \
    busybox \
    toybox

# For A/B devices
PRODUCT_PACKAGES += \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    bootctrl.$(TARGET_BOARD_PLATFORM).recovery
