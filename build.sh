#!/bin/bash -e

#rm -rfv *.pdf drp-ai_translator_release DRP-AI_Translator-v1.60-Linux-x86_64-Install meta-isp meta-openamp meta-openamp* meta-rz-features* meta-rzv2l-freertos* meta-drpai \
#	*.zip *.tar.gz r20ut5035ej0160-drp-ai-translator.pdf RTK0EF0045Z13001ZJ-v0.8_EN rzg2l_cm33_rpmsg_demo rzv2l_ai-evaluation-software rzv2l_ai-implementation-guide .cproject .project .settings \
#		rzv2l-drpai-conf.patch rzv2l-isp-conf.patch rzv2l_drpai-driver rzv2l_drpai-report rzv2l_drpai-sample-application License.txt app_isp_monitoring  app_tinyyolov2_cam app_isp_monitoring app_tinyyolov2_cam

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
IP_ADDR=$(ip address | grep 192.168 | head -1 | awk '{print $2}' | awk -F '/' '{print $1}')

function print_boot_example() {
	echo ""
	echo ">> FOR MMC BOOT"
	echo -e "${YELLOW} => setenv bootmmc 'setenv bootargs rw rootwait earlycon root=/dev/mmcblk2p2 video=HDMI-A1:1280x720@60; fatload mmc 1:1 0x48080000 Image; fatload mmc 1:1 0x48000000 r9a07g044l2-smarc.dtb; booti 0x48080000 - 0x48000000' ${NC}"
	echo -e "${YELLOW} => run bootmmc ${NC}"
	echo ""
	echo ">> FOR SD BOOT"
	echo -e "${YELLOW} => setenv bootsd 'setenv bootargs rw rootwait earlycon root=/dev/mmcblk0p2 video=HDMI-A1:1280x720@60; fatload mmc 0:1 0x48080000 Image; fatload mmc 0:1 0x48000000 r9a07g044l2-smarc.dtb; booti 0x48080000 - 0x48000000' ${NC}"
	echo -e "${YELLOW} => run bootsd ${NC}"
	echo ""
	echo ">> FOR USB BOOT"
	echo -e "${YELLOW} => setenv bootusb 'setenv bootargs rw rootwait earlycon root=/dev/sda2 video=HDMI-A1:1280x720@60; usb reset; fatload usb 0:1 0x48080000 Image; fatload usb 0:1 0x48000000 r9a07g044l2-smarc.dtb; booti 0x48080000 - 0x48000000' ${NC}"
	echo -e "${YELLOW} => run bootusb ${NC}"
	echo ""
	echo ">> FOR NFS BOOT"
	echo -e "${YELLOW} => setenv ethaddr 2E:09:0A:00:BE:11 ${NC}"
	echo -e "${YELLOW} => setenv ipaddr $(echo ${IP_ADDR} | grep 192.168 | head -1 | awk -F '.' '{print $1 "." $2 "." $3}').133 ${NC}"
	echo -e "${YELLOW} => setenv serverip ${IP_ADDR} ${NC}"
	echo -e "${YELLOW} => setenv NFSROOT '\${serverip}:$(pwd)/rootfs' ${NC}"
	echo -e "${YELLOW} => setenv boottftp 'tftp 0x48080000 Image; tftp 0x48000000 r9a07g044l2-smarc.dtb; setenv bootargs rw rootwait earlycon root=/dev/nfs nfsroot=\${NFSROOT},nfsvers=3 ip=dhcp; booti 0x48080000 - 0x48000000' ${NC}"
	echo -e "${YELLOW} => setenv bootnfs 'nfs 0x48080000 \${NFSROOT}/boot/Image; nfs 0x48000000 \${NFSROOT}/boot/r9a07g044l2-smarc.dtb; setenv bootargs rw rootwait earlycon root=/dev/nfs nfsroot=\${NFSROOT} ip=dhcp; booti 0x48080000 - 0x48000000' ${NC}"
	echo -e "${YELLOW} => run bootnfs ${NC}"
	echo ""
}

CORE_IMAGE=core-image-weston
CORE_IMAGE_SDK=core-image-weston
MACHINE=smarc-rzv2l
WORK=`pwd`

