Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2CHF6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:58:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57436 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2CHF6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:58:44 -0500
Date: Thu, 8 Mar 2012 16:58:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120308165838.c22b95e78c0ae3dd0ab1fea3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_16_58_38_+1100_wcj+mgPEKevrdPZi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_16_58_38_+1100_wcj+mgPEKevrdPZi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap1/board-osk.c between commit ddba6c7f7ec6 ("OMAP1: pass
LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree and
commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
iomap.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap1/board-osk.c
index ef87465,e2d7ae4..0000000
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@@ -34,8 -34,6 +34,7 @@@
  #include <linux/i2c.h>
  #include <linux/leds.h>
  #include <linux/smc91x.h>
 +#include <linux/omapfb.h>
-=20
  #include <linux/mtd/mtd.h>
  #include <linux/mtd/partitions.h>
  #include <linux/mtd/physmap.h>

--Signature=_Thu__8_Mar_2012_16_58_38_+1100_wcj+mgPEKevrdPZi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWEqOAAoJEECxmPOUX5FE4DAP/iZ1hl8tpkGSaDlgrXvMa5gh
1B6j/j1ZjH5Tvzsy8L/2wHLMvbSj5mx0p3FHuL6YHA8AiZW92IdXFkNoFrR//UGH
kWzR6NVkMygTocqIO0+lC0DySDULIc8E9hJph+QZBZmwKFZQ4V9JiODKKs+mlgSH
iXdZmIAONBboAK2tCkswAy0wGwZ/2aMMDx/b645JkbLqbOp+6qVx5bHR0+fr8yvi
oDZIUZQuA2Jv0jOsEpqmVOE8IDLdZHi43vEypUcs1rhqtT2jN26iMj50QlO8gm0x
gy+dY/OvzlR97Yk9qcDJFIASWFi+xZTkZjZQ9as39QPbqHUFMl6zI0ynYPabHNkB
fGtVPC4pA62awstHHR++7yu0jbaOUt9soDKvvquS5oJGjOJLHuIwJePZr0dTBC1H
xsJHolcZojpybPIDqXSda5/HNjhthBNoM5Dl+sEstIRebO7bU7tmc1LrbIxjbkDG
dTNF5f0SlHaS4pyt4FDZ7bFrsRowhTEHSN2R/9lzzR5vWg6ED61sFaOW0oiIRWZB
lmYG9DGJC2XUGRPYvN5xqhq51HEkOXYUxdOoZNYQDJfD7phiZYl38wIFPLwawZd2
/li35CrjIXHrL14Xx9izF7r/syNF3i0BpBorXXB8at75wJBGLNP9uVJ5N7Oi2TyL
zl/uwhyaiByuaCs27zeR
=ZG9b
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_16_58_38_+1100_wcj+mgPEKevrdPZi--
