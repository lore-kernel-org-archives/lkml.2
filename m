Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566Ab2JZRqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:46:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:47379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965515Ab2JZRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:46:32 -0400
Subject: [GIT PULL] slave-dmaengine fixes
From: Vinod Koul <vkoul@infradead.org>
To: Linus <torvalds@linux-foundation.org>
Cc: vinod.koul@intel.com, Dan Williams <djbw@fb.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O4sSaaEPasACmXwRCiGQ"
Date: Fri, 26 Oct 2012 17:59:04 +0530
Message-ID: <1351254544.7077.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O4sSaaEPasACmXwRCiGQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please consider pull to receive three fixes for slave dmanegine.

Two are for typo omissions in sifr dmaengine driver and last one is for
imx driver fixing the misisng unlock

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37=
:
  Linus Torvalds (1):
        Linux 3.7-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Barry Song (2):
      dmaengine: sirf: fix a typo in dma_prep_interleaved
      dmaengine: sirf: fix a typo in moving running dma_desc to active queu=
e

Wei Yongjun (1):
      dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()

 drivers/dma/imx-dma.c  |    4 +++-
 drivers/dma/sirf-dma.c |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--=20
Vinod Koul
Intel Corp.

--=-O4sSaaEPasACmXwRCiGQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJQioIMAAoJEHwUBw8lI4NH5qwP/j+SN4q5BXDRjweok7Fz4asc
wXcKPdlHpF0BvebmvIG//Thp2BHkpN7y3NPa1h0svbMhBV5RnPiJhvGG3hEXR/K+
G0BV6EZvayyrwVl8m2g9ko2nsT3+Hn09KihRwtnMOiFyH4DswrayA391IydDC5rM
/wh5pBwrMjiAyxEp37c0XHqS5bfSgVwRlZKWzHHtd/dQ71Am3d+p74cL1FHk/5/N
Hmf7yJTtKIgG2o/v2bk3MJs/uVWIi+3b15BV1I55WmR5NCzUmYM1nRk8H8mjybab
Nv+maTckxALvvavEK4Stvu3h4F13eusn4LYnpzUSuEl9XivgVYumGDVsANIDzGv6
J63CqkeRRq1/ifMx4i/BeF2VJCbGgWntNqnqt12DntZQgP4dn+eLKUSQW6WIeID3
tNDaGWs9vH4NPHotjHzXl8h4RuvGFuCGF2GpBVQJcxGKu+PqLJ8wKkH2wicYtfKg
oGwDofETvNnkXS6x6e2O03aN3yaDpqTd1V9vOHFmm3xHvtW4FIyhf0BHEwZsAirL
IfktLQuMmeTlkboMTiNY4I0chnwZAdAPU3mXhlP/3LfutwKf1yeVy77rQqqesHe2
U0SbfdELlC123+7ZtUkPj4ZVckOco3Ljd61LCxRoaoVfp6bn+AvOgFy9gufU4UAF
rvc7w2WWszMybtvHYgVs
=4TVy
-----END PGP SIGNATURE-----

--=-O4sSaaEPasACmXwRCiGQ--

