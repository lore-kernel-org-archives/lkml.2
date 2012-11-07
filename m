Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2KGD3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:29:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40053 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2KGD3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:29:30 -0500
Date: Wed, 7 Nov 2012 14:29:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd and
 pinctrl trees
Message-Id: <20121107142916.824003a6c863320fbf379652@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Nov_2012_14_29_16_+1100_yuq29vtmzdtyTx5a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2012_14_29_16_+1100_yuq29vtmzdtyTx5a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-nomadik/board-nhk8815.c between commit 1cd2fc449091 ("ARM:
nomadik: fixup some FSMC merge problems") from the l2-mtd tree, commits
bb16bd9b9da4 ("pinctrl/nomadik: move the platform data header") from the
pinctrl and commit 44e47ccf8ab6 ("Merge branch 'next/multiplatform' into
for-next") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-nomadik/board-nhk8815.c
index ab7104f,5ccdf53..0000000
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@@ -30,11 -31,10 +32,9 @@@
  #include <asm/sizes.h>
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
- #include <asm/mach/irq.h>
  #include <asm/mach/flash.h>
  #include <asm/mach/time.h>
-=20
- #include <plat/mtu.h>
 -#include <mach/fsmc.h>
+ #include <mach/irqs.h>
 =20
  #include "cpu-8815.h"
 =20

--Signature=_Wed__7_Nov_2012_14_29_16_+1100_yuq29vtmzdtyTx5a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmdWMAAoJEECxmPOUX5FEZoIQAKOyJnUTfEj6Dh3JblJypZyE
sFlCoinpo9VgiPSK+ZU1+CEO8DllEyEnhIH+4D4qYdrvu2MHa5QdEzGy6mkHq6TU
PIFAJ9yK/YJ0HPMRAP8reDLbCGoJ+3gQlQFbfQ62vhUNJmGISmI+SJt9sOQdd4LV
G0c5Ba2dAnY9OQUM9ch3zCvIJjs5M15nOz0LcVOUkgmtOXTtnG4QvKWgQaLUhyPv
iWqooO6Ih7kHo4ULKyUwxMkNd7tbgFQ24F0AHzt+njf9APspWctMh7TW74N4EL+g
Kmj4CQJn3J2//vog5IRWVA+O7RvCnIVJ3yjzBHPcRqcUxCi8Y6FMXnq8408xTh1p
UZWdvCav/vFV7I3fNjquLmVkytGts5zahqKaknZJcSz0d0+1DV7rf6RaNEWPC/0S
W2usoGq66/eVVoYA2ngjFndp+3npO/NZVrmmOtD7CrrdzAEkmvGgmT3eMjOnBBzq
0dsYhFyWwzXkn3w3rasjzI6Eap4khrgIBv+OQc854A0fpkWPNTTJCG8d5gKVexsr
2p4D+6nH7+qvRuUAOAP4quUBN1+tGzveT5jZdSu5abodwtMUgSprdJquTxqTRs8V
jJdhVxCLGg4j5LqDliSS+78j4qrAxxtXokc7x3k2tK2ybU5DvDxDwaoDbEVnDTT4
Dg/t90WPPJvzK4FGNt2n
=l8Jr
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2012_14_29_16_+1100_yuq29vtmzdtyTx5a--
