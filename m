Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2LCFwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:52:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48142 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2LCFwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:52:30 -0500
Date: Mon, 3 Dec 2012 16:52:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20121203165218.c45a0500dcdd0a441ae3e7de@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Dec_2012_16_52_18_+1100_O=acR.5jmMX3l6M8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Dec_2012_16_52_18_+1100_O=acR.5jmMX3l6M8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/media/platform/omap/omap_vout.c between commit 950e2fb420d5
("[media] omap_vout: use omapdss's version instead of cpu_is_*") from the
omap_dss2 tree and commit 45c3eb7d3a07 ("ARM: OMAP: Move
plat-omap/dma-omap.h to include/linux/omap-dma.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/platform/omap/omap_vout.c
index 718e5f6,9935040..0000000
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@@ -44,6 -44,8 +44,7 @@@
  #include <media/v4l2-device.h>
  #include <media/v4l2-ioctl.h>
 =20
 -#include <plat/cpu.h>
+ #include <linux/omap-dma.h>
  #include <video/omapvrfb.h>
  #include <video/omapdss.h>
 =20

--Signature=_Mon__3_Dec_2012_16_52_18_+1100_O=acR.5jmMX3l6M8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvD4SAAoJEECxmPOUX5FEYjEP/1YURa5CrJycUi16DqZEzj8j
ZFq08qtXpxqWY8Qrh+NKtQKnqy4HKkL+9iO/3FWt5a7UHszLQGg9cz4qW7OdVLKC
yevfqGaLzzfYs7yEdYSpM23g/FO9vCexZ5quzNPb52hSI5DtXb83Ji0tFNYO+88I
JVMUZJd4sqe3SE5zT0R+xVo28Wvw/lTkoDI3+vcNhfJpwD1NxX8XIVTwuHoFwC2y
FZmgZ9ZMHafXO/5mmKmEpMzvU9WgfxfxQnj6qo66pjv0cjaZoEhyWtU7lDzOPkxS
gxF2qEpzQOTz6UGq6v1/XknJecfhsZLflN0txDYcZGVibYYi6APFs4f7dyQgcJiP
74r4QiGe6teDtgriQupkquZMogylAc1igyL3qTd6K9JWPUCWNqrTzYCl6K/KZo7Z
tYWRompnv2jjH6oD5dgZrlayQkTxcOa7/WCMtNx27ASpYHbWMd/tuYCPcEAZtq+T
mdSCtjtfE2fyAmHP7oJfaT5/HAOppm9iWjLz0UwXhlnnC2yyHi+TmrIaInmpt5xq
ey0QHtuXDn1EO0k4EpOWOvpdFZGR2cZ6itRz6nLmA70bYE9EW5L87DYmxaNHtRfq
tlq5F0ESxJfXtJ/i0vqwL8qchDWGlmOkGR/O8PBuAPan1c2QV6MV2ff2smHOeEWt
xN0qB4B+CD+2jogi6rgH
=F8lb
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Dec_2012_16_52_18_+1100_O=acR.5jmMX3l6M8--
