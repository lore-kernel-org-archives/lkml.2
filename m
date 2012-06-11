Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2FKM1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:27:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44122 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2FKM1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:27:07 -0400
Date: Mon, 11 Jun 2012 14:26:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: bindings: gpio-i2c belongs to i2c not gpio
Message-ID: <20120611122648.GA4407@pengutronix.de>
References: <1334934487-19201-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1334934487-19201-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 05:08:02PM +0200, Wolfram Sang wrote:
> gpio-i2c describes an I2C controller (using gpios for data and clock),
> so it must be described in i2c, not gpio.
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  .../{gpio/gpio_i2c.txt =3D> i2c/gpio-i2c.txt}        |    0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/devicetree/bindings/{gpio/gpio_i2c.txt =3D> i2c/gpi=
o-i2c.txt} (100%)
>=20
> diff --git a/Documentation/devicetree/bindings/gpio/gpio_i2c.txt b/Docume=
ntation/devicetree/bindings/i2c/gpio-i2c.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/gpio/gpio_i2c.txt
> rename to Documentation/devicetree/bindings/i2c/gpio-i2c.txt

Any objections to me taking the patch via the i2c-tree?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/V5AgACgkQD27XaX1/VRuoogCgi/B2vC6FsJqwSQGjIz8DWlAW
BvcAoIosuyoU9b+vrdzbHtLvQBufJUmg
=5MXs
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
