Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899Ab0EZXwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:52:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34487 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933697Ab0EZXwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:52:49 -0400
Date: Thu, 27 May 2010 01:52:46 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Robert Emanuele <rob@emanuele.us>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Controlling Driver Load Order
Message-ID: <20100526235246.GA31068@pengutronix.de>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com> <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2010 at 11:04:01PM +0200, Linus Walleij wrote:
> 2010/5/26 Robert Emanuele <rob@emanuele.us>:
>=20
> > On my at91sam9g45 platform I need my i2c drivers to load before the
> > framebuffer driver. =A0The i2c drivers control a power management IC
> > which is needed to enable the graphics controller.
> >
> > Is there a way to set up that order?
>=20
> The usual trick (which you can find in a lot of other I2C busses) is to u=
se
> a core_initcall() instead of module_init().

Correct, but it's subsys_initcall().

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv9tE4ACgkQD27XaX1/VRsuwgCgtuBO/G43yUxbTED+MdBf6tUv
9hYAn0WL0L475IYsXqiOlUMzGmdrAcr7
=KcVU
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
