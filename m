Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab1LGVVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:21:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43735 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab1LGVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:21:12 -0500
Date: Wed, 7 Dec 2011 22:21:09 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] spi: use gpio_request_one() instead of
 spi_gpio_alloc() helper function
Message-ID: <20111207212109.GA1314@pengutronix.de>
References: <1323071447.20963.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1323071447.20963.3.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2011 at 03:50:47PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

This will make the driver depend on GPIOLIB, currently it depends only
on GENERIC_GPIO. That needs to be addressed and made sure it won't cause
a regression for the in-kernel users.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7f2MUACgkQD27XaX1/VRtksACeJiiWx7oweAqcIeQglcvnHyLo
+7UAn1NjjAKveQSVrZxZtG1IcWzUljo9
=mSNZ
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
