Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab2EHIup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:50:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37796 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab2EHIuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:50:44 -0400
Date: Tue, 8 May 2012 09:50:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator updates for 3.4
Message-ID: <20120508085040.GD15893@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.4

for you to fetch changes up to 968c2c1707a3396ccd6e7e6c5ddaf658a6d3bd66:

  regulator: Actually free the regulator in devm_regulator_put() (2012-05-07 13:14:44 +0100)

----------------------------------------------------------------
regulator: A couple of fixes for 3.4

One small fix for an edge condition in the max8997 driver and a fix for
a surprise in the devres API which caused devm_regulator_put() to not
actually put the regulator - a nicer version of this based on an
improvement of the devres API is queued for 3.5.

----------------------------------------------------------------
Axel Lin (1):
      regulator: Fix the logic to ensure new voltage setting in valid range

Mark Brown (1):
      regulator: Actually free the regulator in devm_regulator_put()

 drivers/regulator/core.c    |    5 ++++-
 drivers/regulator/max8997.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqN5YAAoJEBus8iNuMP3dlG8P/jUmwuljhH4n7apUGWBjs5nK
IVQdec1q2eeKkaAdgWacQIiVnBAjO+n1t1Ek6PlBsJ3x+P2wEsK7y1VyOFy4H9yr
e3UEpMsUS3N0sm1BLQs6ydgj/SVdBqXdoEW+ofUEjbUS35OKPhBF7I2uK2uIpuUe
QNCRBqhLx6FslDrdVUEfsmXQqf5o8LKSQQNZRNXs3dqN9giUHl9GVUsrapzQ+avi
J+1JGPn3WpmVtW/tO8F96K+/1udYmGCmIfIycCXqnftG4ZE5vcLQpy1XG9m3t+3S
ims06lJ8jUFyLHg2safGEARVcU2As3iyzkV0V4T6S4klIC5pxfkObxyLXyK4V5xq
j+iYF+/9afxWb326WR3EyDjXTuMN6IBwmD6xEaTkUm24HWppCYURTDj6fVBS9A/6
od/ez2G2tkAanMMRVGJVu496avqp9FepTxYLJHhZqcK3hovySnFqRLQoIrxh0pRR
SqgypDfQ8+dyEk0DU+3TSPMcTg3d26T+BTskz6TptSvnv9fjX86oidsK6WcDPL6U
aYCUiu6AGO7ov8ygINDmZpII85ZItxcZ2JUs04atZ2FfLJM/G+8oXc9q3LqS1cxR
7RtaWyP25kPIHbICjwhC7aiFxo+6e8bNDWpwkD9kohB2heXv7C5zFVjsvwToH4OZ
o92y/s+6jY12yAh8R+46
=lobz
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
