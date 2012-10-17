Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2JQXhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:37:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43581 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2JQXhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:37:23 -0400
Date: Thu, 18 Oct 2012 10:37:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the m68knommu tree with the  tree
Message-Id: <20121018103713.0ccb63374964501c3d8d99a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Oct_2012_10_37_13_+1100_8QhsR0pUH.oHt8q8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Oct_2012_10_37_13_+1100_8QhsR0pUH.oHt8q8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got conflicts in
arch/m68k/include/asm/termios.h, arch/m68k/include/uapi/asm/auxvec.h,
arch/m68k/include/uapi/asm/msgbuf.h, arch/m68k/include/uapi/asm/sembuf.h,
arch/m68k/include/uapi/asm/shmbuf.h, arch/m68k/include/uapi/asm/socket.h,
arch/m68k/include/uapi/asm/sockios.h and
arch/m68k/include/uapi/asm/termbits.h between commit 10b3a979347d ("UAPI:
(Scripted) Disintegrate arch/m68k/include/asm") from the m68k-current
tree and various commits from the m68knommu tree that use the asm-generic
versions.

I just deleted all those files and added the following merge fix patch
and can carry the fix as necessary.

I think that this is the correct thing to do ...

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 18 Oct 2012 10:32:20 +1100
Subject: [PATCH] m68k: fix up for UAPI changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/m68k/include/uapi/asm/Kbuild |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/m68k/include/uapi/asm/Kbuild b/arch/m68k/include/uapi/asm=
/Kbuild
index 972bce1..aebdbf5 100644
--- a/arch/m68k/include/uapi/asm/Kbuild
+++ b/arch/m68k/include/uapi/asm/Kbuild
@@ -2,25 +2,17 @@
 include include/uapi/asm-generic/Kbuild.asm
=20
 header-y +=3D a.out.h
-header-y +=3D auxvec.h
 header-y +=3D byteorder.h
 header-y +=3D cachectl.h
 header-y +=3D fcntl.h
 header-y +=3D ioctls.h
-header-y +=3D msgbuf.h
 header-y +=3D param.h
 header-y +=3D poll.h
 header-y +=3D posix_types.h
 header-y +=3D ptrace.h
-header-y +=3D sembuf.h
 header-y +=3D setup.h
-header-y +=3D shmbuf.h
 header-y +=3D sigcontext.h
 header-y +=3D signal.h
-header-y +=3D socket.h
-header-y +=3D sockios.h
 header-y +=3D stat.h
 header-y +=3D swab.h
-header-y +=3D termbits.h
-header-y +=3D termios.h
 header-y +=3D unistd.h
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__18_Oct_2012_10_37_13_+1100_8QhsR0pUH.oHt8q8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQf0EpAAoJEECxmPOUX5FEklcP/AgufGBpWDEHkNVTE6/G30rJ
MOWEuyIrB0Af9U6QdGG4JgHF2sG7HQYJhD/tkA3za6noBg029B8DTh9815Qc8CSb
rKEuJ69RNKes5CqdnnsWK7bNnb7ucJiU2w8jsiyWpW4tyxlbnCLYFcVnXeL8ye7G
K4FcaA9KWKpG64+nh7/+cGtq39O2QTBZZisBSH5TYOMdbGZfkslx3uW+SfD6v2wx
PV4m2WXcO3F0lMfD2Wavd018BnF6wb5o8t9l48fIFpmh3dl1WvOMt+HlaVXhgoJH
7rdTbpvvnckR1POL0IzxG3vh/k2jyimxxiyDblNxc/69pDAtkdtj3c5haphnjZSg
2ySnJn+P+eHk6O0dBTJnjCcSImlAVzDPrJ+pIc9VHvbKtXhu6ungm5lQgR+Smdly
fvDKefzyiDkSfZRo92IP42PdEptF6KJyc/hz7fBK/SmPlMHh+GSLQ6vbsTMHi0hm
/bceLiDLYvu6kK7HnLaVDfmxEJaXeIN+Wbc/m0xaCwEyyIBmlPf/Ug8fncQqGk91
F5RQShHg2vooPAgI90QXrqn57uFm2u32Q8MF0NW/UQmxx7pb3KF4ChyrkVKSeaY7
Mb1Jio2urhZRuSn2y7KGZ5TwiNjPgHVQTzMsRIxXSADluJlDxc8vwgeNmqyNd7Wv
lN1oml0pEzqkgvCROhYn
=XWdE
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Oct_2012_10_37_13_+1100_8QhsR0pUH.oHt8q8--
