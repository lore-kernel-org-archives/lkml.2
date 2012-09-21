Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2IUM2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:28:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:8881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab2IUM2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:28:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="asc'?scan'208";a="195753109"
Subject: [GIT PULL] slave-dmaengine fixes
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dan Williams <djbw@fb.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VmG4NNGgvdKSFfCy+b0Y"
Date: Fri, 21 Sep 2012 17:54:05 +0530
Message-ID: <1348230245.1943.185.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VmG4NNGgvdKSFfCy+b0Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Hi Linus,

Please consider pull to receive few fixes on slave dmanengine.
There are two trivial fixes in pl330 driver and two in at_hdmac driver.

The following changes since commit ffc493062ce9987156945aa21a677d83a179fc0a=
:
  Laxman Dewangan (1):
        dma: tegra: enable/disable dma clock

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Nicolas Ferre (2):
      dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
      dmaengine: at_hdmac: check that each sg data length is non-null

Sachin Kamat (2):
      DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_re=
q()
      DMA: PL330: Check the pointer returned by kzalloc

 drivers/dma/at_hdmac.c |   13 ++++++++++++-
 drivers/dma/pl330.c    |   21 ++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

--=20
~Vinod

--=-VmG4NNGgvdKSFfCy+b0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJQXFxXAAoJEHwUBw8lI4NH4zIP/jUJonH8GEekb3pZpEpY7mhW
vMQB8A60rUFDpVWt0mbzl0ka5922oQOlHz3pUTzT0bAQbuWKpTh9xrD86ehuFEs0
NXTkooTEiijNjK3RVSAC7S5rd3P3uGQtRdZp6gQCz2alsg9fkqYCOo4dXjSVql+8
pyZBdDs0Tn02oaxe9a2JSaoCLcAlnPDLZ/CWDQ1cIQJ3i/BHE3F04IqYLVfGAH+Y
o4IAkEJ4nnhJjgOwk+1vze6Al+reVs558dFAMz7u3+a9kQEp4rDuwFJjzuj/9LAl
xDTAP2aZi4SnN+7Em+Bs+t8shbHOsoxk0Ypp+7NnHARGBRAEtJI47velxaUnfcKJ
InX96x5ZUmag5JAZp6WMSAoSSZR1mLsfAlP+fgaHj0+ycf9tOOsumRP424xLEQ8w
RTrCXTsYrK7OD8Z0bRpMumDQtnoz5nk/hy6nQVdwuKvL6j0vwPqqVG8Mw3AZkkMM
YI8c028kph4iGLu/WNkdJ3VjI3Ry/UOzQExn/XzcMj8gD5uK1WTZRDA2Yf3DyKtj
1C9NuUzZYUu3SQ4NV4fNGqj1W1jrzgqvYJCC2DJL7Tx+TkfLuovG+D34rvDztX3Q
Enxd4mzRgeLvxB0hEwXRcGmafNHmg/e2CGXHnOmUXg1wm5GZXr+/uEhdHb1ZWOs1
x0CAYiDwTGJr4uLBHj4Y
=g15t
-----END PGP SIGNATURE-----

--=-VmG4NNGgvdKSFfCy+b0Y--

