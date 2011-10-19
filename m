Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1JSLW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:22:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58528 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1JSLWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:22:25 -0400
Date: Wed, 19 Oct 2011 13:22:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
Message-ID: <20111019112220.GG3217@pengutronix.de>
References: <4E9D9558.7040705@cam.ac.uk>
 <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com>
 <1318982469.7569.1.camel@Joe-Laptop>
 <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com>
 <4E9E89F2.2060103@cam.ac.uk>
 <20111019102630.GE3217@pengutronix.de>
 <4E9EAEB7.6080601@cam.ac.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xs+9IvWevLaxKUtW"
Content-Disposition: inline
In-Reply-To: <4E9EAEB7.6080601@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xs+9IvWevLaxKUtW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Maybe something as simple as a comment in the checkpatch source
> to say that such a file / directory can cause false positives?

I'd hope this error message would be clear enough, what do you think?

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3dfc471..19e4de7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1506,7 +1506,7 @@ sub process {
 			if (!$file && $tree && $p1_prefix ne '' &&
 			    -e "$root/$p1_prefix") {
 				WARN("PATCH_PREFIX",
-				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
+				     "patch prefix '$p1_prefix' exists as file/directory. Make sure th=
is isn't a -p0 patch\n");
 			}
=20
 			if ($realfile =3D~ m@^include/asm/@) {

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xs+9IvWevLaxKUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6esuwACgkQD27XaX1/VRu0BgCaAj7PF8zH1DATntn2772Bj5YB
iekAn3fuO9fnFS78Q9+5Od54EjEUDMMf
=cKPW
-----END PGP SIGNATURE-----

--xs+9IvWevLaxKUtW--
