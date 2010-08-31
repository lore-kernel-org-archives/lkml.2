Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0HaJYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:24:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53110 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab0HaJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:24:08 -0400
Date: Tue, 31 Aug 2010 11:24:03 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, rabin.vincent@stericsson.com,
        linus.walleij@stericsson.com
Subject: Re: [PATCH] stmpe-gpio: Handle platform data with no gpio base
Message-ID: <20100831092403.GA4446@pengutronix.de>
References: <1283229296-16733-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1283229296-16733-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 31, 2010 at 10:04:56AM +0530, Virupax Sadashivpetimath wrote:
> This patch removes the requirement that gpio base be supplied in
> platform data.
>=20
> Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@sterics=
son.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

> ---
>  drivers/gpio/stmpe-gpio.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
> index 65b9960..932759d 100644
> --- a/drivers/gpio/stmpe-gpio.c
> +++ b/drivers/gpio/stmpe-gpio.c
> @@ -291,8 +291,6 @@ static int __devinit stmpe_gpio_probe(struct platform=
_device *pdev)
>  	int irq;
> =20
>  	pdata =3D stmpe->pdata->gpio;
> -	if (!pdata)
> -		return -ENODEV;
> =20
>  	irq =3D platform_get_irq(pdev, 0);
>  	if (irq < 0)
> --=20
> 1.7.1
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkx8yjMACgkQD27XaX1/VRtzAgCgirCy3iAkTpWg1bwuzHjkzowe
wKIAn3zcfBA9p6xwzwDSmukcBpsb72M9
=d1Bj
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
