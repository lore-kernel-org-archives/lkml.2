Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2CHGBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:01:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46837 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2CHGBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:01:00 -0500
Date: Thu, 8 Mar 2012 17:00:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120308170048.f1a992bca2ca2d93fa9747bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_00_48_+1100_I.c4/jde38ag/=ot"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_00_48_+1100_I.c4/jde38ag/=ot
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap1/board-palmtt.c between commit ddba6c7f7ec6 ("OMAP1:
pass LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree
and commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
iomap.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap1/board-palmtt.c
index b63350b,acd1f36..0000000
--- a/arch/arm/mach-omap1/board-palmtt.c
+++ b/arch/arm/mach-omap1/board-palmtt.c
@@@ -24,9 -24,9 +24,10 @@@
  #include <linux/mtd/partitions.h>
  #include <linux/mtd/physmap.h>
  #include <linux/leds.h>
 +#include <linux/omapfb.h>
+ #include <linux/spi/spi.h>
+ #include <linux/spi/ads7846.h>
 =20
- #include <mach/hardware.h>
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>

--Signature=_Thu__8_Mar_2012_17_00_48_+1100_I.c4/jde38ag/=ot
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWEsQAAoJEECxmPOUX5FEoisP/3v1LlKV/mpG0D5t+csigR85
vXJc/7KdfyK2tSuHZ8IKXXxcHz3+JV5vDkcwXVtc4AO6dUxuIdNFxC5fNb9BT0pT
kBMLlzp+cF/8rBmTVGkaDp239n5OAciRDW8YSEKDQ7x1JdFMt4GBBLGENgge+OmY
zgUIykHQ5YnKI+5vnqvyar1kmhIewQYZP+OUcP4hrHDyuj1tmSn13PjD046Z8A6Q
8kRlRMU9ZUdZz6FsnVbaEWxsPnWoYoot3BxdSbWMH6qm34Ok1XfXsJ6ijZQeTarQ
rZYOcdIqwUUWA5lsFAln1D2LGxYMqmwHcGXEbRAUWetMAGSglDnWqk+sG/JhU6+w
U7EDDcsOvMNHi7Z4YRugrURwjPxhRX/VhpRBfvDBf7vx58ZfvMGpnVdxernvVU1W
O+kQHToT8iUCe06dr2MptDUE22xY1bvilGwrlY6Tdf365z9fKngGTsHLOqrsHyXo
BwRFawNZHPJjRVSrdL7nD819PfcCKYo0bla3LeIoqZtdwtZq6dZtX7PK9ncGECpG
gjDKXDtXTmxRpsOXWYXOTjUzAFcodl8Mbbhmxtlrq3kOhIqsAMO+nQ7n75HG8Cbm
9qCeKwS4kXBzV0GEnHICU8kTUW0j8Igr1DDd/CM0AsgFJ4lte6WNMaYDTbMzjgdu
kLbtwqiDtdbmebyvPLfu
=KMZd
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_00_48_+1100_I.c4/jde38ag/=ot--
