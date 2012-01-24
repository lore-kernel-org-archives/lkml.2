Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2AXA7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:59:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35107 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab2AXA7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:59:20 -0500
Date: Tue, 24 Jan 2012 11:59:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the arm-current tree with Linus' tree
Message-Id: <20120124115909.0c2119249212ac9669860afc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Jan_2012_11_59_09_+1100_XPWVt_+J5yVOddE3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jan_2012_11_59_09_+1100_XPWVt_+J5yVOddE3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next merge of the arm-current tree got a conflict in
arch/arm/mach-mx5/Kconfig between commit 784a90c0a7d8 ("ARM i.MX: Merge
i.MX5 support into mach-imx") from Linus' tree and commit a092f2b15399
("ARM: 7291/1: cache: assume 64-byte L1 cachelines for ARMv7 CPUs") from
the arm-current tree.

The former removed the file and merged its contents into
arch/arm/mach-imx/Kconfig, so I removed it and applied the following
fixup patch - which I can carry as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 24 Jan 2012 11:56:27 +1100
Subject: [PATCH] ARM: fix up for cache size assumed to be 64 bytes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-imx/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 09f357b..4defb97 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -87,7 +87,6 @@ config SOC_IMX35
=20
 config SOC_IMX5
 	select CPU_V7
-	select ARM_L1_CACHE_SHIFT_6
 	select MXC_TZIC
 	select ARCH_MXC_IOMUX_V3
 	select ARCH_MXC_AUDMUX_V2
--=20
1.7.9.rc0.23.g7e521

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__24_Jan_2012_11_59_09_+1100_XPWVt_+J5yVOddE3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHgJdAAoJEECxmPOUX5FEYdoP/1/T2FbDGJSfSRuXjawazs91
a/xPlATvKmqyhoJzQApuGjmdMHG5sp7sywNM6JWtoc/CfrdLqrbI68lQO68m5Qdq
jRnk+f+xg9Blm5Jj4MYYFIj+znYAoWCs2l42nj6clSAZU//MUeM3F4Th3HxAhDi9
EKqhNJmn05Ke38+xcIbd0IBlrUWTDVH6T0cXiIj7WWyeFWbjv9v7f2H3uwvLSA+W
ybgCi9A/g3aHiu9KEbsK+GVYlGJcIj7YW39X03sXsgRL2cJq1Qg1hYel54N7HQ8c
88EBzfQMBC5ide4diUPStm+8tBJ+sAqMsKHwy+jPHvVybZG8EvgONK0z2WLfKFI4
6nnKw6oRts4Cn8UcFi/RSnkOHZ5ENSWuKTahLNvd0SKcWT12KUVb9w5v19hO3SD3
JuE/aVrY9YR1g6VBFLJxQVWdtQPljgKCa5JAkMeavSzqP+2JuCWwbr0I35nHs31F
jmt8kYHSug+l42HmI6csLCW/U8+aSNTPULokeVndpXz1NK7OQb/1hXw+PH8Lo1j9
M08Ri+IKT3T/vQIOLrdKjwmS7iSnuvp1c8fPxALioQLeB9MEe2yk6wktv+mQl8hO
5LnVVLlaCFuIySLk8DiLLuHaEt3FtYzpmdMUCIiVCfsH/SmH55zRdBa2JRGuAHDx
WVDM3uaUrTyfKSBw6rqj
=j+bd
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jan_2012_11_59_09_+1100_XPWVt_+J5yVOddE3--
