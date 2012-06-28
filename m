Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab2F1Coc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:44:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43158 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2F1Coa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:44:30 -0400
Date: Thu, 28 Jun 2012 12:44:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: linux-next: manual merge of the l2-mtd tree with the m68k tree
Message-Id: <20120628124426.72784808b38ecfad68901078@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Jun_2012_12_44_26_+1000_0lwk6p1cBFFDrv+_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jun_2012_12_44_26_+1000_0lwk6p1cBFFDrv+_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/maps/uclinux.c between commit 363737d66427 ("mtd/uclinux: Use
generic __bss_stop instead of _ebss") from the  tree and commit
1dc247e972b3 ("mtd: clean up uclinux.c map driver") from the l2-mtd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/maps/uclinux.c
index c3bb304,ded7916..0000000
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@@ -17,9 -16,6 +16,7 @@@
  #include <linux/mtd/mtd.h>
  #include <linux/mtd/map.h>
  #include <linux/mtd/partitions.h>
- #include <asm/io.h>
 +#include <asm/sections.h>
 =20
  /************************************************************************=
****/
 =20

--Signature=_Thu__28_Jun_2012_12_44_26_+1000_0lwk6p1cBFFDrv+_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP68UKAAoJEECxmPOUX5FExw8QAIRPl1SOI+VCZb0XPxB8VRA5
i8i7EhVgB1zb74FInTdj1r47T4I01SzGqyN60UwLS2oBrhqgd2mVVpXBjVwunFcF
BnMAQ52Zg15oP7Y+DMyNcZ2xy/GMUy+Hiu0ml2z+ZT8Ms0Jl9lNAlgBEGoubp7tG
hEQPlB+Er3uJblXintGK1uBoSevzOO4SQHB4yDdzbJ1ElQwGk0Euc24BBVrAA8m+
HUbTBlVtV4DZaJJ7gbXF+nB2o4P+ErmoEIjyRl3TtUoidhutEInQcHflVJbKGl5l
b5JK9mIxB80C8L8D0QxT5godHsWT8YRAaO7Rsr2QSfm9Z8MHai2cQ6RBN7+8Nr4T
YSOZcQTyc8KNGCS9/khXmKSGJCl19LV5UDRKtd1BkJZFSPkrXsmgWHer6YImSTjr
sKHr+W/N2e8ecDOW9WJEA2ctGvDqIs2t+2eAClvkzMjqCmendr3UROJMaK0On7Dr
LNMdhkTQattJ6YV9L3o6tiutX0qg/bCSDZylheELedZmQivc5Zh6bi1EVwbyZ/kp
ScVm8DfVphCdwXBN//Ei8EnWd2nJrGm0Hz1fMQ2R59suhMJdos5lmIJSFwF6anGY
QJvAyDccuTtvDSSxz1vJmRz6xi3XJnjYfEqcSZ+mqnTUgNuVLEHy8D3mKt8W4KD8
cNhUMC111GQaAaPz1ETy
=cbVA
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jun_2012_12_44_26_+1000_0lwk6p1cBFFDrv+_--
