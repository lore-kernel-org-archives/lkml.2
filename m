Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2KHU1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:27:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45346 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab2KHU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:27:52 -0500
Date: Fri, 9 Nov 2012 07:27:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the l2-mtd
 and pinctrl trees
Message-Id: <20121109072739.bb0f97bb571e66add1810d18@canb.auug.org.au>
In-Reply-To: <201211081511.54467.arnd@arndb.de>
References: <20121107142916.824003a6c863320fbf379652@canb.auug.org.au>
	<201211081511.54467.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_07_27_39_+1100__z.p4pRZPBryz/2J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_07_27_39_+1100__z.p4pRZPBryz/2J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Thu, 8 Nov 2012 15:11:54 +0000 Arnd Bergmann <arnd@arndb.de> wrote:
>
> I think this one turned out wrong, and is missing this part:
>=20
> diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadi=
k/board-nhk8815.c
> index 5ccdf53..69769b7 100644
> --- a/arch/arm/mach-nomadik/board-nhk8815.c
> +++ b/arch/arm/mach-nomadik/board-nhk8815.c
> @@ -26,7 +26,6 @@
>  #include <linux/pinctrl/machine.h>
>  #include <linux/platform_data/pinctrl-nomadik.h>
>  #include <linux/platform_data/clocksource-nomadik-mtu.h>
> -#include <linux/platform_data/mtd-nomadik-nand.h>
>  #include <asm/hardware/vic.h>
>  #include <asm/sizes.h>
>  #include <asm/mach-types.h>
>=20
>=20
> The mtd-nomadik-nand.h inclusion was removed in the l2-mtd tree, but
> moved to a different line in the arm-soc tree. It needs to be removed
> because the header is gone now.

Thanks for that.  I have now fixed up my fix up :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Nov_2012_07_27_39_+1100__z.p4pRZPBryz/2J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnBW7AAoJEECxmPOUX5FEfHsQAIza6hDljHrTrXlRIFZkBP2u
r9pjSGomOpQYob9Tn/MfT2QRjgf5bGnQNpAPFi2YjhSQj0Jky+EwEeSvvOgTrLUw
OotGxd3lC+JNPAJnxtTWfQx9t1TM7gmMl5F9twl5mzDQT/ElVmmf9xB1+HRmx/r0
4K/GEwJzWMC5s7Ak44nVxsJ9JX/bMKgqaW+XvUs8/6byuX4Tk8rKM8gXyUlH1f5e
umr5jg3jdm7H3yzDzOwV7Pinskwaa1YpaJyk4ZuqJgdVnhHWWAZCVQKEcjbLBpi6
hIM97oassi7WyFOExXVkm5ho5DtG2ZI9aQcVqj+5e0Vm0UKOmcimka0kufLh6YRc
dLMIXqyuBFM+ou0r+rnvRWbZbGQ8VC3pFdlZv1seG/z78OV2exGsAp77Q2BcG2U3
3L9GNuohLfSLCv9M2Xo80csfOmHJZsVMnMgnVguBmArI4aMG4ohg8D5azmotgfbJ
eubqMwKlfLD6aZ11f4+aTnVamIPMpHIAaMhyhS4Pte6QMuIJ/JDqB/u8dua264ym
KsPik51RuIfGLqRHIG0OBfCW+Ea04UwWQHwkrFke5RlsCFZ/y1AZlbaT3Q3ukwNi
IN4k4p/6po948yG48AUfPl+95hZG78cidAGh9dskRC01XFDc+ppUWPqh8N88Sb5y
KdQxa3jM6HC1aaSJK4Z1
=f6bN
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_07_27_39_+1100__z.p4pRZPBryz/2J--
