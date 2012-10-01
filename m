Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2JAT77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:59:59 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61272 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2JAT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:59:57 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Oct 2012 13:00:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.7
Message-ID: <20121001200033.GA32733@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.7 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 592758b12f2e327bb5902dabd3d36b2e86049871:

  hwmon: (mcp3021) Add MCP3221 support (2012-09-23 21:08:36 -0700)

----------------------------------------------------------------
New drivers for: MCP3221, ADT7410, MAX197
Chip support added to existing drivers: LM71, LM74, MAX1110, MAX1112, MAX1113,
INA220, INA230, MCP3221
Cleanup: Use devm_ functions, fixed build warnings, removed deprecated sysfs
attributes, code simplifications, dropped dependencies on EXPERIMENTAL

----------------------------------------------------------------
Christophe Leroy (2):
      hwmon: (lm70) Allow 4wire SPI bus with LM70
      hwmon: (lm70) Add support for LM71 and LM74

Dan Carpenter (1):
      hwmon: (adt7410) handle errors from adt7410_update_device()

Guenter Roeck (54):
      hwmon: (f71882fg) Fix build warning
      hwmon: (sch56xx-common) Fix build warnings
      hwmon: (abituguru) Convert to use devm_ functions
      hwmon: (abituguru3) Convert to use devm_ functions
      hwmon: (ad7314) Convert to use devm_ functions
      hwmon: (ad7414) Convert to use devm_ functions
      hwmon: (ad7418) Convert to use devm_ functions
      hwmon: (adcxx) Convert to use devm_ functions
      hwmon: (adm1029) Convert to use devm_ functions
      hwmon: (ads1015) Convert to use devm_ functions
      hwmon: (ads7828) Convert to use devm_ functions
      hwmon: (ads7871) Convert to use devm_ functions
      hwmon: (adt7411) Convert to use devm_ functions
      hwmon: (adt7462) Convert to use devm_ functions
      hwmon: (adt7470) Convert to use devm_ functions
      hwmon: (amc6821) Convert to use devm_ functions
      hwmon: (asb100) Convert to use devm_ functions
      hwmon: (dme1737) Convert to use devm_ functions
      hwmon: (ds620) Convert to use devm_ functions
      hwmon: (emc1403) Convert to use devm_ functions
      hwmon: (emc2103) Convert to use devm_ functions
      hwmon: (f71882fg) Convert to use devm_ functions
      hwmon: (f75375s) Convert to use devm_ functions
      hwmon: (g760a) Convert to use devm_ functions
      hwmon: (lm70) Convert to use devm_ functions
      hwmon: (lm95241) Convert to use devm_ functions
      hwmon: (lm95245) Convert to use devm_ functions
      hwmon: (max1668) Convert to use devm_ functions
      hwmon: (ltc4151) Convert to use devm_ functions
      hwmon: (ltc4215) Convert to use devm_ functions
      hwmon: (ltc4245) Convert to use devm_ functions
      hwmon: (mcp3021) Convert to use devm_ functions
      hwmon: (sch5627) Convert to use devm_ functions
      hwmon: (sch5636) Convert to use devm_ functions
      hwmon: (sht15) Convert to use devm_ functions
      hwmon: (sht21) Convert to use devm_ functions
      hwmon: (vt8231) Convert to use devm_ functions
      hwmon: (w83l786ng) Convert to use devm_ functions
      hwmon: (jz4740-hwmon) Convert to use devm_ functions
      hwmon: (via-cputemp) Convert to use devm_ functions
      hwmon: (fam15h_power) Convert to use devm_ functions
      hwmon: (adm9240) Remove legacy chassis intrusion detection sysfs attribute
      hwmon: (w83792d) Remove legacy chassis intrusion detection attributes
      hwmon: (w83793) Remove legacy chassis intrusion detection sysfs attributes
      hwmon: (Documentation) Update feature-removal-schedule.txt
      hwmon: (max1111) Add support for MAX1110, MAX1112, and MAX1113
      hwmon: (ina2xx) Use structure array to distinguish chip types
      hwmon: (ina2xx) Add support for INA220 and INA230
      hwmon: (it87) Fix Kconfig for IT87 driver
      hwmon: Drop dependencies on EXPERIMENTAL
      hwmon: (adcxx) Simplify show_name function
      hwmon: (lm70) Simplify show_name function
      hwmon: (lm93) Drop unnecessary compare statement
      hwmon: (w83791d) Drop unnecessary compare statements

Hartmut Knaack (1):
      hwmon: Driver for ADT7410

Peter Senna Tschudin (1):
      hwmon: (asus_atk0110) Remove useless kfree

Sven Schuchmann (2):
      hwmon: (mcp3021) Prepare MCP3021 driver to support other chips
      hwmon: (mcp3021) Add MCP3221 support

