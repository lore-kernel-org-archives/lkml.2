Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1KCGzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:55:50 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47431 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab1KCGzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:55:48 -0400
Date: Thu, 3 Nov 2011 08:55:44 +0200
From: Felipe Balbi <balbi@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] ARM: OMAP: omap_device: Include linux/export.h
Message-ID: <20111103065543.GE16098@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320303023.17983.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5oH/S/bF6lOfqCQb"
Content-Disposition: inline
In-Reply-To: <1320303023.17983.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 03, 2011 at 02:50:23PM +0800, Axel Lin wrote:
> Include linux/export.h to fix below build warning:
>=20
>   CC      arch/arm/plat-omap/omap_device.o
> arch/arm/plat-omap/omap_device.c:1055: warning: data definition has no ty=
pe or storage class
> arch/arm/plat-omap/omap_device.c:1055: warning: type defaults to 'int' in=
 declaration of 'EXPORT_SYMBOL'
> arch/arm/plat-omap/omap_device.c:1055: warning: parameter names (without =
types) in function declaration
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  arch/arm/plat-omap/omap_device.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_d=
evice.c
> index cd90bed..f839f94 100644
> --- a/arch/arm/plat-omap/omap_device.c
> +++ b/arch/arm/plat-omap/omap_device.c
> @@ -78,6 +78,7 @@
>  #undef DEBUG
> =20
>  #include <linux/kernel.h>
> +#include <linux/export.h>

scripts/get_maintainer.pl would tell you to Cc
linux-omap@vger.kernel.org and linux-arm-kernel@lists.infradead.org

Care to resend Ccing those lists too ?

--=20
balbi

--5oH/S/bF6lOfqCQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsjrvAAoJEIaOsuA1yqREnFMP+wavwKOHXbkKhspc8fHeahMA
Cf/BNBzGacGuTCyiCQe2y15q6Q/jvN4HpgXt0DY+dNUwNz3YPBTC5MEQgCsz0WXR
c4WxePKz4mXTd+psP17p9ftucZgjsy4sECaZ/bFkpsgHDrpSCsK4jmbT4y9ZZ2Jx
yivy4wZf4d7H9ML31RV5LexUpDoRLrK7QGOE4MEPz3OB0NusnY1E8RLIASM859/Q
zTsVxqkwWh2y+w5cilffc3d/OXnFZu3dHFAJvVm47oucC1oAMNQxes+mYtxGXtg4
q6XaklMj7Q9R0bUukvhT/FhW2D3bPWlEpDrntaqadQXE48Jkb3VqNK6E/9yttO0L
SYi2Tn5U5o9wRcMbVEVut2be2Fd3e5Z3I7ioiL8y2wHEb+cOChmpS/JUJgjVABzX
z/5boHbcJFIcv/iqQLSRAo9qoPWU0td/XkDGDKeHdCPjXHnbMtYAuZA5OpPLXGPM
laQteo5LbL6xN8DGpWLCplWoZ/Es/hp6c1JnUfxqAMVFCVokd2cNpKKRcEjzb9Oi
qjvNQSqvqTm7HBoa3z3jSfIAi9IVjupYWLPDgvbOHKfBAjVdd2s8PmMG+FzOmrU5
Y7QqqOJS8G3vzsu9urKhGdHhOKXTKzA/6oRYhqik+FS29DQhRN2IUHoyUjWkjeAL
mHNqgFLI0s2gxw78ZrTf
=na+u
-----END PGP SIGNATURE-----

--5oH/S/bF6lOfqCQb--
