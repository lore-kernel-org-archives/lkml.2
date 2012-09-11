Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2IKGfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:35:23 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:50347 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab2IKGfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:35:22 -0400
Date: Tue, 11 Sep 2012 09:30:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: samsung: use pr_* instead of printk
Message-ID: <20120911063048.GA18072@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <002f01cd8f4b$b1100a30$13301e90$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 10, 2012 at 08:59:11PM +0900, Jingoo Han wrote:
> This patch uses pr_* instead of printk.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/gpio/gpio-samsung.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index ba126cc..e38d990 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -45,7 +45,7 @@
>  #ifndef DEBUG_GPIO
>  #define gpio_dbg(x...) do { } while (0)
>  #else
> -#define gpio_dbg(x...) printk(KERN_DEBUG x)
> +#define gpio_dbg(x...) pr_debug(x)
>  #endif
> =20
>  int samsung_gpio_setpull_updown(struct samsung_gpio_chip *chip,
> @@ -926,10 +926,10 @@ static void __init samsung_gpiolib_add(struct samsu=
ng_gpio_chip *chip)
>  #ifdef CONFIG_PM
>  	if (chip->pm !=3D NULL) {
>  		if (!chip->pm->save || !chip->pm->resume)
> -			printk(KERN_ERR "gpio: %s has missing PM functions\n",
> +			pr_err("gpio: %s has missing PM functions\n",
>  			       gc->label);

I would rather see dev_* conversion instead.

my 2 cents

--=20
balbi

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQTtqYAAoJEIaOsuA1yqRETKYP/jkNWTtdkSKTi74OEsVNvbUZ
8S76SHeRsgJYWzqX8rm/jhP3fwAi4NTTX5aNewwZONh8zUQzWzZkEByYt0nPWBlh
WPnFuaVhw3eVVb2kVGrqL4KTGhFwkq3g4lSJXQq6RBtq7lrZ9apErUx+YGgkUH7u
IrqwHK3Zwxza8ATPjkyBZHNMCVktrDrXoo0BNyq4zuarpJLRk4G381o+gr91hhUQ
eE0MOdkqKmR9NmR87iH0FM18iztMciWzQOgmjHvA4vfLh4vNAhvO2GtPgQI9FGJT
RWXsINs2K5GcjYBY6XFqAg7FNYdejqi+zwIK11DDiFxAoONo1twuDi/h4lkNCwBd
oV+4Gl/pZZFzxid7ajjYNIOHn4iyg6ja7xyeiVZZWfMr1tz6w+lQKkNVxtRa0AAO
82fN+j+YG9o9IYyf7XfJqHgHRzwFMVfdNvJACrW7+s6i00ZoI57lEf+UKsYMWVbk
4xfojOmknzPCm4pYiry4tQ10KqQcdF0Ufk788VKvBqNy/F6ow0ipKazwEEs0zgEy
L6Ym32ZczKgjsuzxxtbttxen+WeKwZFrBJDZ6sIRf3Qru3eT87VIs9hBexpW9Uyw
X42pIzPmWGCwuKLiOM216r4RLxUsc88ibqSWeqdHp1lQuN2o6EIrqkxmh4wrHynR
r72wasJSw+8UIDn5Ux3D
=Dkk6
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
