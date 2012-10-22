Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2JVPOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:14:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60680 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab2JVPOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:14:07 -0400
Date: Mon, 22 Oct 2012 16:14:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap for for v3.7
Message-ID: <20121022151403.GM4477@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZrCu0B0FMx3UnjE2"
Content-Disposition: inline
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZrCu0B0FMx3UnjE2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-fix-mmio

for you to fetch changes up to 5784ee4dcbb896f5367855540b264e21a0c33854:

  regmap: select REGMAP if REGMAP_MMIO and REGMAP_IRQ enabled (2012-10-17 22:09:35 +0900)

----------------------------------------------------------------
regmap: Fix for dependencies for MMIO

Trivial dependency issue, not noticed before as the only user of MMIO
also needs I2C.

----------------------------------------------------------------
Dong Aisheng (1):
      regmap: select REGMAP if REGMAP_MMIO and REGMAP_IRQ enabled

 drivers/base/regmap/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--ZrCu0B0FMx3UnjE2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhWKZAAoJELSic+t+oim9KYYP/2OXCOqRWuAgu5R81VXrw3Hn
v7YXSyI75mMRX1KjHjOKrXZyHRjVPHmC6pSFrko+ujmNi1QuxYMexOyaU0uks2gl
EEuBcJSAqcycTE4LuC45+w3IJ53oHlBWeReA9xFuhEJvLUrgTt8Gn8YW3SNYDA0M
DVZK2SKaO8rMBmdmoVF85lYOXPKZUgOoGAvDlfaUi/QD4n1Em3sq24wTEHPhaaog
9fDfEIFP/F7Bf4AOtG3eYdnBzWHdKL16Y145qtBrc1UmaPtdppnQmLMAmmVWIzDo
fkoxH+FZqcrcz1/vQwXrI9Je8xFoaz5CLFsfZ+/zMDAPOvrpaPAatRf475rDc/TS
cOgZ5AKBQJ7mYdwH1Hj3LBWSbyDfiTlKpKpTIwZjiRQ7mWBkOcdXwSveQipyZYPX
daS5oE+0kRqHzwcNurOExqmAUccxfb6XoBD23+cFzskMo1Xt7r6GQv3xTcjktb4d
3nBW1+qN9BbJsD/GuSh1lNF7Tjp9j1DAYOmpam6GSPXkxbIy6fEcyE0PvgaVVsAB
x6zdRL9lrptCP0+iR15qha/+u4Jgw3w0xbt/n8Hy6l3dndD7xaIm1hv3Yva09QGM
v7pxyEMw/NTmePB+8O4KFgNI3EP9vKVHfyi7DRTCnR//yaIy1ZI5GwaNEe1KnNuB
SUMcYmlx/m54sY/bYO/D
=voJv
-----END PGP SIGNATURE-----

--ZrCu0B0FMx3UnjE2--
