Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1KYOOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:14:50 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:41341 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755414Ab1KYOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:14:49 -0500
Date: Fri, 25 Nov 2011 16:14:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] gpiolib: introduce gpio_set_deglitch
Message-ID: <20111125141444.GA13747@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <1322230120-14120-2-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <1322230120-14120-2-git-send-email-plagnioj@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 25, 2011 at 03:08:40PM +0100, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
> this will allow to manage the Glitch Input Filter
> as present on AT91 as example
>=20
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/gpio/gpiolib.c     |   44 ++++++++++++++++++++++++++++++++++++++=
++++++
>  include/asm-generic/gpio.h |    4 ++++
>  include/linux/gpio.h       |    5 +++++
>  3 files changed, 53 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index b7e5e75..d2b1833 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1563,6 +1563,50 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(gpio_set_pullup);
> =20
> +/**
> + * gpio_set_deglitch - sets @deglitch for a @gpio
> + * @gpio: the gpio to set deglitch
> + * @deglitch: deglitch level
> + */
> +int gpio_set_deglitch(unsigned gpio, unsigned deglitch)

sounds a lot like debounce, what's the difference ?

--=20
balbi

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOz6LUAAoJEIaOsuA1yqREL2YQAJ5Kg3J9jiF0bmTrCqys1oA1
7Y9rYQJqVlNGrm4LPr5X1jqorF/KyXO8WgNmQuihpUU3KFAK7oNtV4NcwTdt4psI
dstkzOxg5Y05NVj4iFaaHVDkZ0QkQzwoF32foccG7i774677bK9I1bYnCVKBokLK
sSrLgJz24WCl6cs4hL5JxAdDUq0H7Gys+kuAwplR/1uHMjUAunRcexAYpXvm8CDv
XjKhEJ5gED+3tjvYKczPvq1siXA8zEEYK9lC1yt8mzlVW/4S2W9ZCjmNb9xHw+wk
DlcbLVGvHn+MPBgnwWIYTLKoFy+gN4wBwaaK6FqmswnlV5VrNqACjBFPMoXllptE
2F4A3ySWG5dInOLnwwxeDpMjLv46UdUOAzKjA6m7377Ytp6dQcy70bbVYkybNhq0
LN61OgkZhdmt1TbMiCOK2dIyttpaZwsXA29qnsWlHCzBuX3QNVP5c0qCkUlf3LvF
PBC8Nu359n4Tt/KOVEdNHLGB6VHo/ASE67Rc3+BqjqJfhI2y9LW59HMpFr37xAF/
Pj1vt8mo98hBIV/LF+nGfPQ2OT9F7WYn4zmFarJjbE4I2XX5M9lbromD1BGA1VKp
8rw5sYVsgI2er+0CrWsCT6SXFiRUw5+DOswgUGF5AIl1mLRjW53+CtbKtWpeYZNg
RNodT4yJnbJWU7xyA88N
=zsNO
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
