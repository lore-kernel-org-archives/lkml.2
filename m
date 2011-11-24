Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1KXPg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 10:36:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48134 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1KXPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 10:36:57 -0500
Message-ID: <4ECE648F.1040102@pengutronix.de>
Date: Thu, 24 Nov 2011 16:36:47 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org
Subject: Re: [PATCH 11/11] can: Remove redundant spi driver bus initialization
References: <1322148561-25138-1-git-send-email-lars@metafoo.de> <1322148561-25138-11-git-send-email-lars@metafoo.de>
In-Reply-To: <1322148561-25138-11-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5AD738D33101858136AC04B6"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5AD738D33101858136AC04B6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/24/2011 04:29 PM, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field =
of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_regis=
ter(),
> so we can drop the manual assignment.
>=20
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver =3D {
> 	.driver =3D {
> -		.bus =3D &spi_bus_type,
> 	},
> };
> // </smpl>
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: linux-can@vger.kernel.org

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/mcp251x.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
> index 330140e..5e10da5 100644
> --- a/drivers/net/can/mcp251x.c
> +++ b/drivers/net/can/mcp251x.c
> @@ -1185,7 +1185,6 @@ MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
>  static struct spi_driver mcp251x_can_driver =3D {
>  	.driver =3D {
>  		.name =3D DEVICE_NAME,
> -		.bus =3D &spi_bus_type,
>  		.owner =3D THIS_MODULE,
>  	},
> =20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig5AD738D33101858136AC04B6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7OZJYACgkQjTAFq1RaXHMIwgCeKQJcFGAOfI51dGK/kUjVR913
1s8AnAvS4Wjimv+a06fc92kNhWAh+Oo5
=vtQM
-----END PGP SIGNATURE-----

--------------enig5AD738D33101858136AC04B6--
