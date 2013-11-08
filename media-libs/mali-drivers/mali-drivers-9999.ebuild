# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 

DESCRIPTION="Sunxi Mali-400 support libraries"
HOMEPAGE="http://linux-sunxi.org/Binary_drivers"
EGIT_REPO_URI="https://github.com/linux-sunxi/sunxi-mali.git"
EGIT_HAS_SUBMODULES=1
LICENSE=""
SLOT="0"
KEYWORDS="~arm"
IUSE="fbdev X"

DEPEND="
	x11-libs/libdri2
	>=app-admin/eselect-opengl-1.2.7
"
RDEPEND="${DEPEND}"
PDEPEND="X? ( x11-drivers/xf86-video-fbturbo )"

# ABI detection doesn't work for my flavor of Gentoo (armv7a-hardfloat-linux-gnueabihf)
export ABI=armhf

src_compile() {
#	emake EGL_TYPE=framebuffer
	emake EGL_TYPE=x11
}

src_install() {
	local opengl_imp="mali-x11"
	local opengl_dir="/usr/lib/opengl/${opengl_imp}"

	mkdir -p "${D}${opengl_dir}"/lib
	mkdir -p "${D}${opengl_dir}"/include
	mkdir -p "${D}"/usr/include
	touch "${D}${opengl_dir}"/.gles-only

	cd "${S}"/include
	emake libdir="${D}${opengl_dir}"/lib/ includedir="${D}${opengl_dir}"/include/ install
	mv "${D}${opengl_dir}"/include/ump ${D}/usr/include

	cd "${S}"/lib/ump
	emake DESTDIR="${D}" install

	
	cd "${S}"/lib/mali
	emake libdir="${D}${opengl_dir}"/lib/ includedir="${D}${opengl_dir}"/include/ install
	cd "${D}${opengl_dir}"/lib
	# HACK: build dummy library stubs with the right sonames
	# to satisfy eselect-opengl
	gcc -shared -Wl,-soname,libEGL.so.1 -o libEGLcore.so \
		-L"${D}${opengl_dir}"/lib -lMali || die
	gcc -shared -Wl,-soname,libGLESv1_CM.so.1 -o libGLESv1_CM_core.so \
		-L"${D}${opengl_dir}"/lib -lMali || die
	gcc -shared -Wl,-soname,libGLESv2.so.2 -o libGLESv2_core.so \
		-L"${D}${opengl_dir}"/lib -lMali || die
	# udev rules to get the right ownership/permission for /dev/ump and /dev/mali
    insinto /lib/udev/rules.d
    doins "${FILESDIR}"/99-mali-drivers.rules
}

pkg_postinst() {
        elog "You must be in the video group to use the Mali 3D acceleration."
        elog
        elog "To use the Mali OpenGL ES libraries, run \"eselect opengl set mali\""
}

pkg_prerm() {
        "${ROOT}"/usr/bin/eselect opengl set --use-old --ignore-missing xorg-x11
}

pkg_postrm() {
        "${ROOT}"/usr/bin/eselect opengl set --use-old --ignore-missing xorg-x11
}