Vivien Didelot (3):
      hwmon: add Maxim MAX197 support
      hwmon: (sht15) remove multiple driver registration
      hwmon: (sht15) move header to linux/platform_data/

 Documentation/feature-removal-schedule.txt |   10 -
 Documentation/hwmon/adt7410                |   51 +++
 Documentation/hwmon/ina2xx                 |   18 ++
 Documentation/hwmon/lm70                   |   12 +-
 Documentation/hwmon/max197                 |   60 ++++
 Documentation/hwmon/mcp3021                |   23 +-
 arch/arm/mach-pxa/stargate2.c              |    2 +-
 drivers/hwmon/Kconfig                      |  126 ++++----
 drivers/hwmon/Makefile                     |    2 +
 drivers/hwmon/abituguru.c                  |    7 +-
 drivers/hwmon/abituguru3.c                 |    6 +-
 drivers/hwmon/ad7314.c                     |   16 +-
 drivers/hwmon/ad7414.c                     |   21 +-
 drivers/hwmon/ad7418.c                     |   21 +-
 drivers/hwmon/adcxx.c                      |    9 +-
 drivers/hwmon/adm1029.c                    |   21 +-
 drivers/hwmon/adm9240.c                    |   26 --
 drivers/hwmon/ads1015.c                    |   12 +-
 drivers/hwmon/ads7828.c                    |   15 +-
 drivers/hwmon/ads7871.c                    |   21 +-
 drivers/hwmon/adt7410.c                    |  464 ++++++++++++++++++++++++++++
 drivers/hwmon/adt7411.c                    |    9 +-
 drivers/hwmon/adt7462.c                    |   15 +-
 drivers/hwmon/adt7470.c                    |   15 +-
 drivers/hwmon/amc6821.c                    |   16 +-
 drivers/hwmon/asb100.c                     |   17 +-
 drivers/hwmon/asus_atk0110.c               |    1 -
 drivers/hwmon/dme1737.c                    |   45 +--
 drivers/hwmon/ds620.c                      |   16 +-
 drivers/hwmon/emc1403.c                    |   18 +-
 drivers/hwmon/emc2103.c                    |   10 +-
 drivers/hwmon/f71882fg.c                   |   48 ++-
 drivers/hwmon/f75375s.c                    |    8 +-
 drivers/hwmon/fam15h_power.c               |   25 +-
 drivers/hwmon/g760a.c                      |   10 +-
 drivers/hwmon/ina2xx.c                     |  169 ++++------
 drivers/hwmon/jz4740-hwmon.c               |   53 +---
 drivers/hwmon/lm70.c                       |   42 ++-
 drivers/hwmon/lm93.c                       |    2 +-
 drivers/hwmon/lm95241.c                    |   15 +-
 drivers/hwmon/lm95245.c                    |   15 +-
 drivers/hwmon/ltc4151.c                    |   15 +-
 drivers/hwmon/ltc4215.c                    |   15 +-
 drivers/hwmon/ltc4245.c                    |   14 +-
 drivers/hwmon/max1111.c                    |   74 ++++-
 drivers/hwmon/max1668.c                    |    8 +-
 drivers/hwmon/max197.c                     |  349 +++++++++++++++++++++
 drivers/hwmon/mcp3021.c                    |   67 ++--
 drivers/hwmon/sch5627.c                    |    5 +-
 drivers/hwmon/sch5636.c                    |    6 +-
 drivers/hwmon/sch56xx-common.c             |   28 +-
 drivers/hwmon/sht15.c                      |  154 +++------
 drivers/hwmon/sht21.c                      |   13 +-
 drivers/hwmon/via-cputemp.c                |   23 +-
 drivers/hwmon/vt8231.c                     |   24 +-
 drivers/hwmon/w83791d.c                    |    7 +-
 drivers/hwmon/w83792d.c                    |   58 +---
 drivers/hwmon/w83793.c                     |   23 --
 drivers/hwmon/w83l786ng.c                  |   13 +-
 include/linux/platform_data/max197.h       |   21 ++
 include/linux/{ => platform_data}/sht15.h  |    1 -
 61 files changed, 1528 insertions(+), 882 deletions(-)
 create mode 100644 Documentation/hwmon/adt7410
 create mode 100644 Documentation/hwmon/max197
 create mode 100644 drivers/hwmon/adt7410.c
 create mode 100644 drivers/hwmon/max197.c
 create mode 100644 include/linux/platform_data/max197.h
 rename include/linux/{ => platform_data}/sht15.h (99%)

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQafZhAAoJEMsfJm/On5mBUoQQAKu007vBIILlpZJ1HjGGIQVD
ZygizAK6M7zbpXsyA9Pk9njJYrprA5Env1DpnIX13yBez+a5l3vxiBvbC1ZT1zYE
aLhzYiTGb1+hMXXMIMFmqb0VsbSuDy07Pr9nTiacO66lsl8abJqV2l3bDmREa9LL
2/G62iIn6U74FfAav7Cssd0T3t5XgpEzT+ix1cdb1BzmkpyYE4hdJFxYs+ct0ezH
21+hgSA1rgIXMSX4BoUuhOpulS41IbPiJe6xUppZr5H1qCMvMYW0ICgLInP0fnY6
WMaWdivHKIoE0OzE+AMYV+ftR6CMWJidhXDln4XOtUx+CuTqV9L+PSV/NnbmDrjh
Vo1KT4bCBX6mmtgw1XDPeL6dskqDAMBb/1pBhHQfRyCCAlD/J+GjSWmZyJn3PgBT
PuJlo2yb0xWjg55Gn/BwZKPmKptEBgZPxjGd5IMzrH+NBWqn6SRZzQSE3fIW0TNB
uAoAbVZqcRvTkzaMx3gJRZ0pfsRgnYW3zBGS5sJ86lVtpnY0vybkPt9jmOoQxArP
SYU/j2WpQ6awJ0Hd8pN0kc11Dc76kCoVkK5w3s4/C2/C/S227fCgfSH5Oh0QDez6
/hIbtCsxUYE6l0YrJH8CrAv3nKmnIYn9ncqJ+MlQF5ge/e+jLkAf+af8RJHIa7py
57rvPFcN+CTcMRVU3uKW
=AqTL
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
