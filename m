Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2HRIB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:01:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53858 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2HRIBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:01:21 -0400
Date: Sat, 18 Aug 2012 10:01:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/1 v4] i2c: Add default configuration into the Nomadik
 I2C driver.
Message-ID: <20120818080110.GC24639@pengutronix.de>
References: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
 <20120808131158.GD8227@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <20120808131158.GD8227@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 02:11:59PM +0100, Lee Jones wrote:
> From: Lee Jones <lee.jones@linaro.org>
> Date: Tue, 7 Aug 2012 12:27:24 +0100
> Subject: [PATCH 1/1 v4] i2c/nomadik: Add default configuration into the N=
omadik I2C driver

Actually, unlike Linus said, I prefer "i2c: nomadik:"; minor nit,
though.

>=20
> At this moment in time there is only one known configuration for the
> Nomadik I2C driver. By not holding that configuration in the driver
> adds some unnecessary overhead in platform code. The configuration
> as already been removed from platform code, this patch checks for any

  ^^ has ( I fixed it )

> over-riding configurations. If there aren't any, the default is used.
>=20
> Cc: linux-i2c@vger.kernel.org
> Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to -current, thanks! I added a note from Linus that it is needed
because of boot regressions. That is also useful in commit messages.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvS8YACgkQD27XaX1/VRsncACgxi8CiSYzfQv0HrukPKTvi9pS
PKAAmwQel/F0zw6rpk/t/Q5mI3gwUsZY
=CYe2
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
