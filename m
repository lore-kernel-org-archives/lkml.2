Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0IWTkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:40:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56833 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab0IWTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:40:30 -0400
Date: Thu, 23 Sep 2010 21:40:21 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        paulius.zaleckas@gmail.com, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, linux-serial@vger.kernel.org
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
Message-ID: <20100923194021.GA11663@pengutronix.de>
References: <20100923190212.18863.25678.stgit@darius-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20100923190212.18863.25678.stgit@darius-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 23, 2010 at 10:15:31PM +0300, Darius Augulis wrote:
> Swap device and driver names in serial/samsung.c
>=20
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> ---
>=20
> This patch was submitted about 3 months ago, but still not merged.
> There was another similar patch from Joonyoung Shim
> <jy0922.shim@samsung.com> and was discussed here:
> http://marc.info/?l=3Dlinux-serial&m=3D127416101222281&w=3D2.
> Joonyoung Shim acked my patch and other people on ARM mailing list
> acked it. The maintainer, Ben Dooks, still not responding for

Why didn't you add the ACKs to your patch? That will look more convincing f=
or
the one picking it up.

> a long time. Another maintainer, Kukjin Kim, refused to merge
> it without Ben's review.
> I would like to ask somebody pick up this bugfix.
>=20
>  drivers/serial/samsung.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
> index b1156ba..25c0d0f 100644
> --- a/drivers/serial/samsung.c
> +++ b/drivers/serial/samsung.c
> @@ -883,10 +883,10 @@ static struct uart_ops s3c24xx_serial_ops =3D {
> =20
>  static struct uart_driver s3c24xx_uart_drv =3D {
>  	.owner		=3D THIS_MODULE,
> -	.dev_name	=3D "s3c2410_serial",
> +	.driver_name    =3D "s3c2410_serial",
>  	.nr		=3D CONFIG_SERIAL_SAMSUNG_UARTS,
>  	.cons		=3D S3C24XX_SERIAL_CONSOLE,
> -	.driver_name	=3D S3C24XX_SERIAL_NAME,
> +	.dev_name       =3D S3C24XX_SERIAL_NAME,
>  	.major		=3D S3C24XX_SERIAL_MAJOR,
>  	.minor		=3D S3C24XX_SERIAL_MINOR,
>  };
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkybrSUACgkQD27XaX1/VRsXSQCeOkP69RU32uXgmCpgxMWbLe13
5UIAoJSPCrpzUQyUo6ZKt0LdKbxTBimS
=5Mc7
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
