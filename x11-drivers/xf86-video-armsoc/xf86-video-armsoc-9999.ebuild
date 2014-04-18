# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  Exp $

EAPI=5
inherit git-2 eutils xorg-2

DESCRIPTION="Generic VESA video driver"
KEYWORDS="~arm"
IUSE="+linaro"

RDEPEND=">=x11-base/xorg-server-1.10.99"
DEPEND="${RDEPEND}"

if ! use linaro; then
	EGIT_REPO_URI="https://chromium.googlesource.com/chromiumos/third_party/${PN}.git"
else
	EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/driver/${PN}"
#	EGIT_COMMIT='feaef1ff4bd3cef539dbcab6490bd353661d7b6f'
fi

src_prepare() {
	use linaro || epatch "${FILESDIR}/0001-compat-for-newer-xorg.patch"
	! use linaro || epatch "${FILESDIR}/0002-revert-calloc.patch"

	xorg-2_src_prepare
}

src_configure() {
	if use linaro; then
		econf --with-drmmode=exynos
	else
		xorg-2_src_configure
	fi
}

src_compile() {
	if use linaro; then
		emake
	else
		xorg-2_src_compile
	fi
}

src_install() {
	if use linaro; then
		emake DESTDIR="${D}" install
	else
		xorg-2_src_install
	fi
}
