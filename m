Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2CHGRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:17:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45649 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2CHGRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:17:24 -0500
Date: Thu, 8 Mar 2012 17:17:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20120308171716.67ef72a3b195ef25f1d781d6@canb.auug.org.au>
In-Reply-To: <20120308170303.c113c6c34b8a7ae95caeb592@canb.auug.org.au>
References: <20120308170303.c113c6c34b8a7ae95caeb592@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_17_16_+1100_3nz4HUxYWJpr2pc7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_17_16_+1100_3nz4HUxYWJpr2pc7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi guys,

Sorry for the cut and paste mess ... :-(

On Thu, 8 Mar 2012 17:03:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> Today's linux-next merge of the arm-soc tree got a conflict in arch/arm/m=
ach-omap1/board-palmz71.c between commit  ("") from the  tree and commit  (=
"") from the arm-soc tree.
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap1/board-palmz71.c between commit ddba6c7f7ec6 ("OMAP1:
> pass LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree
> and commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
> iomap.h") from the arm-soc tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary.
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/mach-omap1/board-palmz71.c
> index 9924c70,c1cd0f2..0000000
> --- a/arch/arm/mach-omap1/board-palmz71.c
> +++ b/arch/arm/mach-omap1/board-palmz71.c
> @@@ -27,9 -27,9 +27,10 @@@
>   #include <linux/mtd/mtd.h>
>   #include <linux/mtd/partitions.h>
>   #include <linux/mtd/physmap.h>
>  +#include <linux/omapfb.h>
> + #include <linux/spi/spi.h>
> + #include <linux/spi/ads7846.h>
>  =20
> - #include <mach/hardware.h>
>   #include <asm/mach-types.h>
>   #include <asm/mach/arch.h>
>   #include <asm/mach/map.h>


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_17_17_16_+1100_3nz4HUxYWJpr2pc7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWE7sAAoJEECxmPOUX5FEVzkP/3t5wP4AQfj4c653Q4r/CHzB
u/fO0m0Qt+YaNDYh5iWeJYZv/hL7rAvbI/0Hzq2TQdVBRM/JuBM36HhlKKsSU3nN
uauLXRmU8zNL6N9hF8n5t9KG2I3riPNKmGXDGrI2AnBvk1BfbdqnWwdTaROKuJJn
Qz/YBbBA99/xoqn8cXOnOyZ3H0iYi7I4LbXNSp/3diJCTPc7QT6odTXadPlvQpqb
oMd3PtClOvoIMnPX+UklUdEGPih5M1nWA5wL1nEAAHz8JM0vgNpGQz9L496YBYey
LN7nU+/ILsG/GBgVrVMVNqYcnlSk5Sor+QxNEUg9V9d9yMeWXDTu1CWMBKzl5dQB
G09e3Mfu8qOw3aDvOWOPa1DGRJoLfV9Sbb5DK5JczVfSgolVZVzoMWaBFX+cnCsx
x28hiH1obiqj5EIynPA0A4HLbHbfINOo2Ogm88/WGQLwROM/DWloyFu3LhI0URBQ
2lL44OKRHr9NLDkovYIZYMNDzEM6tGLSaEKLiRQ+SwOqgGjS+Epoij7fnGdzWOuf
8FcAwVwsZSwJ0lpo7OQdRbOtPRORhU9SC28n0dUbud9rQ/xF4L1DqZ6sVRCTmKaO
KEC9KgU0ntVh5m2o7N1ZpzyZrsDJrlZkyF3310hI6upIkOyr6EDP0yt2Nqh/ns46
o5KjszWequtavXnrOLlC
=6713
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_17_16_+1100_3nz4HUxYWJpr2pc7--
