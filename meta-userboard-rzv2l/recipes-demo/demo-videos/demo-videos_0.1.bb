LICENSE = "CLOSED"
DESCRIPTION = "Videos for demos"

SRC_URI = " \
	http://resource.renesas.com/resource/lib/img/products/media/auto-j/microcontrollers-microprocessors/rz/rzg/hmi-mmpoc-videos/h264-fhd-60.mp4;name=video1 \
	http://resource.renesas.com/resource/lib/img/products/media/auto-j/microcontrollers-microprocessors/rz/rzg/hmi-mmpoc-videos/h264-wvga-30.mp4;name=video2 \
	http://resource.renesas.com/resource/lib/img/products/media/auto-j/microcontrollers-microprocessors/rz/rzg/hmi-mmpoc-videos/h264-bl10-fhd-30p-5m-aac-lc-stereo-124k-48000x264.mp4;name=video3 \
	http://resource.renesas.com/resource/lib/img/products/media/auto-j/microcontrollers-microprocessors/rz/rzg/hmi-mmpoc-videos/h264-vga-24.mp4;name=video4 \
	http://resource.renesas.com/resource/lib/img/products/media/auto-j/microcontrollers-microprocessors/rz/rzg/hmi-mmpoc-videos/h264-hd-30.mp4;name=video5 \
"
SRC_URI[video1.md5sum] = "bb827df771f78ca8b0b35a58d24ad3ae"
SRC_URI[video1.sha256sum] = "a625e1b48aa5cae4f85eac9b073ef84259a42b7b7941a7c394d87b8e7da12283"
SRC_URI[video2.md5sum] = "d5d4988a9bfcd66d94a2d2f6a73cec36"
SRC_URI[video2.sha256sum] = "e6edd7c4830c0c5171b06b286599839a32123d0ed52bfc017c884385816f174f"
SRC_URI[video3.md5sum] = "33696ae57ae684e2cc6f83b3aabee005"
SRC_URI[video3.sha256sum] = "67f8a8695e7adf54f8d9b3db0e629d3a964c23d0c8011500d1695e618507d16c"
SRC_URI[video4.md5sum] = "f7c78c05ffcfeac4ae1ce06798dfbf05"
SRC_URI[video4.sha256sum] = "a37db801fa8b7edbcfa9c1dfeeee9c1504dd0bd8c67f83b549752add24927666"
SRC_URI[video5.md5sum] = "619825b0713dc39f7689c85750f136a7"
SRC_URI[video5.sha256sum] = "12f283bafefc7f43050b2bee3025245902943131ae496a46c8e79ea4e102fe65"

do_install () {
    install -d ${D}/home/root/videos
    cp -RPfv ${WORKDIR}/h264-*.mp4 ${D}/home/root/videos
}

INSANE_SKIP_${PN} += "ldflags"
do_patch[noexec] = "1"
do_cofigure[noexec] = "1"
do_compile[noexec] = "1"

PACKAGES = "${PN}"


FILES_${PN} = " /home/root/videos/* "

SRC_URI_append = " \
	https://download.kodi.tv/demo-files/BBB/bbb_sunflower_1080p_30fps_normal.mp4;name=video6 \
	http://www.peach.themazzone.com/durian/movies/sintel-1280-stereo.mp4;name=video7 \
	https://s3.amazonaws.com/senkorasic.com/test-media/video/caminandes-llamigos/caminandes_llamigos_720p.mp4;name=video8 \
	https://github.com/andreasbotsikas/DemoVideos/raw/master/elephants_dream.mp4;name=video9 \
	https://github.com/andreasbotsikas/DemoVideos/raw/master/tears_of_steel.mp4;name=video10 \
	http://download4.dvdloc8.com/trailers/divxdigest/fantastic_four_rise_of_the_silver_surfer-trailer.zip;name=video11 \
"
SRC_URI[video6.md5sum] = "babbe51b47146187a66632daa791484b"
SRC_URI[video6.sha256sum] = "ae51005850b0ff757fe60c3dd7a12d754d3cd2397d87d939b55235e457f97658"
SRC_URI[video7.md5sum] = "a452b16a02fd18f15a480956496ad063"
SRC_URI[video7.sha256sum] = "5f662cb1e8a3f1f7584c40410612347eb48b45b04908033bae9b8ffd9573490c"
SRC_URI[video8.md5sum] = "1fd6da4fe94ded49e59392b8b4299d1e"
SRC_URI[video8.sha256sum] = "346cfbb637cca8c59dd0ee1b1b8a3b4f81691a6c5900a8114ac9f15e229b1ba5"
SRC_URI[video9.md5sum] = "c8082e075790e4081c92517306a46458"
SRC_URI[video9.sha256sum] = "9e815b3c8518bd882011ee47b571d56a106ecdd82bd7145902aefd4129da59b7"
SRC_URI[video10.md5sum] = "dbb183bd1f4daed546b5c9c5d9f20972"
SRC_URI[video10.sha256sum] = "90090f8e3c2b7a210b1e21c6480a9eab0f7b78cda4509a38259a89e907260a12"
SRC_URI[video11.md5sum] = "7d1da4d27d0a585075560199c69378a5"
SRC_URI[video11.sha256sum] = "7405599f03ab7b9d1fb0fb29209c6b13aec2f16c1bf04e66084d52267ed7d16b"

do_install_append () {
	install -d ${D}/home/root/videos/bbb
	cp -RPfv ${WORKDIR}/bbb_sunflower_1080p_30fps_normal.mp4 ${D}/home/root/videos/bbb

	install -d ${D}/home/root/videos/sintel
	cp -RPfv ${WORKDIR}/sintel-1280-stereo.mp4 ${D}/home/root/videos/sintel

	install -d ${D}/home/root/videos/caminandes
	cp -RPfv ${WORKDIR}/caminandes_llamigos_720p.mp4 ${D}/home/root/videos/caminandes

	install -d ${D}/home/root/videos/elephantsdream
	cp -RPfv ${WORKDIR}/elephants_dream.mp4 ${D}/home/root/videos/elephantsdream/elephants-dream.mp4
    
	install -d ${D}/home/root/videos/fantastic4
	cp -RPfv ${WORKDIR}/'Fantastic Four - Rise of the Silver Surfer - Trailer.mp4' ${D}/home/root/videos/fantastic4/silver-surfer.mp4

	cd ${D}/home/root/videos/bbb
	ln -sf ../sintel/sintel-1280-stereo.mp4 .
	ln -sf ../fantastic4/silver-surfer.mp4 .
	ln -sf ../elephantsdream/elephants-dream.mp4 .
	cd -
}
