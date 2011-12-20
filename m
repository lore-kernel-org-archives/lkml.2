Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1LTFc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:32:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55801 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1LTFcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:32:23 -0500
Date: Tue, 20 Dec 2011 16:32:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: linux-next: build warning after merge of the fbdev tree
Message-Id: <20111220163214.351b13b464c46f506f329b30@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_16_32_14_+1100_dRa3gys=dCN8KbZf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_16_32_14_+1100_dRa3gys=dCN8KbZf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the fbdev tree, today's linux-next build (powerpc ppc64_defco=
nfig)
produced this warning:

drivers/video/matrox/matroxfb_base.c:150:2: warning: braces around scalar i=
nitializer [enabled by default]
drivers/video/matrox/matroxfb_base.c:150:2: warning: (near initialization f=
or 'vesafb_defined.colorspace') [enabled by default]
drivers/video/matrox/matroxfb_base.c:150:2: warning: excess elements in sca=
lar initializer [enabled by default]
drivers/video/matrox/matroxfb_base.c:150:2: warning: (near initialization f=
or 'vesafb_defined.colorspace') [enabled by default]
drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: braces around scalar =
initializer [enabled by default]
drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: (near initialization =
for 'matroxfb_dh_defined.colorspace') [enabled by default]
drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: excess elements in sc=
alar initializer [enabled by default]
drivers/video/matrox/matroxfb_crtc2.c:596:3: warning: (near initialization =
for 'matroxfb_dh_defined.colorspace') [enabled by default]

Introduced by commit fb21c2f42879 ("fbdev: Add FOURCC-based format
configuration API").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_16_32_14_+1100_dRa3gys=dCN8KbZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8B3eAAoJEECxmPOUX5FEvqkP/R8ANSkaz3Lb7RAbs0chnNQD
rXyjbarmgGC0QBKal8392nS2Vkj6Z4/VQ7nj7ArXC5I74sw2r+8cbEcrkJx7QFy0
r5JlTEPCMPY6HN87yuBg/JRARym/bJGzlffD+qPnerq6noh7a7fj1ONANWjNGJZz
hirp+EwGjx7+EvPkWKeU8pqn8fjF0tXdKeuKG5Bdwfa8tSy0Jwj2XQmu2ptC/NTW
Ilt0lYN9XCxTvifJCdzw314wbwL73nM72lMLFB4Ixs04nUv9i/W+BwcCxeoy+r/8
KmRI3ITYVbPAxyBIuyQCvGY5Oi8ALpSHQLZ4//kMBTgvM0BJbLwFFfFFJhzNoQiK
4pgFcFSELYQEhlA5KUeh9bWvuW8h56zVrWKF7EKNH+2+Lcq9B6dEo5PFnmPAmjAK
9mvmp2v4piMUv+/Y3XI/OwKIUGNzRUd3xiEKclWIhHasBuNRwNiU4bG4F+ZwN2hS
K5TUHyMK2yjDl+gmecOtizu4jWI+FvDMcG6GJ4aq1BisY+EpoP3CgnaSl07vG1qc
OISdzjdsGpmPcZ8UxHDHfgWfvSFUR6EP1CHsH0OhPgFjB+sia9UezBUTX0g/7bbt
UjF9iKE4p3PXfzOPgz4cMBa37UxMT2IFsN1APi4MDU9+OMGqMH3/W9G3O8fC+i/I
kWAY9vHUykQEvKQDDT2z
=g6TW
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_16_32_14_+1100_dRa3gys=dCN8KbZf--
