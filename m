Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2K1RJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:09:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49391 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2K1RJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:09:14 -0500
Date: Wed, 28 Nov 2012 18:09:07 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Sander van Ginkel <sander@van-ginkel.eu>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
Message-ID: <20121128170907.GC4659@pengutronix.de>
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
 <20121128150851.GA4659@pengutronix.de>
 <20121128171039.14705ltphptrp5kv@62.129.139.42>
 <20121128162452.GB4659@pengutronix.de>
 <50B63F81.4050008@van-ginkel.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <50B63F81.4050008@van-ginkel.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(adding the i2c list)

On Wed, Nov 28, 2012 at 05:44:49PM +0100, Sander van Ginkel wrote:
> tested with:
> CONFIG_I2C_MXS=3Dm
> CONFIG_I2C_MXS=3Dy
>=20
> in combination with CONFIG_GPIO_MXS enabled and disabled
>=20
> used kernels: 3.6 and 3.7.0-rc6
>=20
> My I2C slave is a PCF8575 i/o expander with some LEDs at the output.
> These are controlled through sysfs.

Thanks, this is useful info.

> Just tested with "i2cdetc -y -r 0" that crashes with  "BUG: soft
> lockup - CPU#0 stuck for 22s!"
> according to the docs (IMX23RM.pdf) the interrupts for I2C are 26
> and 27 that why I assigned these two in the dts.

You might want to try my for-next branch or wait for 3.8-rc1, maybe the
DMA termination patch helps? Also enabling I2C debug messages is
probably worth it.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlC2RTMACgkQD27XaX1/VRtxTACgv1z/CqT/4WUjBIFDeUPf7fW1
qWAAn2l0i4BWFkgrhYy/axsFFo5Diyz4
=wc2H
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
