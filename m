Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2EAFew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:34:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40152 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2EAFev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:34:51 -0400
Date: Tue, 1 May 2012 15:34:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the mfd tree
Message-Id: <20120501153441.5e101139fb096ef262ff1d2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_May_2012_15_34_41_+1000_cQY+nc9pdSogI7su"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_May_2012_15_34_41_+1000_cQY+nc9pdSogI7su
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mfd/ab5500-core.c between commit 9ea969f0d79d ("mfd: Mark const
init data with __initconst instead of __initdata for ab5500") from the
mfd tree and commit f76facc2354b ("mfd/ab5500: delete AB5500 support")
from the arm-soc tree.

The latter removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_May_2012_15_34_41_+1000_cQY+nc9pdSogI7su
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPn3XxAAoJEECxmPOUX5FEXigQAIDw3LyRP9znN1tV+a8Mv+5m
Ft95qTgcvcPNDgVdzo+fzDgWJ27gYzfe23jVzBMEjExKYD8nEqFc8vKl9KdNxRRM
HkgpFwOAo1znSsf6gtZXiWrFbg+S7yVAQHQBhHmGdezCn/sbgSNdMX/l5I9+P2rU
XIios0rrp9xoA+icWmd6QSEr/m0kVsLJjDmJNwqP2qGJHzI1Ej3sy1uQHsTpmmwh
s1t02pJtL278FoMD/qfEvooVXcSHut7Ud++OGryfsr4MfxtBpqH0FcBPu2CqKy4p
a0pVxABbrFfhWUMa32A+mBdE2x2bJBkgjLox8mcnwwhV+vuDHmK4VUeDbm3nplyT
pmd0WknfkfQh9aDfZe/VbafLv25R7n4VLa44d9OlIQM1mux2UWJDt+kAr6W8QUkm
Ctty+8+pN3LHU1M5HFuXXHFB98FlU+Fhkx117WagrGZEfDM2O4oWLrvHEyP5J6xK
q2e0bMORaEtnM5+z4Dop9nyzULUoL0sxcykNwSY6FBk0iu6UI7Rv8ggI9fqSOmVJ
qH0WDWVv+7WnM9Y15K9PrOZ5dwFEv1yHrszdFynk2dIrY1o3zGq+ZnJwzlL98eU/
amHjgJHHj6uBXX95L/k6FMKu5FbF3xrF06A//y0uOlyGqEIsXYy+zsd2t+8S9z8x
HckNEWdYdvbTgSAiIMam
=WzXM
-----END PGP SIGNATURE-----

--Signature=_Tue__1_May_2012_15_34_41_+1000_cQY+nc9pdSogI7su--
