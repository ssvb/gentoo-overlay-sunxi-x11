# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU Public License v2

EAPI="4"
inherit xorg-2 toolchain-funcs versionator

XORG_DRI="always"
XORG_EAUTORECONF="yes"

DESCRIPTION="X.Org driver for ARM devices"
EGIT_REPO_URI="git://git.linaro.org/arm/xorg/driver/xf86-video-armsoc.git"

KEYWORDS="~arm"

RDEPEND=">=x11-base/xorg-server-1.9"
DEPEND="${RDEPEND}"

src_unpack() {
        xorg-2_src_unpack
        mkdir -p "${S}"/m4
}

