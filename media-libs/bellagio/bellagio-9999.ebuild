# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 autotools

DESCRIPTION="An Open Source implementation of the OpenMAX Integration Layer"
HOMEPAGE="http://omxil.sourceforge.net"
EGIT_REPO_URI="git://git.code.sf.net/p/omxil/omxil"
EGIT_BRANCH="samsung"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="-doc"
#IUSE="alsa doc fbcon ffmpeg jpeg mad vorbis"

#RDEPEND="
#	media-libs/alsa-lib
#	mad? ( media-libs/libmad )
#	vorbis? ( media-libs/libvorbis )
#	ffmpeg? ( virtual/ffmpeg )"
#DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable doc) 
}
#		$(use_enable alsa) \
#		$(use_enable fbcon fbvideosink) \
#		$(use_enable ffmpeg ffmpegcomponents) \
#		$(use_enable jpeg) \
#		$(use_enable mad madcomponents) \
#		$(use_enable vorbis vorbiscomponents)

src_prepare() {
			epatch "${FILESDIR}"/no_Werror.patch
			epatch "${FILESDIR}"/fix_doc_path.patch
	        eautoreconf
}
