Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1K2KTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:19:23 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33351 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab1K2KTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:19:20 -0500
Subject: Re: [PATCH 09/11] video: Remove redundant spi driver bus
 initialization
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <1322148561-25138-9-git-send-email-lars@metafoo.de>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
	 <1322148561-25138-9-git-send-email-lars@metafoo.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iZQzh1wzB1frnepnjzrw"
Date: Tue, 29 Nov 2011 12:19:14 +0200
Message-ID: <1322561954.1869.44.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iZQzh1wzB1frnepnjzrw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-11-24 at 16:29 +0100, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field of=
 an
> spi_driver to spi_bus_type. These days this is done in spi_driver_registe=
r(),
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
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-omap@vger.kernel.org

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi


--=-iZQzh1wzB1frnepnjzrw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO1LGiAAoJEPo9qoy8lh71JNoP/1a7hTOHWDHBm6YRo+vrSUEl
ct2ULN8iXn85Ry/R9Cvjab5c6/j1uMxWii90UlCA32JYwNeGtv9K1QbW09LEFRsC
ucRZEvETbHk5RXyRWnZIQlzmbSa/czlmn4lPnH+T5ZpBIrtq9H3JJmzUKmhUwkbm
FXfOtKmiRP0ZcHtxYehYJw8PO1AeOgl9yLlErqofalnbfOWmXiNOHyNx33avvy8Q
eK+zUCggZPvuNYiLLTAEQ/uOw236t/hcARy76LoCOYT8mVnz3gcLC2f6eGIIrQJB
lKuNV7PQaAJfukj1tXIbTf5xNhSwjmXdsYqn70uqZairvXi7JtT45rK0tD+9562z
QvxHv6r/cHYW6IYs93waRpo92jiPRMl0cvXUIzIac/ud8Br/S9+YrrNQV0BtYtVW
ixj1Unx4bz/Waobxjwt529FZXMMBnSu2evtP4NKiBXDosRvNXNDi8prCx8g3F12V
6m/Zfr9ScgWvZ8AX47vNQs/eNnVM9oSUGCrqPM/hXuOlYJezwBMoVW78P02Tf8Un
dlcuZYdelMCz403Nw8wVoTM5vIcZFrJ+VY/Quz32Aem2efPl8epfLQopCOSpnzKn
ohgR0kihhjgCL9cnQYM2Ya7hdHeFiMpt1/g/+RWTy40oKH2MEDB+sVrDxt/rJ3qt
ogp91Pi01yqlMRGB1WjM
=oJgf
-----END PGP SIGNATURE-----

--=-iZQzh1wzB1frnepnjzrw--

