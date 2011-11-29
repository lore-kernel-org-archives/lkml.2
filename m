Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1K2DWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:22:19 -0500
Received: from imr4.ericy.com ([198.24.6.9]:38216 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1K2DWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:22:18 -0500
Date: Mon, 28 Nov 2011 19:20:36 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.2
Message-ID: <20111129032036.GA14086@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.2 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

No functional changes; cleanup only.

Thanks,
Guenter

------

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Axel Lin (1):
      hwmon: convert drivers/hwmon/* to use module_platform_driver()

Lars-Peter Clausen (1):
      hwmon: Remove redundant spi driver bus initialization

 drivers/hwmon/ad7314.c             |    1 -
 drivers/hwmon/ads7871.c            |    1 -
 drivers/hwmon/exynos4_tmu.c        |   12 +-----------
 drivers/hwmon/gpio-fan.c           |   13 +------------
 drivers/hwmon/jz4740-hwmon.c       |   12 +-----------
 drivers/hwmon/ntc_thermistor.c     |   14 +-------------
 drivers/hwmon/s3c-hwmon.c          |   13 +------------
 drivers/hwmon/sch5627.c            |   13 +------------
 drivers/hwmon/sch5636.c            |   13 +------------
 drivers/hwmon/twl4030-madc-hwmon.c |   14 +-------------
 drivers/hwmon/ultra45_env.c        |   13 +------------
 drivers/hwmon/wm831x-hwmon.c       |   12 +-----------
 drivers/hwmon/wm8350-hwmon.c       |   12 +-----------
 13 files changed, 11 insertions(+), 132 deletions(-)

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO1E+EAAoJEMsfJm/On5mBS+QP/3ygM38PihQartSA9/6KRh6h
hbkO+2xQcARHJjq6yg6PbgeIi+Q8NhvLnb/XkyzvmhfigPdsxXYUZMCORVTRhYXo
dySxp3SAL+a+2mZ7LJ+GImB4i6dxu9K0x/+pQAycghb3MXNuW4rNkLewx+ptRbR8
9cl515/zKwt8CrtXp9z7LFDW6PGTdrkJwmkbvxx2mMr488D+ThkUwgMW9jB3QtP2
DGtE65f1G73/YeRgE+mI6UkCjCOXgyZ8x9mO8+X+L4YnSG7l8Ij73WSzMWhS4Zqw
oe1j9NsT+SflPIetp6htPCe6nl5+ckIVjluQl9zxBqVkG7RbBl9ZbZOaabk2/Hk+
GHCMikEu28Uo65DrLH4tHh5wh/2lukj6ZjTc2gNCtd/z6wwfE0KQg/kwzihOgg3d
mqn4Ot4Qn8Vqv4YttqQbiHOhK33eQ6NWJaTXzlKs8QMaGC+uldP/szfW/zFd/4Pu
zCktKrDvKeAemJcjcE2u3Vysc912zHqPjAtQg5bP9VnpV+1Cola7JzYk1XJN8JQa
yFtgxiPI3i3b8f9/+nxH17Gizrt7nO/vWh71D+QzVA9Qez230DWC9GNJ8bAlqLZx
K0st4g9lWil38Fa+ngcdiqSmYOccubAgrNjteWs0T0e86LlTNUffYOa3PAmkV+ly
xJh9C6OpzhS0v4/XxbdJ
=IGIQ
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
