Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161432Ab2GLRUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:20:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51183 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161288Ab2GLRUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:20:02 -0400
Date: Thu, 12 Jul 2012 18:20:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix a typo in regulator_mode_to_status() core
 function.
Message-ID: <20120712172000.GM7256@opensource.wolfsonmicro.com>
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
 <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
 <20120711132655.GG3938@opensource.wolfsonmicro.com>
 <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
 <201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
 <20120711174257.GN3938@opensource.wolfsonmicro.com>
 <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8tUgZ4IE8L4vmMyh"
Content-Disposition: inline
In-Reply-To: <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8tUgZ4IE8L4vmMyh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 12, 2012 at 11:50:38AM +0100, Krystian Garbaciak wrote:
> Case REGULATOR_STATUS_STANDBY -> REGULATOR_MODE_STANDBY.

Gah, actually this was due to git am applying your two patches in the
wrong order - applied now, thanks.

--8tUgZ4IE8L4vmMyh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/wczAAoJEBus8iNuMP3dKxsP/jkf6LyuvhZ8XC+ZzWYpajHr
X486Z8AwNN6kdZlrnB4WnuUJ9E8PE+FZnWNV/oz7FMLKZHFgJz5lehOGEeHBWtNM
xHKi0XIfgS+7HF3BBl6rCCtHDYu4ztpAwH5aY+1XwDMTpSGQjfevZHSxLp10e0+3
C9kQq+uxxJZKxk5iqxIvGnDaN8y3NvPxeEk8MkwUDilWKDG9RExKJx6W+QVphZwU
HksXST798ruNMjzxUVxJD9JvBKgqqdQ9i+Wiar2kNJ6csv8moiBwJmtNQnL9WJwt
1EbiD/wk+gMFTgoreQUoC+92vxPhKeX1FTBjVlJO42vBCEgcTMaUMZftzalp5cVi
VHyD4QIv5XkyllRGT5H4Y5mfaOrzPbKg2y+sdjN7BQUKXTLg1BdEoYc6umXOclpu
Xi8ngGCr3hAJPxuFgwVpJ3k56oZ8HCNwFop3T0jYITVL4CDLA2d/PiJnrKCOAEoB
ro8GwKaYH2VMGarcQI+5pCeEOT8T8T8S1Olp9NVq3ELaxVj/xocbVCKUxW59c6Qb
i2LjHuBKS/RDW6BhArrgk6IjwUzH7GqQiC+zIsHnanif/Up3iflAM1UwonomU6Pl
r3G9rDzYgYJ3ImMVJ265TFpXrQVJ+jhYM8haLgT8BwViJlBeJdKA0w96j0HajtTm
ETM6xokH2gLoC1QjJa+2
=SGW2
-----END PGP SIGNATURE-----

--8tUgZ4IE8L4vmMyh--
