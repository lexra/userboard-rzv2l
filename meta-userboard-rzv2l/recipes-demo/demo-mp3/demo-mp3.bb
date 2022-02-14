FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
LICENSE = "CLOSED"

SRC_URI = " \
	file://coastal.mp3 \
	file://coastal.wav \
	file://mmc_download.sh \
"

S = "${WORKDIR}"

do_install () {
	mkdir -p ${D}/home/root/mp3
	install ${WORKDIR}/coastal.mp3 ${D}/home/root/mp3
	install ${WORKDIR}/coastal.wav ${D}/home/root/mp3

	chmod +x ${WORKDIR}/mmc_download.sh
	install -m 755 ${WORKDIR}/mmc_download.sh ${D}/home/root
}

do_configure[noexec] = "1"
do_patch[noexec] = "1"
do_compile[noexec] = "1"

# ALLOW_EMPTY_${PN} = "1"

FILES_${PN} = " \
	/home/root/* \
"
