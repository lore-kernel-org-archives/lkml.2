Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2CHGDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:03:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54145 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2CHGDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:03:16 -0500
Date: Thu, 8 Mar 2012 17:03:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20120308170303.c113c6c34b8a7ae95caeb592@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_03_03_+1100_jp+V.h6GWzOc..SX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_03_03_+1100_jp+V.h6GWzOc..SX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in arch/arm/mac=
h-omap1/board-palmz71.c between commit  ("") from the  tree and commit  (""=
) from the arm-soc tree.
Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap1/board-palmz71.c between commit ddba6c7f7ec6 ("OMAP1:
pass LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree
and commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
iomap.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap1/board-palmz71.c
index 9924c70,c1cd0f2..0000000
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@@ -27,9 -27,9 +27,10 @@@
  #include <linux/mtd/mtd.h>
  #include <linux/mtd/partitions.h>
  #include <linux/mtd/physmap.h>
 +#include <linux/omapfb.h>
+ #include <linux/spi/spi.h>
+ #include <linux/spi/ads7846.h>
 =20
- #include <mach/hardware.h>
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>

--Signature=_Thu__8_Mar_2012_17_03_03_+1100_jp+V.h6GWzOc..SX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWEuXAAoJEECxmPOUX5FE7vsP/ij7Fc+pVr8Drgte/h1Tbfh3
wekGi1P9a/tz+C6gHWR96sGOElY3tycVT2Q6rtDXIZwj/D5Io4t61P3bp3Q5XJ/F
YUz8NNVhkohpHGg76QhmGbO87BcMvtRlPMnNhqA5yrwi3WKEkPIG8+405ptUW2/H
lVfJSHAhEl54VC6jwromU33oDGYuNqzbHuSnfsG5pqEqiRjTj1w8lgyvtGaj1dl1
7S25pxV489LBKf1g/qByxmif/GNE3WGvN6bSDvqBNEimGnViTBOa7cvdp00y1vn1
TmFSUx0rcz2dL47xo0NWcQ+drI6Oq1vWwX7RqZm1J1qA1SId8nblgMP9baIxtxKo
FWdCgCmIbAj7cq5EX16qPImQ3OKbNIzmuTUSHtRlm031/29w4t4h8pPX+CGRelG0
5qSsyMRS7SepiCryCYucThmEpMq5bXzAe+NePJToXKP96E7Q4oplQThslbY8rXPq
0cTqiyOPBv174p9cLgDVK+hdOFCvibi93sbHgZPUPcRUZAgcBWzODLHoretymONC
/dwbKtgQJYbbhbFobehP+tMhAjmlc8P72fn8HgfNkoYp8KaMEwVtGuXMYhXWZ+ee
+YBlV2ovNg6FsSFFfaxQIwv9/UMnQ1cVnOvKrhWi3uHK2o0v/0/8ft/920NFT11V
Jjmm1jYVYvW//BS2oYxV
=kiWz
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_03_03_+1100_jp+V.h6GWzOc..SX--
