#!/bin/bash
set -e

echo "========================================"
echo "Building TWRP for realme RMX3785"
echo "========================================"

# Setup directories
mkdir -p device/realme/RE5C6CL1/prebuilt

# Download kernel and ramdisk
echo "Downloading kernel..."
pip install gdown 2>/dev/null || true
if ! command -v gdown &> /dev/null; then
    wget "https://drive.google.com/uc?export=download&id=1jZHwXptEP2YjM0PBDsbXNyPyRG3bkVuW" -O device/realme/RE5C6CL1/prebuilt/kernel
else
    gdown "1jZHwXptEP2YjM0PBDsbXNyPyRG3bkVuW" -O device/realme/RE5C6CL1/prebuilt/kernel
fi

echo "Downloading ramdisk..."
if ! command -v gdown &> /dev/null; then
    wget "https://drive.google.com/uc?export=download&id=1FGDDKLzjAeCqTjnqQQhTivWOolWcoKgc" -O device/realme/RE5C6CL1/prebuilt/ramdisk.cpio
else
    gdown "1FGDDKLzjAeCqTjnqQQhTivWOolWcoKgc" -O device/realme/RE5C6CL1/prebuilt/ramdisk.cpio
fi

# Verify downloads
echo "Verifying downloads..."
if [ ! -s "device/realme/RE5C6CL1/prebuilt/kernel" ]; then
    echo "ERROR: Kernel download failed!"
    exit 1
fi

if [ ! -s "device/realme/RE5C6CL1/prebuilt/ramdisk.cpio" ]; then
    echo "ERROR: Ramdisk download failed!"
    exit 1
fi

echo "Downloads successful!"

# Clone TWRP source
echo "Cloning TWRP source..."
if [ ! -d "twrp" ]; then
    git clone https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1 twrp
    cd twrp
    # Initialize repo properly
    mkdir -p .repo/local_manifests
    curl https://storage.googleapis.com/git-repo-downloads/repo > repo
    chmod +x repo
    python3 repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1 --depth=1
    python3 repo sync -c -j4 --force-sync --no-clone-bundle --no-tags
    cd ..
else
    echo "TWRP source already exists, skipping clone..."
    cd twrp
fi

# Copy device tree
echo "Setting up device tree..."
mkdir -p device/realme/RE5C6CL1
cp -r ../device/realme/RE5C6CL1/* device/realme/RE5C6CL1/ 2>/dev/null || true

# Ensure prebuilt directory exists
mkdir -p device/realme/RE5C6CL1/prebuilt
cp ../device/realme/RE5C6CL1/prebuilt/* device/realme/RE5C6CL1/prebuilt/ 2>/dev/null || true

# Start build
echo "Starting build..."
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch omni_RE5C6CL1-eng
make -j4 recoveryimage

# Check result
if [ -f "out/target/product/RE5C6CL1/recovery.img" ]; then
    echo "========================================"
    echo "BUILD SUCCESSFUL!"
    echo "Recovery image: out/target/product/RE5C6CL1/recovery.img"
    echo "Size: $(ls -lh out/target/product/RE5C6CL1/recovery.img | awk '{print $5}')"
    echo "========================================"
else
    echo "========================================"
    echo "BUILD FAILED!"
    echo "========================================"
    exit 1
fi
