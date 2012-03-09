Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2CIHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:09:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56069 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2CIHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:09:55 -0500
Date: Fri, 9 Mar 2012 18:09:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120309180948.a75b0a5378de34443c32963d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_18_09_48_+1100_7Ggdy4OawG6MHN08"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_18_09_48_+1100_7Ggdy4OawG6MHN08
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

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

--Signature=_Fri__9_Mar_2012_18_09_48_+1100_7Ggdy4OawG6MHN08
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWay8AAoJEECxmPOUX5FEVSsP/AyDr2gGlpCVEjXgDzeY4yxS
t21GX0PpqyO2Nlaxndie7FCYkuKTWMVlvre46SdGGQysPBQDSMK1qQ8d7SHuZEQy
JP9R2ztAdeFjYNmItzB2IprFQdPEmesBd025chCU8LU80wUasyXZSiDg2BUt7gQT
xhiNMKDZ1uEgfz8syp+Obmn81/Vi2SdcLjfjj6TSzGLmmzg0gVEGnfGt6c8Bc9Ol
SP2ciwJEDGs7RXaM71Zs2y6eLIoNfD8QMvpfOa/Y6nYFuWPbuzLW1exGeuHo2ru0
UwOnaozORAy22kFRbziEU5uTFJ30yVshMc7/K9sOZ7iwcHJnlD1nORqWmPTwDMpH
tBwUqJA/6vhs7Nsl66i0G+AMZ4sdc3WfHEGPx34Uh2vTrIxegU3e6wAGFkCg23OT
cqMIRFzWSyeuC34Bayj5c6LDwmYv5qVqck/4dKz2H17FHowTzp4mOqCpxTzV+Tpe
qOAtCgprfliJL6tR2bMH9tC63EO+MCGpRSbP+XUJrbuSXRm0aKetcIgwzLbRMVBt
0nlk74nPh8lV5WCoi3IF10lElYTIR8krWAWrn3jBwahOdjXqbYdVlApmAI4rOYeK
8kkKEvvDGzg5adbzBiQWY7t+cCnz2eDmYq5HmeF2xR/VV4RNHnXOJkTYa5JhYZzy
r7mRdEONuD4A6VtGU96B
=raQq
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_18_09_48_+1100_7Ggdy4OawG6MHN08--
