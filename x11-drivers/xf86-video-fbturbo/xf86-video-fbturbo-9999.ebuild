# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit xorg-2 toolchain-funcs versionator

DESCRIPTION="Xorg DDX driver for the devices based on Allwinner A10/A13 SoC"
EGIT_REPO_URI="git://github.com/ssvb/xf86-video-fbturbo.git"

KEYWORDS="~arm ~amd64 ~x86"
IUSE="gles1 gles2"

RDEPEND="
	x11-base/xorg-server
	gles1? ( media-libs/mali-drivers )
	gles2? ( media-libs/mali-drivers )
"

DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xproto
	x11-libs/libdri2
"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
	)
	xorg-2_src_configure
}

pkg_postinst() {
elog 'QuckiStart /etc/X11/xorg.conf'
elog ''
elog 'Section "Device"'
elog '        Identifier      "Allwinner A10/A13 FBDEV"'
elog '        Driver          "fbturbo"'
elog '        Option          "fbdev" "/dev/fb0"'
elog ''
elog '        Option          "SwapbuffersWait" "true"'
elog 'EndSection'
}
