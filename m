Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2AJAwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:52:32 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57960 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab2AJAwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:52:30 -0500
Date: Tue, 10 Jan 2012 11:52:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: please update the i.MX tree
Message-Id: <20120110115218.e00ab8c01abd5b9ae9a3b166@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jan_2012_11_52_18_+1100_Wdl1pFxuUNPIz2mp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jan_2012_11_52_18_+1100_Wdl1pFxuUNPIz2mp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

It looks like most (if not all) of the i.MX tree has been merged into the
arm-soc (and Linus') tree, so could you please update the i.MX tree to
eliminate the conflicts I am getting.

CONFLICT (content): Merge conflict in arch/arm/plat-mxc/include/mach/hardwa=
re.h
CONFLICT (modify/delete): arch/arm/mach-mx5/pm-imx5.c deleted in HEAD and m=
odified in i.MX/for-next. Version i.MX/for-next of arch/arm/mach-mx5/pm-imx=
5.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-mx5/Makefile deleted in HEAD and mo=
dified in i.MX/for-next. Version i.MX/for-next of arch/arm/mach-mx5/Makefil=
e left in tree.
CONFLICT (modify/delete): arch/arm/mach-mx5/Kconfig deleted in HEAD and mod=
ified in i.MX/for-next. Version i.MX/for-next of arch/arm/mach-mx5/Kconfig =
left in tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jan_2012_11_52_18_+1100_Wdl1pFxuUNPIz2mp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPC4vCAAoJEECxmPOUX5FEzcEP/ise0CeoRgT1M+0meRNoVw2t
ANySEBvaCLiti/Z0Gn4OlZ7apsmcAgqnIU9dK44BrrASmLD4Gg4LKCF9uunsKzwT
WkOPjVP5hAqsFQUB2UrhBV5HSjunBMnQR4qFXbvtOrTKe8kLj1gv2Xd1iUxoqrOx
fKoIYYICJ1zOdatvrIpmhm2RcW0X5/ifph8jlRgPiVKUG4b45vn8fDf4wT4Ohyum
zacgiDp7hTVW9dl47+aQ9HJfEIlTi/Osgx7fULZmFg9MXpC5lSPnWtj20D2ODmvH
6xGIEvKx7ZfvUkGt3wNy7FIMhuRhDOANbXza+ah3GtkjhXqQ482ysxGw+3yxissB
pmsB0OmatC2ZqbSmFGxNNUE72xCCONZa+0XlzAOSan7t2JquOTej3MUzxMHUc7ss
+HzgijjPo8hrWSxeIi5S4zhkLdBtarCu0qDV4z/1+oWRu1XIF9/DerqBt6KdAlRl
O9VaW3YKv1OeoR2pymIjeDMxszXFQQBxyQYXdttJWRlEH3s6Rv+IILn8KDsfdW/7
Ov/+aDwthsuSJpPA5YKEjGEMyyg2jvSiLr+Ie74SD6Gi81NCt/hKIiJdol2rDjIB
yRafmQ4Y/39XPWHwB1I/Ecx9zg0rpEnU/WUSL5H6VRfjqnEpin7crI0B6tZwREmD
X4YLU9WQLmPN8iwA7vA1
=W/Sn
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jan_2012_11_52_18_+1100_Wdl1pFxuUNPIz2mp--
