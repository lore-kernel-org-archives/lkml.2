Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2BPQMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:12:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38529 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732Ab2BPQMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:12:16 -0500
Date: Thu, 16 Feb 2012 08:12:12 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap fix for 3.3
Message-ID: <20120216161211.GA3383@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-linus

for you to fetch changes up to 61cddc57dc14a5dffa0921d9a24fd68edbb374ac:

  regmap: Fix cache defaults initialization from raw cache defaults (2012-02-15 08:31:32 -0800)

----------------------------------------------------------------
Fixes a bootstrapping issue for some registers when a less commonly used
method for register cache initialisation is used.  Only affects a fairly
small proportion of users that both don't use explicit register defaults
and do use the cache.
----------------------------------------------------------------

Lars-Peter Clausen (1):
      regmap: Fix cache defaults initialization from raw cache defaults

 drivers/base/regmap/regcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPSrUAAoJEBus8iNuMP3dG+4P/AjZrreZS60VgYva2PD9Ct61
KZDSb/bMwP5evU44mJQAg4Wwo9QZ3JWZOsLBP1I4wGmMeKT/6MXczT8MQroGJjEm
SnZem/ykWumQ+OFJeEjo6GvfiLL38cYyG8NIJbMv2ZE/7hq2Ej4Z6M2KKfnnvzbc
w3Dgx5mrNIvikSVJzAri+9/oI9EM3WjdIaMEoTt7v0kyfI5oLWGAZMvK8QZKdYyW
ZBNTNGGnYQEaFNK/+uUSpzIatIC+MObJN07BtBNmExgfLdOduTWsMBw5YntYwm7w
hDseKNFKZtHsXTDh5Nx/+GW/7xkOTq7ITGaLvwdXVaaTRsrC8kZ/DiAvEbF+7++n
PIjY2Sdq7pmJ5eCfzxyAaLAzHVqu3Y3bIhr/E10hhEx8l0gU7jEMDsYqjDE+tUKm
RZ9MwrX3WLIFI7hF7l2+qexzGvRvqW5Ppc3iywLQdUZyXOmAcie37QGTpGKx+rJG
G/1CsLmIBhPl8tNE2OO42OP//+GZi6yRWFdNE82YwUHbDHiP2LKUruqOclQII3gc
rECkaHHgk/irLveCEFbnN2sJn0Xxb6D7t3JycKhIF5NoWMfk9pEsow7LwQusTxx9
Du7tniPcyuvHXOZgpD1UjiKUibZdYgBEwM/6owmLlnM/LaTmllIfA4qxay35kfuS
TcgjiweY2glhPIGNgzuS
=LQvj
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
