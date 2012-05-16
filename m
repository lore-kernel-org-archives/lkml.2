Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab2EPID2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:03:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42985 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751Ab2EPIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:03:15 -0400
Date: Wed, 16 May 2012 18:03:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: linux-next: manual merge of the usb tree with the s5p tree
Message-Id: <20120516180303.3c3cff646c1a70a8ddf32e2a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_18_03_03_+1000_dFO9MIn6Azqzh5Dv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_18_03_03_+1000_dFO9MIn6Azqzh5Dv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-exynos/mach-universal_c210.c between commit 6dafa4aead1b
("ARM: EXYNOS: Add DRM core device support for Universal C210 board")
from the s5p tree and commit 126625e1bf32 ("usb:hsotg:samsung:cosmetic
Move <linux/platform_data/s3c-hsotg.h> to proper place") from the usb
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/mach-universal_c210.c
index dd8ec8d4,bc8bf3b..0000000
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

--Signature=_Wed__16_May_2012_18_03_03_+1000_dFO9MIn6Azqzh5Dv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs183AAoJEECxmPOUX5FEALUP/170sVoVGAzY5+BqYyf8gYDj
rFE5duwkUJ6BjBM152PE93iNg5GzX9REDHu0bMqiBZhcic2M5amhAcgTmpr8LfNX
U07ZkHTDC0glSkP5pO5bjhlXK/STBm0dbjTG+LKVhJk2j5cLL7GQro2meSCJGHZr
SU1Dcq4FOqiZ59HXsIK4xpc6BVQ4qxL27rJ3dCJc3KWM9uJUgTE1N7NvMSlRxKxm
gt7Ibcy1WLVgNjNOG/Pd94dGoE/v0nw5mnDLD4ptswbsI7WIscu9UIPKpbVpotu+
feGnAVzh7WvVI1fhVrZ1/TclhSQO06ggvRMwIKkblxJWIxEICuRqZtGYAxs5opKb
fH/tLAZ2YVkz6gbgwRcgGWYXGe3WvLep3YfxkmFat6l5MG9OUbt937FbWKUskm2s
CTFg5o+vnDkA530RrLImT2fXxJoszUDOP0rW+XaH7fNgsJVEoD5C2H3TXvoVj/Pb
TbROQONmhStn8CGVwBNEWP+0lT8MNACJK4F2GHGy9YjsuQrF39zyiFA9N/xKYpWb
gYo/GPJqh1/4ImnyyxFscyXlium4aoFj2KHjUz4ue/ko/Df9SjzqOyAbl0Shx+Ao
IfF7bRxZ+gUf1yBv0pUT6T7tlwNlzgcz9iu3eXXgluLTQVxvkUj6jqPvLzb41Z1d
fAHFJrCSa6DyXi3vFI+a
=Ckqv
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_18_03_03_+1000_dFO9MIn6Azqzh5Dv--
