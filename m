Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030654Ab2CNOJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:09:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53279 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638Ab2CNOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:09:22 -0400
Date: Wed, 14 Mar 2012 14:09:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT 1/2] regulator: Fix da9052 ldo regulator names
Message-ID: <20120314140909.GN3133@opensource.wolfsonmicro.com>
References: <1331077370.20711.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95CBLwa+io9O2zXc"
Content-Disposition: inline
In-Reply-To: <1331077370.20711.2.camel@phoenix>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--95CBLwa+io9O2zXc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 07:42:50AM +0800, Axel Lin wrote:
> The regulator name for LDOs are LDO4 ... LDO13 in current implementation.
> The correct regulator name for LDOs should be LDO1 ... LDO10.

Can you please rebase this against -next?  I was going to apply but some
of your other fixes end up conflicting with this and the second change.

--95CBLwa+io9O2zXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYKZ9AAoJEBus8iNuMP3db2oP/2c3PdFIhHZKGswFy/dSgqq0
x30TQIL6S863X7Imaup6xri/KTveJDp70Zi3BKz6f4WtAXFpq91jFqna+Vdl7Fsd
oA7YrodY9utsKh4LWiosYz0rE0Ot3hXrsGQZTVxrXjiJ7O4jhQ242unEc6c5R8aO
mP7InPDjaar9kfv6NSUixyGS3JCKsbi62uW/ML/5EoyaNREIL3asmdTOHA2+2aUs
VIl+vzsJ3VGDpt0yB1hhMwaEjZ+SQGe7iP4CoDU96Iuuncc4UCCwqh6Zikvz0YxV
iwVZ6soszHHeK+bfpGA90/Pr18ZO3XKOk98Zy09BNDuc4EMWQ3nuAg6Ik9jcYYmf
y42WoA/XOebyvHgmnFtJXoyXuZQtaZzoBSHFKD0Ssb2AuAtbScHBOabrdx6xHoZw
tU5c0mYvWKNLimtkldpm3mw87tAKdcGdsp3rAgFIxFQAqC1fAkMua3kFkIqUkctk
N8zbJmaPohhs70IBKY8ui8su3C3GD/81RLUXNkvqhsHRlzCI8z5YlRsy/xbRPQSX
8y0XLEJU3GcCmu/vRsm2K6kTMpY+q0tJNHLQl/UMgenGsZ1YiJM9sqKst4aZKEvp
xMZg3lO4kzL3yL5hmSaQxUmX0jU64ycQwoB4/3DRuJPv0jzMfqFybcXT7MDq8nc8
Qx0dgUcaVDMek6Sen6eh
=ZgJ2
-----END PGP SIGNATURE-----

--95CBLwa+io9O2zXc--
