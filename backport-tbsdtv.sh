#!/bin/bash

# This is a script to move TBS6910 code from the TBSDTV github source to an 
# official Linux kernel.
# 
# Please check the Makefile at the TBSDTV site to verify the Kernel version.
#
# The TBS6910 uses:
# - TBS ECP 3 interface
# - TAS2101 frontend
# - AV201x tuner
# Note: Every other TBSDTV driver is removed!

# wget -c https://github.com/tbsdtv/linux_media/archive/latest.zip
# unzip latest.zip

KERNEL_TBS="/mnt/epia-kernel-build/linux_media-latest"
KERNEL_SRC="/mnt/epia-kernel-build/linux-5.6.3"
PATCH_DIR=$(pwd)

### New files from TBS - tbsecp3 PCIe driver, TAS2101 frontend, AV201x tuner
cp -v -r ${KERNEL_TBS}/drivers/media/pci/tbsecp3 \
	 ${KERNEL_SRC}/drivers/media/pci/

cp -v ${KERNEL_TBS}/drivers/media/dvb-frontends/tas2101* \
      ${KERNEL_SRC}/drivers/media/dvb-frontends/

cp -v ${KERNEL_TBS}/drivers/media/tuners/av201x* \
      ${KERNEL_SRC}/drivers/media/tuners/

### Overwrite core DVB files
cp -v ${KERNEL_TBS}/include/media/dvb_frontend.h \
      ${KERNEL_SRC}/include/media/dvb_frontend.h

cp -v ${KERNEL_TBS}/include/uapi/linux/dvb/frontend.h \
      ${KERNEL_SRC}/include/uapi/linux/dvb/frontend.h

cp -v ${KERNEL_TBS}/drivers/media/dvb-core/dvb_frontend.c \
      ${KERNEL_SRC}/drivers/media/dvb-core/dvb_frontend.c

# Start to apply custom patches for TBS6910
cd ${KERNEL_SRC}

# Remove all 
for i in ${PATCH_DIR}/*.diff
do
    echo Patching $i
    patch -p1 < $i
done
