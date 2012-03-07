Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031592Ab2CGA3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:29:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34014 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CGA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:29:35 -0500
Date: Wed, 7 Mar 2012 11:29:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>
Subject: linux-next: manual merge of the s5p tree with Linus' tree
Message-Id: <20120307112926.84043e2f2db878026ebfd72a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Mar_2012_11_29_26_+1100_3c_Li9oD24oapfyI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Mar_2012_11_29_26_+1100_3c_Li9oD24oapfyI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s3c2440/common.h between commit c1ba544f8154 ("ARM:
S3C24XX: Fix restart on S3C2442") from Linus' tree and commit
dd6f01b5ccba ("ARM: S3C2440: move mach-s3c2440/* into mach-s3c24xx/")
from the s5p tree.

The latter removed the file so I did that.  I also added this fix up
patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Mar 2012 11:26:40 +1100
Subject: [PATCH] ARM: S3C24XX: fix for Fix restart on S3C2442

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-s3c24xx/common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/common.h b/arch/arm/mach-s3c24xx/common.h
index 62a2e19..39f5394 100644
--- a/arch/arm/mach-s3c24xx/common.h
+++ b/arch/arm/mach-s3c24xx/common.h
@@ -17,7 +17,7 @@ void s3c2410_restart(char mode, const char *cmd);
 #endif
=20
 #ifdef CONFIG_CPU_S3C2440
-void s3c2440_restart(char mode, const char *cmd);
+void s3c244x_restart(char mode, const char *cmd);
 #endif
=20
 #endif /* __ARCH_ARM_MACH_S3C2410_COMMON_H */
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__7_Mar_2012_11_29_26_+1100_3c_Li9oD24oapfyI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVqvmAAoJEECxmPOUX5FEfcoP/2b1R6tiJ5UrgxcCg6SFsicG
hAJCw0Gvm5J8hC2tqMU3KFQ5u5ZyYekxgxrpYN4T7xKcJ0viOqfcHqHiyMeMQMVB
16rnvJdLP9aSZEBTm8Ji+YyT1tIdpQtksp7Gfiw1CvCsyuOO3l3th6K+TNfE+VEZ
9sJ3+a4jvSbFG3QtC+JsKBlPx7kSFSK1JVJc8wwfCykx2JhqKvzGiCgOjisC3H6E
6Y+Ahs5yYW9N9ZLkkS2wFlp/QD2Cx+KmrbT+XXgBqH8Epba9aWTK2TSbszXOraYF
kjck6lG2/7nVh47ovKuFSHC7114a0xKIHAhF627wl62korX3rb0Z8KUK8eXEEW5k
ij2WVULTxp8Yy57QmKlXeUiZS4YWgAmp8bsnUxDkwYwrNAKMibeZyTKJvEhnEGQF
LmyAcloMiNDJLuADNk6iTPoegdniTyhLFeXyj+8fYDRrLRDod2fLSrlyGdCStnLj
NufjV9hhtqTw3DxinLkehKKBXeEbNoCwD6bITbV0SfbNen29PBLIEiqA+g/CvM/A
Z2PimpTkqVF7tUS+zwxkGAWcNO9tuafsDl5l29XDSvm+Tx17nB76x2MxWpGPMkh2
2uh/78nDcBe4e92Lz5Y+94qE5xmVB6ezhRzg6iTc/mjm6EuZ1+/DJzKuzAsBXT26
7irtDECjuenGg754n6m5
=UbSX
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Mar_2012_11_29_26_+1100_3c_Li9oD24oapfyI--
