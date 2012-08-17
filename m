Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2HQTFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:05:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48367 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2HQTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:05:42 -0400
Date: Fri, 17 Aug 2012 21:05:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1 v4] i2c: Add default configuration into the Nomadik
 I2C driver.
Message-ID: <20120817190537.GA32339@pengutronix.de>
References: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
 <20120808131158.GD8227@gmail.com>
 <CACRpkdb+6S5yYvVjrr2f+wubE43dzD3i=OVfWtM_U+HW_XZX1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <CACRpkdb+6S5yYvVjrr2f+wubE43dzD3i=OVfWtM_U+HW_XZX1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 05:02:32PM +0200, Linus Walleij wrote:
> On Wed, Aug 8, 2012 at 3:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
>=20
> > From: Lee Jones <lee.jones@linaro.org>
> > Date: Tue, 7 Aug 2012 12:27:24 +0100
> > Subject: [PATCH 1/1 v4] i2c/nomadik: Add default configuration into the=
 Nomadik I2C driver
>=20
> Wolfram are you taking this v4 patch into the i2c tree for the -rc:s?
>=20
> Right now this is causing boot regressions so we need it badly...

I am collecting patches for rc3 this weekend.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAulgEACgkQD27XaX1/VRtdiwCgwykB6OrBopfQzUGsTodqv31e
KpUAn0LbyJOeXP/KXVBKsqdk2f5hNRbR
=vztA
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
