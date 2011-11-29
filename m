Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1K2D0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:26:40 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52891 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1K2D0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:26:38 -0500
Date: Tue, 29 Nov 2011 14:26:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@snapgear.com>
Subject: linux-next: manual merge of the vhost tree with the m68knommu tree
Message-Id: <20111129142631.d0eea812ddee926bb7e9a5b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_14_26_31_+1100_/cJeyaTX+yr6o/uD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_14_26_31_+1100_/cJeyaTX+yr6o/uD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
arch/m68k/Kconfig between commit b366a24529e1 ("m68k: simpler m68k and
ColdFire CPU's can use generic csum code") from the m68knommu tree and
commit 4673ca8eb369 ("lib: move GENERIC_IOMAP to lib/Kconfig") from the
vhost tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/m68k/Kconfig
index 32fd364,973e686..0000000
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@@ -37,12 -38,6 +37,9 @@@ config GENERIC_CALIBRATE_DELA
  	bool
  	default y
 =20
- config GENERIC_IOMAP
- 	def_bool MMU
-=20
 +config GENERIC_CSUM
 +	bool
 +
  config TIME_LOW_RES
  	bool
  	default y

--Signature=_Tue__29_Nov_2011_14_26_31_+1100_/cJeyaTX+yr6o/uD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1FDnAAoJEECxmPOUX5FE7WAQAIa5TPKY5/JTGmgfTcyUWwo9
Mz/e4k9fpb7tvf2dAsMhQrM5DkRrJoN46K1UhYLqq56Ho3voKYo7mtcI49KTSI3D
sjeQ2rVV+cgJa8vjLgT5SMG7Nlr1gtZMFxveJRtSE+f8WN6yf9Rr2GJKCR15FTR/
Ecj+D+0U9hVqLKwnfJ0SFCS1xQoHsdBQO30GJllI4g46q6o7nbq4UPIkkx+A9wdy
cOSZ7dTST4vp+s+A3nbjqpd4w7WfrE2tcysV6hDFkzR9FnICmAUhdWt23C3NJ2Zt
yY9LqS5k3lwLsasQp2AfI0UYA4HCrFjw+6gA+YOOHRYrpzi3ZxEZ0L5ksSoWm1v4
wsSITB4/09fu6MKBSkMpMAAY4LzQ440Jn3uQ/VjBb/WUupULrNHA57R1x55fG0cc
EXXXIrJCXAFIPhFJnMvY5Arzpj4ccSVo2VQ55PHsbdwxrWRMHOIhlp3Dg4B/kYLC
MyjwvGp7Umdam+yJalTiYpwqWhAeZrpxYigoh2my0TFfUBrSCN5gAD4OSIuUT0aX
QFDHAOUP36iis6h5mU3WfASeV1TIKhmEWfhCiQpMfrHSx13IJTRjbPgQM29rZbw3
Abb9i1+bQYFwgmo7D7kwzBRBcnEi7+WpGSXzR0Xy9p5TR9MWPx/mdQxcuD40GHvv
pxqw5QGmor6rjpEUmRGY
=6TZX
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_14_26_31_+1100_/cJeyaTX+yr6o/uD--
