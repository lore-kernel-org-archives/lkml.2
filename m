Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab2CGRjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:39:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43737 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2CGRjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:39:40 -0500
Date: Wed, 7 Mar 2012 18:39:22 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
Message-ID: <20120307173922.GB1130@pengutronix.de>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
 <20120307173157.GT3107@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <20120307173157.GT3107@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2012 at 05:31:57PM +0000, Mark Brown wrote:
> On Wed, Mar 07, 2012 at 07:08:14PM +0530, Laxman Dewangan wrote:
> > The gpio core driver (gpio library) supports the open
> > drain pin handling. Therefore, it is not require it
> > to handle in the i2c-gpio driver, just require
> > to pass the OPEN_DRAIN type flag when requesting the gpio.
>=20
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Typo ;)

>=20
> but note that this is a new gpiolib feature in -next and will need to
> either be applied via Grant's tree or wait until after the merge window.

I'll pick it for v3.5 later. Thanks for the review!

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9XnUoACgkQD27XaX1/VRu0yQCgwyR3SZ5kEPkYeE0p53PHaa+I
Om8AnRgak1mDjdFhqAIaouyVEVMyc39V
=Zh2i
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
