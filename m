Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2ENHse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:48:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53490 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2ENHsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:48:19 -0400
Date: Mon, 14 May 2012 17:47:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the usb tree with the s5p tree
Message-Id: <20120514174743.de608c90ed9653d827707a7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_17_47_43_+1000_du_2U_J_mdH71ssL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_17_47_43_+1000_du_2U_J_mdH71ssL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got conflicts in
arch/arm/mach-exynos/mach-nuri.c  and
arch/arm/mach-exynos/mach-universal_c210.c between commits db6856e8d8ab
("ARM: EXYNOS: Add DRM core support for NURI board") and 6dafa4aead1b
("ARM: EXYNOS: Add DRM core device support for Universal C210 board")
from the s5p tree and commit 126625e1bf32 ("usb:hsotg:samsung:cosmetic
Move <linux/platform_data/s3c-hsotg.h> to proper place") from the usb
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/mach-nuri.c
index 17cce18,2c6d701..0000000
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@@ -25,7 -25,7 +25,8 @@@
  #include <linux/mmc/host.h>
  #include <linux/fb.h>
  #include <linux/pwm_backlight.h>
+ #include <linux/platform_data/s3c-hsotg.h>
 +#include <drm/exynos_drm.h>
 =20
  #include <video/platform_lcd.h>
  #include <media/m5mols.h>
diff --cc arch/arm/mach-exynos/mach-universal_c210.c
index 00c1a7b,bc8bf3b..0000000
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@@ -23,7 -23,7 +23,8 @@@
  #include <linux/i2c-gpio.h>
  #include <linux/i2c/mcs.h>
  #include <linux/i2c/atmel_mxt_ts.h>
+ #include <linux/platform_data/s3c-hsotg.h>
 +#include <drm/exynos_drm.h>
 =20
  #include <asm/mach/arch.h>
  #include <asm/hardware/gic.h>

--Signature=_Mon__14_May_2012_17_47_43_+1000_du_2U_J_mdH71ssL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsLifAAoJEECxmPOUX5FE+M4P/RCaireMbpAGraw6ZS7wp0Da
WxMmTvcMDIs86/PUyKT1482PpFfyqtUGIJxy0ZSyGyjAwHPO9rZmOc5KK5F9htQX
RHVd4DIeBzpAYGDz+pdvuLiitePJc4en1ov4nVkuVV579C/r7AcRvNWlPEzZYD42
B2tgqWlEhkQQrIrHxRrh4IDHpt4iLw0RkqDwyOC0Z7LvK2zXse3XmjTSZQKiXPTr
iBJ+DdCpLF4wAku+CuVtaPZRHdpO7G4c8KQDybQzbXAS89YtQw4iNnm2wXVwYa89
e/k8+5nMU4P4LWZl2olJ6FQnJJmLq1a5/BWZEvrnPZOgd5q4vD5B6pBX6ZV+xuWv
i66qpBT324z5smSGIGJXx2b+shpZckbEz+ihdzeorhEi2b9XaZI9kvxprNsWX2ku
jSxnBoLi+gFJdSmzm99zo7MYzQjjGe8SCWhRovsurRyg33oQWdQtV8jhV+X38K6V
tVxq2xSHUFm2W3rvGJbGLA7H0AxaK1NSYjymyvNJVDpKdx1BSJmgafGYU6HiRYCj
iL53ViaNjJT50VLs+FFbK5yvvKMCkeMBhQ4Oiv2bH8Vr7yah3oEgmFJxB3fPaQw/
rvpcEN4+cNFeG6Lion6aM0NfOptpHxPqYoJCJjQhtqw01q4DO2G3jWte1mshC5L1
NSPofC70KFQCF9gB4Z8B
=gCei
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_17_47_43_+1000_du_2U_J_mdH71ssL--
