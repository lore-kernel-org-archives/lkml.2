Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab2IJFp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:45:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40945 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2IJFpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:45:23 -0400
Date: Mon, 10 Sep 2012 15:45:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the samsung tree with the mips tree
Message-Id: <20120910154512.d344ad91fc81caa90ebb05ba@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Sep_2012_15_45_12_+1000_xfT3etD15odJKzOi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Sep_2012_15_45_12_+1000_xfT3etD15odJKzOi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
drivers/pinctrl/Makefile between commit 3fa68afc3d77 ("OF: pinctrl: MIPS:
lantiq: implement lantiq/xway pinctrl support") from the mips tree and
commit 30574f0db1b1 ("pinctrl: add samsung pinctrl and gpiolib driver")
from the samsung tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/Makefile
index 26a86c7,6a88113..0000000
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@@ -33,7 -29,7 +33,9 @@@ obj-$(CONFIG_PINCTRL_TEGRA20)	+=3D pinctr
  obj-$(CONFIG_PINCTRL_TEGRA30)	+=3D pinctrl-tegra30.o
  obj-$(CONFIG_PINCTRL_U300)	+=3D pinctrl-u300.o
  obj-$(CONFIG_PINCTRL_COH901)	+=3D pinctrl-coh901.o
 +obj-$(CONFIG_PINCTRL_XWAY)	+=3D pinctrl-xway.o
 +obj-$(CONFIG_PINCTRL_LANTIQ)	+=3D pinctrl-lantiq.o
+ obj-$(CONFIG_PINCTRL_SAMSUNG)	+=3D pinctrl-samsung.o
+ obj-$(CONFIG_PINCTRL_EXYNOS4)	+=3D pinctrl-exynos.o
 =20
  obj-$(CONFIG_PLAT_SPEAR)	+=3D spear/

--Signature=_Mon__10_Sep_2012_15_45_12_+1000_xfT3etD15odJKzOi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTX5oAAoJEECxmPOUX5FE2mkP/RBUYv4+X7PYz1zlVgJP61ZN
CR/hMuVuI+CgV2AZw99Nz4BOwoc5nPDiCvXPOgVtqb/63hh7rwDrhJTioJyIvEgR
zrAyO6FDKPejbLTlcr4ivr8DRUi1mX88kdSk5HFBjocUlNkh6NI5seVVMoj3ep5p
7GMgBkYQOTCc/iAl0C8urgjKx3lbjpMnDQGBOVvvKnj9xAA6wdqDaBKzEOgYAF77
PSN1QA27UPwZWZQk636MmWbtitmY4jOMVZNFvmA9IbHlx2SYi1Qq+tXaSTOTJ8AO
l1R83DBpyeaJvyf+VCfafxS0n8SC4G+MIeoRcZ/Si3I8WHR9aWnr+FacNXZyQotR
SJezI399nPD11lYHmlN+MQ/ZsKtfTC0pF/VY3d3pM9r4g2YuN/KRytl1e4EyBysr
VCK3JTMkBXK9eCvG+rbDrTK+P3m5/mI6MvpKCniyICuiqvPKVOhIPUi/JyJelKA0
RboGB89f09hOih0pJ0h17nmnZPAPr/vZhnhtu8mFrIbNtVYj/XegLzeLANDHUhaX
9xfBj0iThWuO5UzelOwtbumh2PpuiA3g3rnyJpQ3asauUuF/EVkQQ42g+YM1lpij
JQ/keeVqjYEN5Ns6PCV4MDVZZxAnYKyKxYzVet7BPldAxxvVYuMuG8oJ3VqfKw0w
GbZkU1lLpANXS+NgXCLb
=Fix+
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Sep_2012_15_45_12_+1000_xfT3etD15odJKzOi--
