Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2JDEdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:33:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42711 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2JDEdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:33:14 -0400
Date: Thu, 4 Oct 2012 14:33:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20121004143311.e04a99036b0b6c519444d615@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_14_33_11_+1000_s_+EgHFD5KoUBCvR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_14_33_11_+1000_s_+EgHFD5KoUBCvR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/x86/include/asm/Kbuild between commit 10b63956fce7 ("UAPI: Plumb the
UAPI Kbuilds into the user header installation and checking") from Linus'
tree and commit e7a570ff7dff ("asm-generic: Add default clkdev.h") from
the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/Kbuild
index 1595d68,66e5f0e..0000000
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@@ -22,3 -22,9 +22,5 @@@ header-y +=3D sigcontext32.
  header-y +=3D ucontext.h
  header-y +=3D vm86.h
  header-y +=3D vsyscall.h
+=20
 -genhdr-y +=3D unistd_32.h
 -genhdr-y +=3D unistd_64.h
 -genhdr-y +=3D unistd_x32.h
 -
+ generic-y +=3D clkdev.h

--Signature=_Thu__4_Oct_2012_14_33_11_+1000_s_+EgHFD5KoUBCvR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbRGHAAoJEECxmPOUX5FE+24P/3b7YaNQ96EOb/FFAZ0Iamri
nZ6yp+87VFbPL00B9cLGCN5od7jy1PwUSZ7/uc8H7SiTEUWYlGgc28b35Wh36Ow5
8qLuEWhT71JGbJAAwxEkzFibE6LUNS5OU7W6LWu3r1kf9o7oNdSRJx0s+xfwUQmb
CVbLvFWJ/6S5XpD/7IE/V2f/rhJCDYBdibhQAE6pIxIy5IFBY0Ibgp2y2mKyAlCa
BAdlptFbgekmDxUeaHqaizpO07fL183E1ljjO4ljRBQrJ7m2K6PdybEFDA3vpyTk
MOTHOH27BXfx/b+y0cG3pV0KqXlqo7ACobTJTcVmhR3aFs7nvwRGVjaNVKLmasp3
TNDwt1vRPsoZVh8RIPBnE6I92S7SqLyWR4xOJaUzOWM5pExw18V83NI27XPQWbUd
BALSEFc4DIEzufKAKPJ/fXfORwGBdPeE60WOf3jHkqL6v80AlZ6Ju3JqPkfcgIeb
dARVBBSyNKxvMr1Hx1AqEAqrrabIl2S7ARPiU4QLcWavdVJLl2CDhbTr5W23bYEh
KzGLQY1/srNhy7fKuZKSCghuzDNsqxn5Mq774JmihSVB4un+aDTHfUijb+jhx/Hn
hbQBSv2t5XmEE4BuJ0Y4aQI+/GfJLFR2yQSPHJ97rgqzf/KwcHu4LMRkctW8jP93
dZyrAOF4r4+MWBd4rlHI
=ACo0
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_14_33_11_+1000_s_+EgHFD5KoUBCvR--
