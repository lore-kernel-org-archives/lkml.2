Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2K1QY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:24:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33038 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2K1QY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:24:56 -0500
Date: Wed, 28 Nov 2012 17:24:52 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: sander van ginkel <sander@van-ginkel.eu>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
Message-ID: <20121128162452.GB4659@pengutronix.de>
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
 <20121128150851.GA4659@pengutronix.de>
 <20121128171039.14705ltphptrp5kv@62.129.139.42>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <20121128171039.14705ltphptrp5kv@62.129.139.42>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I've tested it with multiple configs.

Please specify a bit more what you tested and what configs mean. It is
especially important to talk to slaves since this is where DMA problems
occured.

> i2cdetect -l gives me:
> i2c-0   i2c             MXS I2C adapter                         I2C adapt=
er

'i2cdetect -r ...' would be more interesting to see communication with
slaves happening :) Also, what kernel did you test?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlC2OtQACgkQD27XaX1/VRuIdQCgygXbDIiJ6u/mYnX4EjiA/orW
fgAAoL6hanf2sttqR2y79+GRTzzlk/z9
=8GWQ
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
