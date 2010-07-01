Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0GAM32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:29:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33458 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab0GAM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:29:26 -0400
Date: Thu, 1 Jul 2010 14:29:24 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
       l.fu@pengutronix.de
Subject: Re: [PATCHv3 2/3] gpio: add STMPE GPIO driver
Message-ID: <20100701122924.GC4092@pengutronix.de>
Mail-Followup-To: Rabin Vincent <rabin.vincent@stericsson.com>,
	linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
	STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
	l.fu@pengutronix.de
References: <20100627235515.GB9264@sortiz-mobl>
 <1277985648-28468-2-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <1277985648-28468-2-git-send-email-rabin.vincent@stericsson.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:25:40 up  6:13, 12 users,  load average: 0.11, 0.08, 0.01
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rabin,

On Thu, Jul 01, 2010 at 05:30:47PM +0530, Rabin Vincent wrote:
> Add support for the GPIOs on STMPE I/O Expanders.
>=20
> [l.fu@pengutronix.de: fix set direction input]
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>  drivers/gpio/Kconfig      |    7 +
>  drivers/gpio/Makefile     |    1 +
>  drivers/gpio/stmpe-gpio.c |  390 +++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 398 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/stmpe-gpio.c

Any reason, that you didn't merge the patch
5ae4340192350e56dddd7537be26d1f8e57829e6 gpio/stmpe-gpio: set GPIO alternat=
e function while requesting
https://patchwork.kernel.org/patch/107835/?

Otherwise:
Acked-by: Luotao Fu <l.fu@pengutronix.de>

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwsiiQACgkQkLuxfMCkDTb9iwCfUQuj4Fp4iSKqXMu8MoHPv+fU
ZhgAnAzJ2Eiyx+Tha2q5ptLOwl2Ok5vn
=5C4/
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
