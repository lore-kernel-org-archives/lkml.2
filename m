Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2AEBJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:09:57 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43103 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab2AEBJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:09:55 -0500
Date: Thu, 5 Jan 2012 12:09:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20120105120945.255c1f33be31363233d5a195@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_12_09_45_+1100_UPk.raya5oAEiK/."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_12_09_45_+1100_UPk.raya5oAEiK/.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a lot of conflicts caused by
duplicates of commits in your tree and Russell's.  It looks like you have
merged a version of Russell's tree and then it has been rebased and added
to.  You need to fix up your tree with respect to Russell's.

This is a summary of the conflicts I get when I merge the s5p tree (after
merging the arm tree):

CONFLICT (modify/delete): arch/arm/plat-samsung/include/plat/system-reset.h=
 deleted in HEAD and modified in s5p/for-next. Version s5p/for-next of arch=
/arm/plat-samsung/include/plat/system-reset.h left in tree.
CONFLICT (content): Merge conflict in arch/arm/plat-omap/include/plat/syste=
m.h
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/system=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/include/mach/cr=
ag6410.h
CONFLICT (content): Merge conflict in arch/arm/mach-s3c2410/include/mach/sy=
stem.h
CONFLICT (modify/delete): arch/arm/mach-s3c2410/include/mach/system-reset.h=
 deleted in HEAD and modified in s5p/for-next. Version s5p/for-next of arch=
/arm/mach-s3c2410/include/mach/system-reset.h left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-rpc/include/mach/system=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-realview/include/mach/s=
ystem.h
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/include/mach/system=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-prima2/include/mach/sys=
tem.h
CONFLICT (content): Merge conflict in arch/arm/mach-pnx4008/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-orion5x/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-ti8168evm.c
CONFLICT (content): Merge conflict in arch/arm/mach-nomadik/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-netx/include/mach/syste=
m.h
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/include/mach/system=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/include/mach/common=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-mv78xx0/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-mmp/include/mach/system=
.h
CONFLICT (content): Merge conflict in arch/arm/mach-lpc32xx/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-lpc32xx/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-ks8695/include/mach/sys=
tem.h
CONFLICT (content): Merge conflict in arch/arm/mach-kirkwood/include/mach/s=
ystem.h
CONFLICT (content): Merge conflict in arch/arm/mach-ixp4xx/include/mach/sys=
tem.h
CONFLICT (content): Merge conflict in arch/arm/mach-ixp2000/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-iop33x/include/mach/sys=
tem.h
CONFLICT (content): Merge conflict in arch/arm/mach-iop32x/include/mach/sys=
tem.h
CONFLICT (content): Merge conflict in arch/arm/mach-iop13xx/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/include/mach=
/system.h
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
CONFLICT (content): Merge conflict in arch/arm/mach-highbank/include/mach/s=
ystem.h
CONFLICT (content): Merge conflict in arch/arm/mach-h720x/include/mach/syst=
em.h
CONFLICT (content): Merge conflict in arch/arm/mach-footbridge/include/mach=
/system.h
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/include/mach/ent=
ry-macro.S
CONFLICT (add/add): Merge conflict in arch/arm/mach-exynos/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-ep93xx/include/mach/sys=
tem.h
CONFLICT (content): Merge conflict in arch/arm/mach-ebsa110/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-dove/include/mach/syste=
m.h
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-cns3xxx/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-clps711x/include/mach/s=
ystem.h
CONFLICT (content): Merge conflict in arch/arm/mach-bcmring/include/mach/sy=
stem.h
CONFLICT (content): Merge conflict in arch/arm/mach-at91/include/mach/syste=
m.h
CONFLICT (content): Merge conflict in arch/arm/mach-at91/generic.h
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9rl.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9g45.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9263.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9261.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91sam9260.c
CONFLICT (content): Merge conflict in arch/arm/mach-at91/at91cap9.c

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jan_2012_12_09_45_+1100_UPk.raya5oAEiK/.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBPhZAAoJEECxmPOUX5FEkSsQAJq+ivNaXy22LreelLfkJ07f
nyAUXf69+XTLpB3+64CI53ifeqUjsaZMWhw4/UUwHXck9jeXtnXJWJlTUCYlesCn
D5Vqp+iv1mNHu48OVXIwvasTzColcbgFJurWXjF9Tdu2mrCCLDmQuwKgY1K+BErd
kFjeaPKpbJ6R5GrDGgFQpOIOm6eC+p8EnJjK9soumLji7bp/Z7GwRtxCrYJGM/03
BuYSgtK/vCrMEcTELyylUBE8rVeI/ShO5HXEC3J4ODdAXFcVJ/RiPztcIWOBCPKb
VDGfF4Nckul3GoQgfJSYlWiHvEUo+9mD6kDmvtKi9CNu6uFaSF8KPwsB8NNGgqvS
x266tM3g5T6D52iq9jouBCLcg3QwGx3Qmmvk+6xqogwGS+F77ieaerIEJtHABHgU
CjScr574v7ZjLUnCS3RfIs57NaamQ4hIzg1iBeVeBmcAvxqDfcRZMPlJjhSQd0YM
hpM37ubipyJgmvG31NaCXv+QdM78z66m8lAcV5huERc/JnScND9HxHnY03gNBwz5
YRJ6mp0jN1Wjvs/CwwuE+/OHMB1wHlph4HciS1431zpcThoQtyWPZqmDIIgz1Wkr
/tjGZdN364DUcZOVPYODV2wSAbEXVAOawamy+787z3Eql4DF4GvvZ7cRmHABXQ0m
pTtLOtbn+SF6O9mBaAIF
=fZz7
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_12_09_45_+1100_UPk.raya5oAEiK/.--
