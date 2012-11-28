Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2K1PI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:08:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34647 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab2K1PIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:08:55 -0500
Date: Wed, 28 Nov 2012 16:08:51 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: sander van ginkel <sander@van-ginkel.eu>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] add hardware I2C support for ARM IMX23
Message-ID: <20121128150851.GA4659@pengutronix.de>
References: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 28, 2012 at 03:24:03PM +0100, sander van ginkel wrote:
> The I2C hardware in the IMX233 is currently not supported,
> however the i2c-mxs driver seems to be suitable.
> To use the i2c-mxs driver it has to be added to the devicetree
> for the IMX23.

Have you tested it? There have been problems reported when using
i2cdetect...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlC2KQMACgkQD27XaX1/VRszNgCfV+P8LJKkF2Sh2MRWXeeRdxCx
tPIAmwSZqdDLAGlIBZaFNWA41j5qvmKm
=gtHV
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
