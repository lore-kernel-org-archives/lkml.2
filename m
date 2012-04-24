Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2DXNBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:01:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48944 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2DXNBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:01:37 -0400
Date: Tue, 24 Apr 2012 15:01:18 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jean Delvare <khali@linux-fr.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        ben-linux@fluff.org, swarren@wwwdotorg.org, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol
 mangling
Message-ID: <20120424130118.GD4030@pengutronix.de>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
 <1335251976-31925-3-git-send-email-ldewangan@nvidia.com>
 <20120424105557.7ac07232@endymion.delvare>
 <4F967089.3050004@nvidia.com>
 <20120424143241.0d66fd2e@endymion.delvare>
 <20120424124030.GD13747@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <20120424124030.GD13747@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > * We should allocate a new functionality flag for it.
> > * We should update the documentation to reflect the two use cases.
>=20
> That sounds like a good plan.  I'll try to get round to it if nobody
> beats me to it.

Would it make sense to make all four I2C_M_* mangling features seperate
I2C_FUNC_* options? The old I2C_FUNC_PROTOCOL_MANGLING could then be all
four (seperately) exposed mangling features ORed. That's what I was
wondering when looking at the patch.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+WpB4ACgkQD27XaX1/VRsiywCeJwDI97Dx6+k0XxHuduZw3cbt
se8AmgPy9Y767S2+rssNea6vqblhRIr/
=EQLA
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
