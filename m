Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2HVP76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:59:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49982 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664Ab2HVP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:59:56 -0400
Date: Wed, 22 Aug 2012 16:59:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sameo@linux.intel.com, lrg@ti.com,
        richard.zhao@freescale.com, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, paul.liu@linaro.org
Subject: Re: [PATCH 4/7] regulator: anatop-regulator: convert to use
 imx-syscon to access anatop register
Message-ID: <20120822155953.GQ7995@opensource.wolfsonmicro.com>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-5-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="53AZ357FMu84hmXL"
Content-Disposition: inline
In-Reply-To: <1345619928-15446-5-git-send-email-b29396@freescale.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--53AZ357FMu84hmXL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 03:18:45PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
>=20
> Using standard imx syscon API to access anatop register.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

With the conversion to regmap it'd also be good to convert the driver to
use the regmap helper functions for enable and voltage operations if
possible.

--53AZ357FMu84hmXL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNQHiAAoJEFJkBDiqVpZ40WgP/1n6YfpTrh9CnDHO2Z4beL58
MK/dZTm+WTzzvLBbYSEWeQqoqM7DurkIovAHXF4a17Tjh5smDc/eqfVx6TiRpzfj
zumFWjA8zevXGW66yxy9VKP5bFBKFL4FOExKOsoUtRieN7cMEO19wtu999AXQeQu
EWq/OHE6Y0r8m2hbCS+XzPUiDizV7IwtypW4Q1hrTdGxtf5PksxomkC+v7GjMvss
zBHKDvQ+/rHtDKE8B9znQeBY0DJAYHIQSwNpVovwluPaapYJxaGCxPV1kNTTB3ya
j7NeCq1I8Qmvso3sVEbXMJI8TVs6jm8nnFVIjbm5/6+BSKZK80y1hbqCFymggwAX
G5GUj+Nn90v+Og5K3FlvfrOrmZ/gsl08JrVEh9/xCtp020f5lAcollqILj29noyb
JCLc2rzWl74QMg9ZNBzlLwqSllOrj2sMMTTLjLcdEhQz5MOSUaDzJa+80f7vd++y
+foBkUYCuCHjWSDEw+jmcjYJ9rTdptmT+2tBJ48SH9ccjmfIfVMXPAqjrFxFvQ7l
vAJ6K7PDA4gnoEbSETUxwLXJ8MKC63miUty/RvzBasOKK8QNFz/j1PWM/r/nzfJT
kEm4sltG07YERCtv20mC9QlF0d2QVlqHGJO1v0RaJvfP3F9eWUcigUl1z1FX9sER
yn6AC2ykf/wAyEvz0A3u
=q8hH
-----END PGP SIGNATURE-----

--53AZ357FMu84hmXL--
