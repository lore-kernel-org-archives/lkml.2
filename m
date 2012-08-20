Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2HTT6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:58:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53697 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912Ab2HTT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:58:28 -0400
Date: Mon, 20 Aug 2012 20:58:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH v2] regulator: ab8500: provide per-regulator shift
Message-ID: <20120820195826.GQ26991@opensource.wolfsonmicro.com>
References: <1345480895-18278-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6tPipYVl+OcoAvSh"
Content-Disposition: inline
In-Reply-To: <1345480895-18278-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6tPipYVl+OcoAvSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 06:41:35PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> This encodes the voltage shifts (the number of bits to shift
> the register to get to the selector) into the regulator info.
> We have several new variants of the AB8500 so this varies a
> lot.

Applied, thanks.

--6tPipYVl+OcoAvSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMpbMAAoJEFJkBDiqVpZ4JmkQAK2/m/qU7TvrgYpFbS8dYomE
IMa+SyCmb82TecLExlSweihqMKl9jpy3zZhWjonf/oH7aHUh9jgyQqIDGPbFpcQJ
VmyE9W3fsi2dzIT2JhFcTOw19Bph9HeS6DDPQHBVJpL8vV77iVmVsC5weBkSlPZQ
Adc36wzo/9Q3dO/LgvMBz+AWikDN4CwjLXgYUGcNmt0wt2E3A4CPCr4f09E5wEVH
GJmgbw/13WMrCEt1ZaHrw+9PXvonBWO9dObKNy/TetyCmXra+XiVpHWna7hWY9Of
lQ7FjBw1Y+y2A0UUQkLpH/OoQce6lEJMk+kYnB1Zl4DM78u+aHiOnZclitppz0ES
n6TkjR9xHNH+VEhg0MNguldH3ucrJuzujIe/mFw7HfJmGjQdnbmRn/gCwwV2m0gE
tR1jm5/pglkTJo1SPlvyic1ZrtQ1BIUKPhyPb/cMaP4PjbEQ++KHBoMo+b6O4V/V
oNvusm2q/OakyAhPyU6g5EA9tGpcTP6Wya9Q4P92uukQJQ4HjCoZYA2N7vcuFixX
ZCNSfHkmibo/B7QGocIkVtTGYLd1DbLdrx/L2tQKBIkT7e83UZfeqH9Q0OqyypsV
o/JIZL0AmIeiRfkiZd7VP9hVX42ynJTatJ9lxUsVqgM0zfWjFoIy3vVo/shrkPPb
ZoHDOgoEGOvKkEWr99BJ
=tUb+
-----END PGP SIGNATURE-----

--6tPipYVl+OcoAvSh--