##########################################################
#
sudo umount mnt || true
mkdir -p mnt && sudo rm -rfv mnt/*
[ ! -f proprietary/r01an6238ej0100-rzv2l-cm33-multi-os-pkg.zip ] && exit 1
[ ! -f proprietary/r11an0549ej0500-rzv2l-drpai-sp.zip ] && exit 1
[ ! -f proprietary/r11an0561ej0100-rzv2l-isp-sp.zip ] && exit 1
[ ! -f proprietary/r20ut5035ej0160-drp-ai-translator.zip ] && exit 1
[ ! -f proprietary/RTK0EF0045Z13001ZJ-v0.8_EN.zip ] && exit 1
sudo chown -R ${USER}.${USER} meta-userboard-rzv2l proprietary/ ./build.sh

##########################################################
#
[ -d $HOME/.cargo/bin ] && export PATH=$HOME/.cargo/bin:$PATH
if [ 0 -eq `apt list --installed 2>&1 | grep clang-3.9 | grep -v WARNING | wc -l` ]; then
	echo -e "${YELLOW}>> apt-get install ...${NC}"
	sudo apt-get update
	sudo apt-get install -y libstdc++6 lib32stdc++6
	sudo apt-get install -y android-tools-adb quilt

	sudo apt-get install -y libdrm-dev libpng-dev
	sudo apt-get install -y linux-firmware
	sudo apt-get install -y git build-essential flex bison qemu-user-static debootstrap schroot nfs-kernel-server nfs-common
	sudo apt install -y --no-install-recommends git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget \
		python3-dev python3-pip python3-setuptools python3-tk python3-wheel python3-serial xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libhugetlbfs-dev libsysfs-dev sysbench

	sudo apt-get install -y binutils-aarch64-linux-gnu gcc-aarch64-linux-gnu
	sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libegl1-mesa libsdl1.2-dev pylint3 xterm cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libssl-dev
	sudo apt-get install -y e2fsprogs
	sudo apt-get install -y p7zip-full p7zip-rar

	sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat \
		cpio python python3 python3-pip python3-pexpect python3-git python3-jinja2 xz-utils debianutils iputils-ping libsdl1.2-dev xterm p7zip-full autoconf2.13
	sudo apt install -y clang llvm clang-3.9 llvm-3.9
	sudo apt-get install -y build-essential libasound2-dev libcurl4-openssl-dev libdbus-1-dev libdbus-glib-1-dev libgconf2-dev libgtk-3-dev libgtk2.0-dev libpulse-dev \
		libx11-xcb-dev libxt-dev nasm nodejs openjdk-8-jdk-headless python-dbus python-dev python-pip python-setuptools software-properties-common unzip uuid wget xvfb yasm zip
	[ "$(lsb_release -a | grep Codename: | awk '{print $2}')X" == "bionicX" ] && sudo apt-get install libcurl4 libcurl4-openssl-dev -y
	sudo apt-get install -y libftdi-dev
	sudo apt-get install -y diffstat unzip texinfo chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libsdl1.2-dev xterm p7zip-full
	sudo apt-get install -y android-tools-fsutils ccache libv8-dev pax gnutls-bin libftdi-dev
	sudo apt-get install -y gcc-aarch64-linux-gnu tftp tftpd-hpa nfs-kernel-server nfs-common tar rar gzip bzip2 pv fbi
fi
TFTPBOOT=/var/lib/tftpboot
[ -d ${TFTPBOOT} ] && sudo chmod 777 ${TFTPBOOT}

##########################################################
#
echo -e "${YELLOW}>> git clone ${NC}"
#(git clone git://git.yoctoproject.org/poky || true) &
#(git clone git://git.openembedded.org/meta-openembedded.git || true) &
#(git clone https://github.com/renesas-rz/meta-rzv.git || true) &
#(git clone https://git.yoctoproject.org/meta-gplv2 || true) &
(git clone https://github.com/meta-qt5/meta-qt5.git || true) &
wait

##########################################################
#
META_RZV2_COMMIT=rzv2l_bsp_v1.0
META_QT5_COMMIT=c1b0c9f546289b1592d7a895640de103723a0305
POKY_COMMIT=dunfell-23.0.5
META_OE_COMMIT=cc6fc6b1641ab23089c1e3bba11e0c6394f0867c
META_GPLV2_COMMIT=60b251c25ba87e946a0ca4cdc8d17b1cb09292ac

##########################################################
#
echo -e "${YELLOW}>> git ckeckout ${NC}"
#cd ${WORK}/poky && (git checkout -b tmp ${POKY_COMMIT} && git cherry-pick 9e444 || true)
#cd ${WORK}/meta-openembedded && (git checkout -b tmp ${META_OE_COMMIT} || true)
#cd ${WORK}/meta-rzv && (git checkout ${META_RZV2_COMMIT} || true)
#cd ${WORK}/meta-gplv2 && (git checkout -b tmp ${META_GPLV2_COMMIT} || true)
cd ${WORK}/meta-qt5 && (git checkout -b tmp ${META_QT5_COMMIT} || true)

##########################################################
### https://www.renesas.com/us/en/products/microcontrollers-microprocessors/rz-arm-based-high-end-32-64-bit-mpus/rzv2l-linux-package-419-cip-v100
cd ${WORK}
[ ! -e meta-rzv/recipes-kernel/linux/linux-renesas/patches/rzv2l/0006-ov5645-Add-VGA-720x480-and-720p-resloutions.patch ] && \
	(unzip -o proprietary/r01an6221ej0100-rzv2l-linux.zip && \
		tar zxvf r01an6221ej0100-rzv2l-linux/rzv2l_bsp_v100.tar.gz && \
			sed -i -e 's|35a832d08bddaf64b3dccbf364732ac7f8dfb647|c12017179a8ca11d38486f1ace08d52a489056d0|g' meta-rzv/recipes-bsp/u-boot/u-boot_2020.10.bb)

##########################################################
#
echo -e "${YELLOW}>> meta-rz-features ${NC}"
cd ${WORK}
[ ! -d meta-rz-features ] && (unzip -o proprietary/RTK0EF0045Z13001ZJ-v0.8_EN.zip && tar zxvf RTK0EF0045Z13001ZJ-v0.8_EN/meta-rz-features.tar.gz)
cd ${WORK}


cd ${WORK}
[ ! -e meta-openamp.zip -o ! -e meta-rzv2l-freertos.zip ] && (unzip -o proprietary/r01an6238ej0100-rzv2l-cm33-multi-os-pkg.zip)
cd ${WORK}
[ ! -d meta-openamp ] && (unzip -o meta-openamp.zip)
[ ! -d meta-rzv2l-freertos ] && (unzip -o meta-rzv2l-freertos.zip)
cd ${WORK}
[ ! -d rzg2l_cm33_rpmsg_demo ] && (mkdir -p rzg2l_cm33_rpmsg_demo && unzip -o rzv2l_cm33_rpmsg_demo.zip -drzg2l_cm33_rpmsg_demo && chmod +x rzg2l_cm33_rpmsg_demo/script/postbuild.sh)

cd ${WORK}
[ ! -x DRP-AI_Translator-v1.60-Linux-x86_64-Install ] && (unzip -o proprietary/r20ut5035ej0160-drp-ai-translator.zip && chmod +x DRP-AI_Translator-v1.60-Linux-x86_64-Install)
[ ! -d drp-ai_translator_release ] && (echo Y | ./DRP-AI_Translator-v1.60-Linux-x86_64-Install)

[ ! -e rzv2l_ai-evaluation-software/rzv2l_ai-evaluation-software_ver5.00.tar.gz -o ! -e rzv2l_drpai-sample-application/rzv2l_drpai-sample-application_ver5.00.tar.gz ] && \
	(unzip -o proprietary/r11an0549ej0500-rzv2l-drpai-sp.zip && rm -rf rzv2l_drpai-sample-application/Thumbs.db rzv2l_drpai-report/Thumbs.db)
[ ! -d meta-drpai ] && tar zxvf rzv2l_drpai-driver/rzv2l_meta-drpai_ver5.00.tar.gz

cd ${WORK}/rzv2l_drpai-sample-application
[ ! -d ./app_hrnet_cam -o ! -d app_resnet50_cam -o ! -d app_resnet50_img \
	-o ! -d app_resnet50_img -o ! -d app_tinyyolov2_cam -o ! -d app_tinyyolov2_img -o ! -d app_yolov3_img ] && \
	(tar zxvf rzv2l_drpai-sample-application_ver5.00.tar.gz)

cd ${WORK}
[ ! -e rzv2l_isp-sample-application_ver1.00.tar.gz -o ! -e rzv2l_meta-isp_ver1.00.tar.gz ] && (unzip -o proprietary/r11an0561ej0100-rzv2l-isp-sp.zip)
cd ${WORK}
[ ! -d meta-isp ] && (tar zxvf rzv2l_meta-isp_ver1.00.tar.gz)

cd ${WORK}/rzv2l_drpai-sample-application
[ ! -d app_isp_monitoring -o ! -d app_tinyyolov2_cam -o 0 -eq $(cat app_tinyyolov2_cam/src/camera.cpp | grep SRGGB10_1X10 | wc -l) ] && \
	(tar zxvf ../rzv2l_isp-sample-application_ver1.00.tar.gz)

cd ${WORK}/rzv2l_drpai-sample-application/app_tinyyolov2_cam/src
#patch -R -p1 -i rzv2l_app_tinyyolov2_cam_usb2mipi.patch || true
[ 0 -eq $(cat camera.cpp | grep SRGGB10_1X10 | wc -l) ] && patch -p1 -l -f --fuzz 3 -i rzv2l_app_tinyyolov2_cam_usb2mipi.patch

#cd ${WORK}
#/bin/cp -f extra/0003-enable-drpai-drv.patch meta-drpai/recipes-linux/linux/linux-renesas/0003-enable-drpai-drv.patch

cd ${WORK}
sed 's/master/main/' -i meta-openamp/recipes-openamp/libmetal/libmetal.inc
sed 's/master/main/' -i meta-openamp/recipes-openamp/open-amp/open-amp.inc

##########################################################
#
echo -e "${YELLOW}>> oe-init-build-env ${NC}"
cd ${WORK}
source poky/oe-init-build-env $WORK/build

##########################################################
#
echo -e "${YELLOW}>> local.conf / bblayers.conf ${NC}"
cd ${WORK}/build
/bin/cp -Rpfv ../meta-userboard-rzv2l/docs/template/conf/${MACHINE}/*.conf ./conf/
/bin/cp -Rpfv ../meta-userboard-rzv2l/conf/machine/include/rzg2l-common.inc ../meta-rzv/conf/machine/include
/bin/cp -Rpfv ../meta-userboard-rzv2l/conf/machine/smarc-rzv2l.conf ../meta-rzv/conf/machine

##########################################################
#
echo -e "${YELLOW}>> meta-userboard ${NC}"
cd ${WORK}/build
${WORK}/poky/bitbake/bin/bitbake-layers add-layer ${WORK}/meta-userboard-rzv2l
${WORK}/poky/bitbake/bin/bitbake-layers add-layer ${WORK}/meta-drpai
${WORK}/poky/bitbake/bin/bitbake-layers add-layer ${WORK}/meta-isp
${WORK}/poky/bitbake/bin/bitbake-layers add-layer ${WORK}/meta-openamp
${WORK}/poky/bitbake/bin/bitbake-layers add-layer ${WORK}/meta-rzv2l-freertos
${WORK}/poky/bitbake/bin/bitbake-layers show-layers

##########################################################
#
cd ${WORK}/build
${WORK}/poky/bitbake/bin/bitbake ${CORE_IMAGE} -v

##########################################################
#
if [ ! -d /opt/poky/${MACHINE} ]; then
	echo -e "${YELLOW} >> populate_sdk ${NC}"
	cd ${WORK}/build
	${WORK}/poky/bitbake/bin/bitbake ${CORE_IMAGE_SDK} -v -c populate_sdk
	echo /opt/poky/${MACHINE} > yes.txt && echo y >> yes.txt
	cat yes.txt | sudo ./tmp/deploy/sdk/poky-glibc-x86_64-$(echo ${CORE_IMAGE_SDK} | sed 's/-sdk//g')-aarch64-${MACHINE}-toolchain-3.1.5.sh
	rm -rf yes.txt
	sudo chmod +x /opt/poky/${MACHINE}/site-* || true
	sudo chmod +x /opt/poky/${MACHINE}/environment-* || true
	sudo chmod +x /opt/poky/${MACHINE}/version-* || true
fi

##########################################################
#
cd ${WORK}
if [ -d ${TFTPBOOT} -o -L ${TFTPBOOT} ]; then
	echo -e "${YELLOW}>> TFTPBOOT ${NC}"
	rm -rfv ${TFTPBOOT}/Image
	rm -rfv ${TFTPBOOT}/Image-*${MACHINE}*.bin
	rm -rfv ${TFTPBOOT}/Image--*
	rm -rfv ${TFTPBOOT}/Image-r*.dtb
	rm -rfv ${TFTPBOOT}/r9a*.dtb

	/bin/cp -Rpfv build/tmp/deploy/images/${MACHINE}/$(ls -l build/tmp/deploy/images/${MACHINE}/Image-${MACHINE}.bin | awk '{print $11}') ${TFTPBOOT}/Image
	cd ${WORK}/build/tmp/deploy/images/${MACHINE}
	for D in $(ls -l r9a*.dtb | grep '\->' | awk '{print $9}' | xargs file | awk '{print $1}' | sed 's!:!!g'); do
		L=${D}; S=$(file ${L} | awk '{print $5}');
		echo "S=$S L=$L"
		/bin/cp -Rpfv ${S} ${TFTPBOOT}/${L}
	done
	cd -
fi

##########################################################
#
echo -e "${YELLOW}>> exported rootfs ${NC}"
cd ${WORK}
mkdir -p ${WORK}/rootfs
sudo /bin/rm -rf ${WORK}/rootfs/*
sudo tar zxvf ${WORK}/build/tmp/deploy/images/${MACHINE}/${CORE_IMAGE}-${MACHINE}.tar.gz -C ${WORK}/rootfs
sudo tar zxvf ${WORK}/build/tmp/deploy/images/${MACHINE}/modules-${MACHINE}.tgz -C ${WORK}/rootfs
sudo /bin/cp -Rpfv build/tmp/deploy/images/${MACHINE}/$(ls -l build/tmp/deploy/images/${MACHINE}/modules-${MACHINE}.tgz | awk '{print $11}') ${WORK}/rootfs/boot/modules-${MACHINE}.tgz
sudo /bin/cp -Rpfv build/tmp/deploy/images/${MACHINE}/$(ls -l build/tmp/deploy/images/${MACHINE}/${CORE_IMAGE}-${MACHINE}.tar.gz | awk '{print $11}') ${WORK}/rootfs/boot/${CORE_IMAGE}-${MACHINE}.tar.gz
cd ${WORK}/build/tmp/deploy/images/${MACHINE}
for D in $(ls -l r9a*.dtb | grep '\->' | awk '{print $9}' | xargs file | awk '{print $1}' | sed 's!:!!g'); do
	L=${D}; S=$(file ${L} | awk '{print $5}')
	sudo /bin/cp -Rpfv ${S} ${WORK}/rootfs/boot/${L}
done
sudo chmod 777 ${WORK}/rootfs/boot
sudo chown -R ${USER}.${USER} ${WORK}/rootfs/boot/*

##########################################################
#
cd ${WORK}
if [ $(ls /dev/disk/by-id | grep SD_MMC | wc -l) -eq 0 \
	-a $(ls /dev/disk/by-id | grep Generic_USB_Flash_Disk | wc -l) -eq 0 \
	-a $(ls /dev/disk/by-id | grep General_USB_Flash_Disk | wc -l) -eq 0 \
	-a $(ls /dev/disk/by-id | grep usb-JetFlash | wc -l) -eq 0 \
	-a $(ls /dev/disk/by-id | grep usb-USB_Mass_Storage_Device | wc -l) -eq 0 ]; then

	echo -e "${YELLOW}>> sdk environment-setup-aarch64-poky-linux ${NC}"
	cd ${WORK}
	ls -ld --color /opt/poky/${MACHINE}
	ls -l --color /opt/poky/${MACHINE}
	echo ""

	echo -e "${YELLOW}>> ${CORE_IMAGE}-${MACHINE}.tar.gz ${NC}"
	cd ${WORK}
	ls -ld --color build/tmp/deploy/images/${MACHINE}
	ls -l --color build/tmp/deploy/images/${MACHINE}
	echo ""
	echo -e "${YELLOW}>> all succeeded ${NC}"

	print_boot_example
        exit 0
fi

##########################################################
#
echo -e "${YELLOW}>> SD_MMC / Generic_USB_Flash_Disk / General_USB_Flash_Disk / usb-JetFlash / usb-USB_Mass_Storage_Device ${NC}"
cd ${WORK}
if [ $(ls /dev/disk/by-id | grep usb-Generic-_SD_MMC | wc -l) -ne 0 ]; then
        SDDEV=$(ls -l /dev/disk/by-id/usb-Generic-_SD_MMC* | grep -v part | awk -F '->' '{print $2}' | sed 's/ //g' | sed 's/\.//g' | sed 's/\///g')
elif [ $(ls /dev/disk/by-id | grep usb-Generic_USB_Flash_Disk | wc -l) -ne 0 ]; then
        SDDEV=$(ls -l /dev/disk/by-id/usb-Generic_USB_Flash_Disk* | grep -v part | awk -F '->' '{print $2}' | sed 's/ //g' | sed 's/\.//g' | sed 's/\///g')
elif [ $(ls /dev/disk/by-id | grep usb-General_USB_Flash_Disk | wc -l) -ne 0 ]; then
        SDDEV=$(ls -l /dev/disk/by-id/usb-General_USB_Flash_Disk* | grep -v part | awk -F '->' '{print $2}' | sed 's/ //g' | sed 's/\.//g' | sed 's/\///g')
elif [ $(ls /dev/disk/by-id | grep usb-USB_Mass_Storage_Device | wc -l) -ne 0 ]; then
        SDDEV=$(ls -l /dev/disk/by-id/usb-USB_Mass_Storage_Device_* | grep -v part | awk -F '->' '{print $2}' | sed 's/ //g' | sed 's/\.//g' | sed 's/\///g')
else
        SDDEV=$(ls -l /dev/disk/by-id/usb-JetFlash* | grep -v part | awk -F '->' '{print $2}' | sed 's/ //g' | sed 's/\.//g' | sed 's/\///g')
fi
SDDEV=/dev/${SDDEV}

##########################################################
#
echo -e "${YELLOW}>> SD_MMC fdisk ${NC}"
sudo umount ${SDDEV}1 || true
sudo umount ${SDDEV}2 || true
sudo umount ${SDDEV}3 || true
sudo umount ${SDDEV}4 || true
sudo umount ${SDDEV}5 || true
sudo umount ${SDDEV}6 || true
sudo umount ${SDDEV}7 || true
sudo umount ${SDDEV}8 || true
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk $SDDEV
 d

 d

 d

 d

 d

 d

 d

 d

 n
 p
 1

 +1024M
 n
 p
 2


 t
 1
 c
 t
 2
 83
 p
 w
 q
EOF

##########################################################
#
echo -e "${YELLOW}>> SD_MMC boot ${NC}"
echo yes | sudo mkfs.vfat -n BOOT ${SDDEV}1
sudo mount -t vfat ${SDDEV}1 mnt
sudo rm -rfv ./mnt/*
sudo /bin/cp build/tmp/deploy/images/${MACHINE}/$(ls -l build/tmp/deploy/images/${MACHINE}/Image | awk '{print $11}') mnt/Image
sudo /bin/cp build/tmp/deploy/images/${MACHINE}/r8*.dtb mnt/
sudo /bin/cp build/tmp/deploy/images/${MACHINE}/$(ls -l build/tmp/deploy/images/${MACHINE}/modules-${MACHINE}.tgz | awk '{print $11}') mnt/modules-${MACHINE}.tgz
sudo umount mnt

##########################################################
#
echo -e "${YELLOW}>> SD_MMC rootfs ${NC}"
echo yes | sudo mkfs.ext4 -E lazy_itable_init=1,lazy_journal_init=1 ${SDDEV}2 -L rootfs -U 614e0000-0000-4b53-8000-1d28000054a9 -jDv
sudo tune2fs -O ^has_journal ${SDDEV}2
sudo mount -t ext4 -O noatime,nodirame,data=writeback ${SDDEV}2 mnt
sudo rm -rfv ./mnt/*
sudo tar zxvf build/tmp/deploy/images/${MACHINE}/${CORE_IMAGE}-${MACHINE}.tar.gz -C mnt/
sudo tar zxvf build/tmp/deploy/images/${MACHINE}/modules-${MACHINE}.tgz -C mnt/
sudo sync &
(for n in $(seq 1 1440); do sleep 1 ; if [ $(grep -e Dirty: /proc/meminfo | awk '{print $2}') -lt 4096 ]; then break ; fi; done ; killall watch ;) &
watch -d -e grep -e Dirty: -e Writeback: /proc/meminfo
echo -e "${YELLOW} >> SD_MMC umount ${NC}"
sudo umount mnt
sudo fsck.ext4 -y ${SDDEV}2

##########################################################
#
print_boot_example
exit 0
