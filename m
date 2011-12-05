Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1LEAB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 19:01:57 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39525 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1LEAB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 19:01:56 -0500
Date: Mon, 5 Dec 2011 11:01:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jamie Iles <jamie@jamieiles.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111205110141.90c553323cf5d29fd2c3eeae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Dec_2011_11_01_41_+1100_UnhDfWmtUkD_C9i_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Dec_2011_11_01_41_+1100_UnhDfWmtUkD_C9i_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s3c64xx/mach-crag6410.c between commit 774b51f8f826 ("ARM:
s3c64xx: convert to MULTI_IRQ_HANDLER") from the arm tree and commit
8504a3cb5cbc ("ARM: S3C64XX: Configure WM1250 EV1 GPIOs on Cragganmore")
from the s5p tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/mach-crag6410.c
index 988ac2e,b2381c1..0000000
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@@ -37,7 -37,8 +37,9 @@@
  #include <linux/mfd/wm831x/irq.h>
  #include <linux/mfd/wm831x/gpio.h>
 =20
+ #include <sound/wm1250-ev1.h>
+=20
 +#include <asm/hardware/vic.h>
  #include <asm/mach/arch.h>
  #include <asm/mach-types.h>
 =20

--Signature=_Mon__5_Dec_2011_11_01_41_+1100_UnhDfWmtUkD_C9i_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3AnlAAoJEECxmPOUX5FE4DgQAKl8W6ie7IRWu9iYC/SXpbzJ
rBPH/Zz36LCJUbpiRSxa5mlgBgSuZDHEjp0gsDXa0oybho+227R3Lp+qkmG8lK2O
XH1feX9WYtQJJ4nsfVwV7wke8av61s1ESnNLyQulxdg8kI4fxfOWPOCW1x7ECx/N
ifDmCH9WfjnR5qSNQN8cdKkpvoaSIk0lBRkeQdBa/4g6RnvQuhACDDnpnmKGCppI
G9C04XqA4e6P/+QhDCr2Fi3zgC5BO395WWtz0blPrxUw/bjlBBxx4we5za9E8CZ5
rj/IyjehSVlPnn4v9gIuWXJVv2uBSVgnFZOVLv90G1MW029vEgdzT1hlzNEmYKFm
ty5mDmBawuL9leTB6CEhOBhDVfiE42iqTNkWgSgUgsKkXoiEX/aXMs50dVbhm5Ri
8qyclyETm8l6Zip/aBOWginXHAGjHy3Fu27WGC49Bg8KduoEWnxGbjJjcHi7h2kV
H2+Zn34XcZWQYc7hRcYQIXo96XsFjnNA0VaqzuAVdkmcMzTGNm8Sw/EmU2iG6cdC
TvMrRsKv+4f5WFZ8mpHaQxmfv1jtGub+e1wuTi/W0PHa6lE64ViZR++P/ZTVMRN2
S80EbIg0ndP8/bkox3jxXoGmvIiBiY6CwHDaZIFha1oQunMOwoScxe+mcpdZDcWj
XDyFWeU49emmooyil4il
=GpjR
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Dec_2011_11_01_41_+1100_UnhDfWmtUkD_C9i_--
