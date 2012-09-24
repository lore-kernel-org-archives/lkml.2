Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab2IXKwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:52:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37669 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2IXKwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:52:22 -0400
Date: Mon, 24 Sep 2012 20:52:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20120924205209.9b5e4eae732348f0d2b9ced8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_20_52_09_+1000_dtlb+PmKJV=9n+6r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_20_52_09_+1000_dtlb+PmKJV=9n+6r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/Makefile.boot between commit 360a0cab5041 ("ARM:
move all dtb targets out of Makefile.boot") from the arm-soc tree and
commit d105f0b1215d ("ARM: dts: Add basic dts file for Samsung Trats
board") from the samsung tree.

I removed the bit from Makefile.boot and added the following merge fix
patch and can carry the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 24 Sep 2012 20:47:44 +1000
Subject: [PATCH] ARM: fix up for movemment of dtb targets

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/boot/dts/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d4ad2df..99e5e8e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -21,7 +21,7 @@ dtb-$(CONFIG_ARCH_DOVE) +=3D dove-cm-a510.dtb \
 	dove-cubox.dtb \
 	dove-dove-db.dtb
 dtb-$(CONFIG_ARCH_EXYNOS) +=3D exynos4210-origen.dtb \
-	exynos4210-smdkv310.dtb \
+	exynos4210-smdkv310.dtb exynos4210-trats.dtb \
 	exynos5250-smdk5250.dtb
 dtb-$(CONFIG_ARCH_HIGHBANK) +=3D highbank.dtb
 dtb-$(CONFIG_ARCH_IMX5) +=3D imx51-babbage.dtb \
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_20_52_09_+1000_dtlb+PmKJV=9n+6r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYDtZAAoJEECxmPOUX5FEcrEP/jEogPIQaJXJD8AldM0BGHlE
8QOym3ABB3rFA4FeAMP3dEqojApezqoOeBgeW2A4i2mvxcMuQft1NodA+M9piXCV
SoHBSfvRIqmnReANs5rfEVSpFnCSGIj45BgEZFlp18DW/ppKNIQ6OHpy9ABHCvEV
SG6m5BMZkNdsYUwtv1V2WcsC9qj9ayHw8HCa5yXfw2hQGPxGNVzxh4KAhn8HMXXV
UBtpqOWW4P5x+Pafo6kaDwE0OSDxHmGbFV3iLbsct4TLxqVugyzd1AmxBYcesndk
9x4AhWQOO2xPcvktdP2QCMNOkcBiLFnrY6qdov3A9UmV6ELF64TwLu8XiR3rMDMd
IUKiHvePSx/ixEhDQozfKXm7uLFZgulzO8/tbCGyRfMlkIvhqCOEyT6F03PAkuhr
Kbm5HEMaMTzWjy4BRuJA0RqMTY3kT14X5WhVTXg7spOjmVDsz1AxyTAvAlSBtjQg
gMDimYSUrJQNeF9YMHYIPeq06cbziyDlO84ciNSClOzKWx5mcG2J1XsTMNYAsJTL
ipapyD3IopYOPY6qdK/JpRqTsxAYMxJAL9Np/JJojXAPeeOlWvMgpMnr/xW5Q++N
5XDRVURPnZMCjYw8/GA5Wu9S3gV+39lqLwuXHQOYYuAA8VkBpqRUNpJg6JPBLLzW
5r/0t4R0uXPqrk44iEvp
=DMDv
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_20_52_09_+1000_dtlb+PmKJV=9n+6r--
