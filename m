Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2DXN20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:28:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2DXN2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:28:25 -0400
Date: Tue, 24 Apr 2012 15:28:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, ben-linux@fluff.org,
        swarren@wwwdotorg.org, olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol
 mangling
Message-ID: <20120424132810.GE4030@pengutronix.de>
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>
 <1335251976-31925-3-git-send-email-ldewangan@nvidia.com>
 <20120424105557.7ac07232@endymion.delvare>
 <4F967089.3050004@nvidia.com>
 <20120424143241.0d66fd2e@endymion.delvare>
 <20120424124030.GD13747@opensource.wolfsonmicro.com>
 <20120424130118.GD4030@pengutronix.de>
 <20120424150750.36f8c2fc@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2qXFWqzzG3v1+95a"
Content-Disposition: inline
In-Reply-To: <20120424150750.36f8c2fc@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2qXFWqzzG3v1+95a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I think the assumption was that mangling requires full control of the
> bus lines, so a driver would either support all quirks (i2c-algo-bit)
> or none (everybody else), thus having a single functionality flag. As
> it seems I2C_M_NOSTART no longer fits the "quirky" category, having a
> separate flag for it would make sense. But I would leave the rest alone
> for the time being.

OK. We can still do what I proposed just in case the other mangling
features should ever become equally important ;)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--2qXFWqzzG3v1+95a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+WqmoACgkQD27XaX1/VRuLpQCfZ/O8piFutX04a4tw0wpzXaYA
Es4AoKiZiBoWXCd6+EWv7Aj2MpiknRRp
=TvEQ
-----END PGP SIGNATURE-----

--2qXFWqzzG3v1+95a--
