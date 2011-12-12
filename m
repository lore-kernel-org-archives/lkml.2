Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1LLKqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:46:08 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:43911 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab1LLKqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:46:06 -0500
Subject: Re: [PATCH 1/2] video: omap: Staticise non-exported symbols
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Imre Deak <imre.deak@nokia.com>,
        Cory Maccarrone <darkstar6262@gmail.com>,
        Laurent Gonzalez <palmte.linux@free.fr>,
        Marek Vasut <marek.vasut@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <1323394677.3740.2.camel@phoenix>
References: <1323394677.3740.2.camel@phoenix>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lv+1MUsSdgATwwRxylBy"
Date: Mon, 12 Dec 2011 12:45:57 +0200
Message-ID: <1323686757.3852.12.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lv+1MUsSdgATwwRxylBy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-12-09 at 09:37 +0800, Axel Lin wrote:
> These symbols are not used outside it's driver so no need to
> make the symbol global.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks, applied to DSS tree.

 Tomi


--=-lv+1MUsSdgATwwRxylBy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO5dtlAAoJEPo9qoy8lh71HPgP+wdGvdbMK21qJ6LgZd7bh3gl
8bZ7+pHvnWucicdI6RLhh7HNL5I3DiVduM3zvWwLwf1Ahw0bfJYAPHjRfFeo+yIm
bvE5Q5/QhopR2erLYSyfGwW/YPRP+Ml0hXAVVk7e5dF9FTO59vTawPgSukFztQq7
2bXnIZqybcTaxo4CV/1cUGyU6nwr51aHQwkdABUDdk3CRY19YRJBjZ2vU4qNijfW
TMAVVv1L4FvHgY1hmqBNMqQ7iW2CruESfvMuNJddsZYx6Bg1YAZJNcTpFBhpD6sJ
v5+S75RglX6x9nhpUr9OcP7/GAdh9pxNOgMDv+Hx/flbl8ZZ+cJbwWeNy5EoMQUN
4rfxgiwtFR6Fqgk6CSNOtRc0DDL8pu4n5jjLH+fSUpdNHYxJdGqD5wN+WjkJ3Xkw
SDfpz7pXhLVwJjUVb/4NI3gQ+PMk/s2c2mFm7RrV3E+HlFWJ0L/x2RVZ3kzqDTDy
mM2HKK86nI3iZiYxwedBy9qrkr5+5ii2df+Hj74oGv+H1VWMXyyhOuzLZ26WKoM1
RHg79ZIocnXLaaGXRsaGtvVw2Wl904wGnZ1xnyrU22F1XUXMb17RklnnFyjdim4A
P3cgLTyw9t7iTedBzL8ZJXDUyt4xM29TmA2WeoVI+kpXovK57riR716PbBVxqp5+
giAOlL4HesGKrSFZ2fju
=Jb40
-----END PGP SIGNATURE-----

--=-lv+1MUsSdgATwwRxylBy--

