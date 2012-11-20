Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab2KTEcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 23:32:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58850 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849Ab2KTEcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 23:32:21 -0500
Date: Tue, 20 Nov 2012 13:32:12 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 0/2] mfd: arizona: Updates for v3.8
Message-ID: <20121120043211.GE4483@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yUw0eFUXHKnFujKq"
Content-Disposition: inline
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yUw0eFUXHKnFujKq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/mfd-arizona-3.8

for you to fetch changes up to ffe70f1e526c43b9bb56c9b4408b6e39d2b8473c:

  mfd: wm5102: Mark some more status registers as volatile (2012-11-20 13:21:54 +0900)

----------------------------------------------------------------
mfd: arizona: Enhancements for v3.8

These have all previously been posted.

----------------------------------------------------------------
Mark Brown (2):
      mfd: wm5102: Update maximum register
      mfd: wm5102: Mark some more status registers as volatile

 drivers/mfd/wm5102-tables.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--yUw0eFUXHKnFujKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqwfEAAoJELSic+t+oim9k8IP/ibbdwA1/wrPQyIteNrrRiDZ
lRwAOoAoaLBK4/zkb13l3so8kUwceEPPG40sCglXoUesBJhqlukohAz63veoGk8w
buerHzcerVHovGO9UOCecFaZwPmlYUHr1FZP1K3sMix6KJcLFjncvoY8wWUdKD3b
YKa79+TW2XIBKMiGkbd75clO4V65JKrARd6MsHKOj0eRRHljx2yQgMC5QxR/0c8X
pQM6tpfSiXbP6qdBdWik7mDq7D1mfegm5zEH0xiDRkjVfMsdfZ1eOz3pUST39rxA
bWLdC2bFp1pP4jfBn9j8PZRv/FNpVPOdLj/bkjp/m8rEPNPQabMKj+TZHc1C+CPD
67iK6qxj/cj0veWiHzJ8pNMpvSJWPLWqFTbA7x9vzphceQvpd+9oJetbn1CMHu7a
HTssCGkj+SoJ4nVb7rb0Zc2lrrOmthY3z1izs95sz+vEdKb3vW7nDlEql99nmiCi
5qIQXyLGEtDaffTAWUKJ8ynKXb+dvkI9+pds1PdhA0h+wlJx0mhm4zCxghDcZ6tu
tWGAR7yCmhK+5zfYppG4KqPnK5INphIJYvO4nWLbUcrZPWMrKLgllJ0aWJp5De+E
2R/Q/K15BtMLtrOeEQt8OuXvNxZGwwisrn3A1xMcv3HU5Cesom/HHqISBaxwKQrr
u6DNmGri5Ke7vvIeZe5B
=isQW
-----END PGP SIGNATURE-----

--yUw0eFUXHKnFujKq--
