Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2KNLnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:43:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57677 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab2KNLnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:43:13 -0500
Date: Wed, 14 Nov 2012 20:43:03 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Frank Li <Frank.Li@freescale.com>
Subject: Re: [PATCH 1/1] regulator: gpio-regulator: Catch 'no states
 property' misuse
Message-ID: <20121114114302.GN7407@opensource.wolfsonmicro.com>
References: <1352892888-15546-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nb8zVy0QMK3AA1xu"
Content-Disposition: inline
In-Reply-To: <1352892888-15546-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nb8zVy0QMK3AA1xu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 11:34:48AM +0000, Lee Jones wrote:
> A selection of voltage or current values (AKA states) should always
> be specified when using a GPIO regulator. If there are no switchable
> states then the fixed regulators should be used instead.

Applied, thanks.

--nb8zVy0QMK3AA1xu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo4O4AAoJELSic+t+oim9rigP/RmtHsLwEPK1AHy4huPgVVWg
f20JLlW/7rafebs5s7XAs2qR0fL1sTUo4dDH9dUVghqQ7+HNzy4O0E1/QDMjcl7z
m7IeGJSiEWXVATsv9eLRFu3GM321aMvvQeX6e2DE1yXNmDX6j/AM6b1f5CzGWotx
hZp93tDSxCbAmcRAfK27DY7E2XbhdW0KUu/O1aWBpn+YimDPQwmYc+15knicTkwd
b4zVoux5yzyAG08tnEjJYTPrMPusaW/sixeOQK0AXcWmvujI8nTrKWzaZmX3GVGL
2owsdlDqA+isRDrDUjITVlw+ic2GLNUOqKa1glcAgmVhpTzX42g+BONvCvh62WY2
7e2G69ZhJIH+QaIgMw/hsnHuRLA2G9H/s4/l5T7LIlk+zNh5sC6X67JgXphg5nX4
YySWypyYcEiyx8g10s6pyOmuKrNxVwsbH7kit/Iy/bTNnivC+I8ObE740JjSLtL9
vnsVvbu1arFwNvFZfESuMBLBS1sWeyBpaLiJ+ibu64bRcRZITkvCu5i2g5vBCKxa
sPQcvoa5rWvsJCQ9ccfDmnW5hNyEcOwRp6xn0JNnbNR9nwxyuonqa/vuh+T7Rgfz
m8oWZIeDIMqz+elnWVE9aDLNshBs2TT1U6S31AKbGI1i9MW0mmOWtEwQ5HfifLOI
wqS8SjBGtEu4A47BSix1
=dAOf
-----END PGP SIGNATURE-----

--nb8zVy0QMK3AA1xu--
