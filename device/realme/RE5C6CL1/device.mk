$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Device identifier
PRODUCT_DEVICE := RE5C6CL1
PRODUCT_NAME := twrp_RE5C6CL1
PRODUCT_BRAND := realme
PRODUCT_MODEL := RMX3785
PRODUCT_MANUFACTURER := realme

# Copy kernel
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/kernel:kernel

# Recovery packages
PRODUCT_PACKAGES += \
    twrp \
    busybox \
    toybox

# For A/B devices
PRODUCT_PACKAGES += \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    bootctrl.$(TARGET_BOARD_PLATFORM).recovery \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-impl.recovery \
    android.hardware.boot@1.0-service
