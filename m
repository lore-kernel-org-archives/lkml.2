Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2AXUtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:49:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56365 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741Ab2AXUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:49:18 -0500
Date: Tue, 24 Jan 2012 20:49:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] regulator: mc13xxx-regulator-core: Fix the build when
 driver is selected as module
Message-ID: <20120124204907.GF1135@opensource.wolfsonmicro.com>
References: <1327437436-10937-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o0ZfoUVt4BxPQnbU"
Content-Disposition: inline
In-Reply-To: <1327437436-10937-1-git-send-email-fabio.estevam@freescale.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o0ZfoUVt4BxPQnbU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 24, 2012 at 06:37:16PM -0200, Fabio Estevam wrote:
> Fix the following build error when mc138xxx driver is built as module:
>=20
> ERROR: "mc13xxx_parse_regulators_dt" [drivers/regulator/mc13892-regulator=
=2Eko] undefined!
> ERROR: "mc13xxx_get_num_regulators_dt" [drivers/regulator/mc13892-regulat=
or.ko] undefined!

Applied, thanks for the quick response.

--o0ZfoUVt4BxPQnbU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBAgAGBQJPHxk8AAoJEBus8iNuMP3dYgAP9RuIJ00aNLkjq7ApRhUMX2vU
8QlVQ/oMT+nC8Z+jnFh2z1o6WzLLneZKJ340vI9+pf0huk0BRDutJZPzHRdhYPbN
1OqHkE6+jJ9tDTZ6Xtm+WDXk206AWML2m9VXCapFZ9hrpuKlXNokvcwDTs6g8tcz
vbhB66lYIz8Aa6DZJTexFzaqZ7rFNMQaM5+HKANOE2/SSvEdXm7fOb9XkMlJx1mR
H1lDpa6by7bx+wtHM2xNMd/W7IOZRMmnrpUVUycZZrJi0shXk6Wv54642wpBoZSA
yDdkgYcYluVv/SwZGdtnBxp/FBYVZ7dsfDKu5Ro3+M4vjrL85+oCE6EMKXzNnX6D
5yoYezT3ldAvAzlqYkzR2D8hWZ1N/GU84S3G+5MNvwSVjmfeZpBlKazVfEt7EwCt
dWTuJQS376dGk5HWgZIFx0TFJJu/R4qoSp+3//jHas13Iy4CRKZaQ8uKGr2B9qy9
EjZGCu51fnbp7363lmT/4HoL4lxf5AcZHEaUMQzK7Jddx4LEgJkrNPdDvyWyMCJM
xidjrXgzK7SGxJKEMOQrt4hI2RtyDyxjCiuxXf401ZQPKWUlF40hDFMRAZCWHn4w
vzje84p/tdEtrOvXEYVU5RRkOU8rAT1XeJ87FZd4/mb9RhMwCX6PLS5IRp7/9qoL
xCihZRAPFDQoMLLXzGY=
=T+jg
-----END PGP SIGNATURE-----

--o0ZfoUVt4BxPQnbU--
