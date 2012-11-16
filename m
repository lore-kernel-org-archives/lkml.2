Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab2KPLaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 06:30:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2KPLaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 06:30:18 -0500
Date: Fri, 16 Nov 2012 12:30:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [RESEND PATCH v3 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20121116113014.GA19028@pengutronix.de>
References: <1352747326-2195-1-git-send-email-aaro.koskinen@iki.fi>
 <1352747326-2195-2-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1352747326-2195-2-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 09:08:42PM +0200, Aaro Koskinen wrote:
> Add i2c driver to enable access to devices behind CBUS on Nokia Internet
> Tablets.
>=20
> The patch also adds CBUS I2C configuration for N8x0 which is one of the
> users of this driver.
>=20
> Cc: linux-i2c@vger.kernel.org
> Acked-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Wolfram Sang <w.sang@pengutronix.de>

Mostly good, but the devicetree binding description is missing.
Please add a proper file with the same name as the driver to
Documentation/devicetree/bindings/i2c.
Also, it might make sense to rename the driver to i2c-cbus-gpio?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCmI8YACgkQD27XaX1/VRtX4QCdF84DsfMsJ9LYNWyLg7PrgTcz
0SkAn310otDcbXSGDnFFgdkor3BYk6CF
=x/v1
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
