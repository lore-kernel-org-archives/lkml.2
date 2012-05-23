Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab2EWJ7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:59:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933046Ab2EWJ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:59:53 -0400
Date: Wed, 23 May 2012 10:59:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap fix for 3.5
Message-ID: <20120523095950.GE4085@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+ts6NCQ4mrNQIV8p"
Content-Disposition: inline
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+ts6NCQ4mrNQIV8p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit c948ef3ae71c18c1079333b65d6887ceb4577618:

  mfd: palmas PMIC device support Kconfig (2012-05-18 16:54:48 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-domain-deps

for you to fetch changes up to 18d5eacb52291faaa430fc50b435b3bb204dba88:

  regmap: Use select .. if to get IRQ_DOMAIN enabled (2012-05-23 10:15:51 +0100)

----------------------------------------------------------------
regmap: Fix the dependency on IRQ_DOMAIN for REGMAP_IRQ in the core

Fixes a missing select from the Palmas driver a bit more throoughly.

----------------------------------------------------------------
Mark Brown (1):
      regmap: Use select .. if to get IRQ_DOMAIN enabled

 drivers/base/regmap/Kconfig |    1 +
 drivers/mfd/Kconfig         |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

--+ts6NCQ4mrNQIV8p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvLUPAAoJEBus8iNuMP3ddf4P/Ar+5FVWQHOKjKmwRec7lkBC
24+fIoci3PdKvyedmWQykzXjq7dQlwy2pjb+/aoyjcjA76rx0EQs1uJXjrmV1Dp+
29WWxOhOiuoMfyhyvG8taRtnfpZaMTf1y3pO59zFhcfO+dn/vToH0q+1QW1tICWt
hMjtKOObrZzrP8DDDYXyR1+o9kawrLg+gKXm2NcxTwGy4pDaAygZiKQ+3KYpgaeC
vW4xDQtx7ErvJzD0PvSzer16gK+DLSTrzDReM0CFHWSFvwuWJqNfBCY7Zn8ZkkWt
j4H+LtLf1sdCl6gp9tk83ApRvnNnnT50YU3EzjbD+F2JH6XBt1iigSjzWCDraQAa
K6He/RrTRHK8xj5SoWU8QbuilurncVmwsDlgbK576jLKgi2UiX/V2yQ8yBZMpUJ9
MkormvcLJugBi0WLMO0Bz0RtsS9G5safCI3TYWFU0VC53CwDN4bWJZgK/ZAvBLmr
Lnm6UZZISYS3mIYML4CWbzTlXzKFl8R60dr4ICDXnQwGUJRh+/kLyzN5kbfJuAdD
6Vdi6h+emVyTxBlggBNkor9TgoCs/6WnPymlSnlokm66Hza5eZ4g7K0uX9xF4HUf
gLfj5ZU6CbHfgVDxGLtZlDQT96+oZw3Bk29LEqTTJVskBh1DInSsYNLWU39D/zB7
1HOwOCBJ+GnXKBnBTVOX
=IrNj
-----END PGP SIGNATURE-----

--+ts6NCQ4mrNQIV8p--
