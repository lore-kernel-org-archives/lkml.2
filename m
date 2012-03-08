Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2CHLBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:01:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42042 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab2CHLBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:01:50 -0500
Date: Thu, 8 Mar 2012 11:01:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
Message-ID: <20120308110148.GE3638@opensource.wolfsonmicro.com>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
 <20120307173157.GT3107@opensource.wolfsonmicro.com>
 <CACRpkdaEHOGA2XfW1SMJodyf9oTNRF7kk9ErQeSpBv_2TFj=Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
Content-Disposition: inline
In-Reply-To: <CACRpkdaEHOGA2XfW1SMJodyf9oTNRF7kk9ErQeSpBv_2TFj=Rg@mail.gmail.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 08, 2012 at 07:24:39AM +0100, Linus Walleij wrote:

> > but note that this is a new gpiolib feature in -next and will need to
> > either be applied via Grant's tree or wait until after the merge window.

> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> I'd ask Grant to take this into the GPIO tree if Broonie can ACK it.

You're looking for Wolfram or Ben there, I don't really do much I2C
stuff.

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWJGTAAoJEBus8iNuMP3dzdEP/3/TRSUQLzd/yNH3cCHqs/jr
PCc/I/k4v5Oacax7z1WuFjTQo0u5pWvSrz2dg/84Evu4jbzd4vSEdzA9FXC2eCA5
q9fWQLgeTu2OeryiVID6xuDDVh3N1F8SCH/Txq3X1ewsLH1CFeAYj2+9d84g/gZA
qgohVC/f01SfDz0BCLQ3aQlng7MAEi9akIn2HT/5h1NQiUAKLpBLia5QCdBd3BKR
HaP/OE0SnE4y+UgaZwbEuoMODwSMPbi0W2X3Gxckb1d5FCjrKWeI3s6bXcLz6vvj
AhTGI3ic4VUM8Z1exJSTx0THA2n1qObsrhvuF19DLX3bkZsz2qH0rT648n/dCYmB
1x7EoAeOOPmpSvH6QXfunt+11i/W//PNSmKLOqG8Q9QV/UqeXW6uqgoJ7vfYYSq/
p7aCXo2GORGnrOtIcIQHR8FDxwA5cqHdNA3R65N8R+0snw8XJK7UQ5gixUWrNEyZ
5j8I687sfEYvzoinsC9FKfWP1LDH+UtUvf6hho+wA89GF66A2iUo5CYmBnEZyVXI
QGiXS9+sBsqKBuirNUpDxIpiJBsUFozaW5A6xoxH0cwhEaAMjEwvZCon1rTMZQC6
URqW36JPtAj82eyS4RuWRe2OGYkGgn6vvBtFkfFU3hT4kEinE2G4PDZ0pwm/E2CB
UzeVy2JylnjTOyYkT8S8
=yQvj
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--
