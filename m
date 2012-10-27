Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab2J0VfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:35:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38684 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab2J0VfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:35:11 -0400
Date: Sat, 27 Oct 2012 22:35:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
Message-ID: <20121027213502.GE4564@opensource.wolfsonmicro.com>
References: <20120925085559.GL28670@sortiz-mobl>
 <201210251802.42349.poeschel@lemonage.de>
 <20121025160651.GO18814@opensource.wolfsonmicro.com>
 <201210261116.01507.poeschel@lemonage.de>
 <CACRpkdbwgjfyggEdNXJ=gdjBegU3GghuzEORC07fq0yTzJYbJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="idY8LE8SD6/8DnRI"
Content-Disposition: inline
In-Reply-To: <CACRpkdbwgjfyggEdNXJ=gdjBegU3GghuzEORC07fq0yTzJYbJA@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--idY8LE8SD6/8DnRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 27, 2012 at 06:14:16PM +0200, Linus Walleij wrote:

> I think you've done an honest effort (more than most would do for sure)
> to explore the ways of the regmap. If it doesn't fit, it doesn't fit and
> that's it.

The bus stuff is needed by a bunch of other drivers - there's a similar
thing with SI476x for example.  We should have support for providing I/O
functions as part of the regmap config for drivers that don't need the
data formatting down into a byte stream.

--idY8LE8SD6/8DnRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFL+AAoJELSic+t+oim91PQP/3SjLc6mhAUon6Gane5fafuo
Bxd8oVfMucrJE4ufd0IzaFLtq1EpjuYT5pQ0b9z4m6osPl02EMUxFSuGc2+y2bTR
vyZu2SW7iP+64rtIUdVVZDQ3lrCgUZbtohfClLegrjja85/fm0kNAjhXnkesU2Mg
6ShXDzV7n1qkOt3P90GyTkqhFy7mtKqaafztmwShlyxGMAsX6fU73g621aeCNVj7
ySgDC6BGujkwlME9GfiyDnjC1hcAvPzljp7QtlPVuOoM5nBbUbTvrpDAduwpR5b4
bdQyg3zrr4WLQYp1U0RU1BOsX51OgOLZN1Ib+LPOxB8JudxX2AafIcwQlpryTMwE
/Kx8FhxdeKRPjIWIEmCqUof+uxnmxxvNdrIjES2P0v2lalu5wvhETSPSrbDWryHQ
Of1qhX0sB+61IBb9zbVmnXhVuIMII+2SUncww+LYkh05TNBmN/71cF44EzLXopgD
XyyO2Yy7FAzLsI++Ppus9gMwcaxKMvbgutGsmxFw7hyTGU0CTUmdNCXaL87xtmcq
Oxyf5coP7697r1qcrw1snqKBbLfHKaess6/wclkmoqXzVyqbYBVseI1RMMkbkQCB
uplYnMQDM0oAmkzRIdVGcXgXykLs3WNOMrjSBC9X1ECPDBqsAq+tR8VPs+TUrZyR
GGrrz66mhP0X0+Ywr8wZ
=NELf
-----END PGP SIGNATURE-----

--idY8LE8SD6/8DnRI--
