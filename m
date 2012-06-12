Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2FLI5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:57:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38906 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2FLI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:57:47 -0400
Date: Tue, 12 Jun 2012 10:57:41 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C
 driver
Message-ID: <20120612085741.GD9230@pengutronix.de>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-10-git-send-email-lee.jones@linaro.org>
 <20120611190550.GK3887@pengutronix.de>
 <4FD70357.9060905@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llIrKcgUOe3dCx0c"
Content-Disposition: inline
In-Reply-To: <4FD70357.9060905@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--llIrKcgUOe3dCx0c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 12, 2012 at 09:52:39AM +0100, Lee Jones wrote:
> From: Lee Jones <lee.jones@linaro.org>
> Date: Tue, 17 Apr 2012 16:04:13 +0100
> Subject: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C dr=
iver
>=20
> Here we move the i2c-nomadik's default settings into the driver
> rather than specifying them from platform code. At the time of
> this writing we only have one user, the u8500. As new users are
> added, it is expected that they will be Device Tree compliant.
> If this is the case, we will look up their initialisation values
> by compatible entry, then apply them forthwith.
>=20
> Cc: linux-i2c@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Did you use checkpatch?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Applying: i2c: Add Device Tree support to the Nomadik I2C driver
  CHECKPATCH
WARNING: please, no space before tabs
#37: FILE: drivers/i2c/busses/i2c-nomadik.c:909:
+^I.tft            =3D 1, ^I  /* Tx FIFO threshold */$

WARNING: please, no space before tabs
#38: FILE: drivers/i2c/busses/i2c-nomadik.c:910:
+^I.rft            =3D 8, ^I  /* Rx FIFO threshold */$

WARNING: please, no space before tabs
#40: FILE: drivers/i2c/busses/i2c-nomadik.c:912:
+^I.timeout        =3D 200, ^I  /* Slave response timeout(ms) */$

ERROR: code indent should use tabs where possible
#56: FILE: drivers/i2c/busses/i2c-nomadik.c:927:
+        const struct of_device_id *of_id =3D$

WARNING: please, no spaces at the start of a line
#56: FILE: drivers/i2c/busses/i2c-nomadik.c:927:
+        const struct of_device_id *of_id =3D$

ERROR: code indent should use tabs where possible
#57: FILE: drivers/i2c/busses/i2c-nomadik.c:928:
+                        of_match_device(nmk_gpio_match, &pdev->dev);$

WARNING: please, no spaces at the start of a line
#57: FILE: drivers/i2c/busses/i2c-nomadik.c:928:
+                        of_match_device(nmk_gpio_match, &pdev->dev);$

total: 2 errors, 5 warnings, 0 checks, 59 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

Your patch has style problems, please review.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--llIrKcgUOe3dCx0c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/XBIUACgkQD27XaX1/VRtX7ACeLrWCDbmZFmbviuoP+kGCJHdT
24YAoMSHs4mWg7w62UfA8HPUsdg4eVAL
=+Sjt
-----END PGP SIGNATURE-----

--llIrKcgUOe3dCx0c--
