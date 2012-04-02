Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2DBWPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:15:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55537 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2DBWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:15:53 -0400
Date: Mon, 2 Apr 2012 23:15:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: Set list_voltage callback for max8925
Message-ID: <20120402221549.GJ3160@opensource.wolfsonmicro.com>
References: <1333329268.8048.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OX7PPUk8qMPP4++R"
Content-Disposition: inline
In-Reply-To: <1333329268.8048.1.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OX7PPUk8qMPP4++R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 09:14:28AM +0800, Axel Lin wrote:
> Current code implements max8925_list_voltage but does not set the list_voltage
> callback function in max8925_regulator_[ldo|sdv]_ops. Fix it.

Applied both, thanks.

--OX7PPUk8qMPP4++R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeiUPAAoJEBus8iNuMP3dUycP/RSV5OZxw8Z6f63a83cugqtN
Jj8dfCTBMlXCQSdKtXcVcGAmJmsLG7ce9rdYyrbJa/9xO721VUyJ+5zaktEknp14
+dRTqwQ6PRMmcgJZY/W6aHYwPKm++RgN/p13THC5zDRRsO92jPahSCvP+lSbuWQl
ZxeYLYu9tc9HO7eqW0q8KUdefV7gni/GsxSFyTDC+ZhlIfTeZQ7LjonxIbFQi61J
9bwAmJnis2ij6qVKFBD7RM4jntKFCDXK17BHZFNahlxVoBqoPu62XexxAAR2g3Zc
3hlfKSIt4FuI+yfidFw6kCScbU/ZDrZaaZoY7jiMiU2xrpjuC4vRQYD4bh5BBL2y
xjX3zJjLtuo6plhtsZhVzj19uKPkaPzrZfJva+jo8SuvZsK6E8vBXmsJO8KcrcU1
1TiSj86okgxyophLeixY+2Z9EdLn8TOe5l/4jqbVizJ3/ctF5uNa7geM+jm0hX49
qPGyVxQSqtc3pvAZJt+CjYVjmBxP0vo3HiZndzFPKXzvPXn/2m5Jcq20GAMbEm7X
Lj3HAGqhH26aGQrDm0LizbXs9tNCbc48Si3whWt7cb2bTkiAD/S/ytYKwsnu3XZo
qS2Q8bGiaESbdfhMo+gl5AOZH0rmSCbdslTVL9xqMwybcSAYjlGmKucWfmX8Cxim
7ZsOV70vsM5rqOpUCnMf
=MeHG
-----END PGP SIGNATURE-----

--OX7PPUk8qMPP4++R--
