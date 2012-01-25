Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab2AYFZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:25:25 -0500
Received: from imr3.ericy.com ([198.24.6.13]:56660 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2AYFZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:25:24 -0500
Date: Tue, 24 Jan 2012 21:23:13 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.3
Message-ID: <20120125052313.GA11583@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.3 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Looks like a lot of changes, but almost all of it is cleanup, plus some
error handling improvements, MAINTAINERS updates, and a couple of
minor bug fixes.

Thanks,
Guenter

------

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Axel Lin (2):
      hwmon: convert drivers/hwmon/* to use module_i2c_driver()
      hwmon: convert drivers/hwmon/* to use module_spi_driver()

Frans Meulenbroeks (26):
      hwmon: (lm80) add error handling
      hwmon: (amc6821) fix initialisation
      hwmon: (mc13783-adc) remove space before tab
      hwmon: remove () used with return
      hwmon: use DEFINE_PCI_DEVICE_TABLE
      hwmon: (i5k_amb) fix checkpatch issues
      hwmon: (g760a) fix checkpatch issues
      hwmon: (adm1029) fix checkpatch issues
      hwmon: fix checkpatch issues
      hwmon: (wm831x-hwmon) fix checkpatch issues
      hwmon: (w83l785ts) fix checkpatch issues
      hwmon: (ad7418) fix checkpatch issues
      hwmon: (ad7414) fix checkpatch issues
      hwmon: (ibmaem) fix checkpatch issues
      hwmon: (sht15) fix checkpatch issues
      hwmon: (smm665) fix checkpatch issues
      hwmon: (adt7475) fix checkpatch issues
      hwmon: (asus_atk0110) fix checkpatch issues
      hwmon: (f71882fg) fix checkpatch issues
      hwmon: (lm70) fix checkpatch issues
      hwmon: (adt7411) fix checkpatch issues
      hwmon: (adt7470) fix checkpatch issues
      hwmon: (lm80) fix checkpatch warnings
      hwmon: (lm80) reset device if error occurred
      hwmon: (k8temp) fix checkpatch issues
      hwmon: (lm83) fix checkpatch issues

Guenter Roeck (31):
      hwmon: (pmbus) Replace strict_strtol with kstrtol
      hwmon: (max6650) Fix checkpatch issues
      hwmon: (vt8231) Fix checkpatch issues
      hwmon: (abituguru3) Fix checkpatch issues
      hwmon: (adm1025) Fix checkpatch issues
      hwmon: (adm1025) Limit data range when writing cpu0_vid
      hwmon: (w83781d) Fix checkpatch issues
      hwmon: (max6650) Fix multi-line comments
      hwmon: (f71805f) Fix multi-line comments
      hwmon: (adt7475) Fix multi-line comments
      hwmon: (vt8231) Fix multi-line comments
      hwmon: (ds1621) Fix checkpatch issues
      hwmon: (ds1621) Fix multi-line comments
      hwmon: (f71805f) Fix checkpatch issues
      hwmon: (hwmon) Fix multi-line comments
      hwmon: (hwmon-vid) Fix multi-line comments
      hwmon: (it87) Fix multi-line comments
      hwmon: (asc7621) Fix multi-line comments
      hwmon: (smm665) Fix checkpatch error
      hwmon: (wm831x-hwmon) Fix multi-line comments
      hwmon: (pc87360) Fix multi-line comments
      hwmon: (coretemp) Fix checkpatch error
      hwmon: (jc42) Fix multi-line comments
      hwmon: (ad7414) Fix multi-line comments
      hwmon: (it87) Constify fixed string arrays
      hwmon: (asus_atk0110) Fix multi-line comments
      hwmon: (applesmc) Fix multi-line comments
      hwmon: (wm8350-hwmon) Constify fixed string array
      hwmon: (ltc4245) Fix multi-line comments
      hwmon: (ltc4215) Fix multi-line comments
      MAINTAINERS: Drop maintainer for MAX1668 hwmon driver

Jean Delvare (1):
      hwmon: (f71805f) Fix clamping of temperature limits

Mark Brown (1):
      MAINTAINERS: Add hwmon entries for Wolfson

 MAINTAINERS                      |    8 +-
 drivers/hwmon/abituguru3.c       |   56 +++++---
 drivers/hwmon/ad7314.c           |   12 +--
 drivers/hwmon/ad7414.c           |   21 +--
 drivers/hwmon/ad7418.c           |   25 ++--
 drivers/hwmon/adcxx.c            |   13 +--
 drivers/hwmon/adm1021.c          |   13 +--
 drivers/hwmon/adm1025.c          |   76 ++++++----
 drivers/hwmon/adm1026.c          |   13 +--
 drivers/hwmon/adm1029.c          |   28 +---
 drivers/hwmon/adm1031.c          |   13 +--
 drivers/hwmon/adm9240.c          |   14 +--
 drivers/hwmon/ads1015.c          |   13 +--
 drivers/hwmon/ads7871.c          |   13 +--
 drivers/hwmon/adt7411.c          |   14 +--
 drivers/hwmon/adt7462.c          |   13 +--
 drivers/hwmon/adt7470.c          |   19 +--
 drivers/hwmon/adt7475.c          |  105 ++++++++------
 drivers/hwmon/amc6821.c          |   17 +--
 drivers/hwmon/applesmc.c         |    6 +-
 drivers/hwmon/asb100.c           |   13 +--
 drivers/hwmon/asc7621.c          |    8 +-
 drivers/hwmon/asus_atk0110.c     |   18 ++-
 drivers/hwmon/atxp1.c            |   15 +--
 drivers/hwmon/coretemp.c         |    4 +-
 drivers/hwmon/ds1621.c           |   93 ++++++-------
 drivers/hwmon/ds620.c            |   13 +--
 drivers/hwmon/emc1403.c          |   13 +--
 drivers/hwmon/emc2103.c          |   13 +--
 drivers/hwmon/emc6w201.c         |   12 +--
 drivers/hwmon/f71805f.c          |  211 ++++++++++++++++++++---------
 drivers/hwmon/f71882fg.c         |    4 +-
 drivers/hwmon/f75375s.c          |   13 +--
 drivers/hwmon/fschmd.c           |   13 +--
 drivers/hwmon/g760a.c            |   19 +--
 drivers/hwmon/gl518sm.c          |   13 +--
 drivers/hwmon/gl520sm.c          |   15 +--
 drivers/hwmon/hwmon-vid.c        |   36 +++---
 drivers/hwmon/hwmon.c            |   25 ++--
 drivers/hwmon/i5k_amb.c          |   18 ++-
 drivers/hwmon/ibmaem.c           |    2 +-
 drivers/hwmon/it87.c             |  176 +++++++++++++++---------
 drivers/hwmon/jc42.c             |   19 +--
 drivers/hwmon/k10temp.c          |    2 +-
 drivers/hwmon/k8temp.c           |   17 ++-
 drivers/hwmon/lineage-pem.c      |   13 +--
 drivers/hwmon/lm63.c             |   13 +--
 drivers/hwmon/lm70.c             |   15 +--
 drivers/hwmon/lm73.c             |   15 +--
 drivers/hwmon/lm75.c             |   17 +--
 drivers/hwmon/lm77.c             |   13 +--
 drivers/hwmon/lm80.c             |  171 +++++++++++++++++------
 drivers/hwmon/lm83.c             |   30 ++---
 drivers/hwmon/lm85.c             |   14 +--
 drivers/hwmon/lm87.c             |   13 +--
 drivers/hwmon/lm90.c             |   13 +--
 drivers/hwmon/lm92.c             |   13 +--
 drivers/hwmon/lm93.c             |   13 +--
 drivers/hwmon/lm95241.c          |   13 +--
 drivers/hwmon/lm95245.c          |   13 +--
 drivers/hwmon/ltc4151.c          |   13 +--
 drivers/hwmon/ltc4215.c          |   28 ++---
 drivers/hwmon/ltc4245.c          |   22 +--
 drivers/hwmon/ltc4261.c          |   13 +--
 drivers/hwmon/max1111.c          |   12 +--
 drivers/hwmon/max16065.c         |   13 +--
 drivers/hwmon/max1619.c          |   13 +--
 drivers/hwmon/max1668.c          |   13 +--
 drivers/hwmon/max6639.c          |   13 +--
 drivers/hwmon/max6642.c          |   13 +--
 drivers/hwmon/max6650.c          |  177 ++++++++++++-----------
 drivers/hwmon/mc13783-adc.c      |    2 +-
 drivers/hwmon/pc87360.c          |   73 ++++++----
 drivers/hwmon/pcf8591.c          |    4 +-
 drivers/hwmon/pmbus/adm1275.c    |   12 +--
 drivers/hwmon/pmbus/lm25066.c    |   12 +--
 drivers/hwmon/pmbus/ltc2978.c    |   12 +--
 drivers/hwmon/pmbus/max16064.c   |   12 +--
 drivers/hwmon/pmbus/max34440.c   |   12 +--
 drivers/hwmon/pmbus/max8688.c    |   12 +--
 drivers/hwmon/pmbus/pmbus.c      |   12 +--
 drivers/hwmon/pmbus/pmbus_core.c |    2 +-
 drivers/hwmon/pmbus/ucd9000.c    |   12 +--
 drivers/hwmon/pmbus/ucd9200.c    |   12 +--
 drivers/hwmon/pmbus/zl6100.c     |   12 +--
 drivers/hwmon/sht15.c            |    2 +-
 drivers/hwmon/sht21.c            |   23 +---
 drivers/hwmon/sis5595.c          |    2 +-
 drivers/hwmon/smm665.c           |   22 +--
 drivers/hwmon/smsc47m192.c       |   13 +--
 drivers/hwmon/thmc50.c           |   13 +--
 drivers/hwmon/tmp102.c           |   12 +--
 drivers/hwmon/tmp401.c           |   13 +--
 drivers/hwmon/tmp421.c           |   13 +--
 drivers/hwmon/via686a.c          |    2 +-
 drivers/hwmon/vt8231.c           |  285 ++++++++++++++++++++++++--------------
 drivers/hwmon/w83627hf.c         |    8 +-
 drivers/hwmon/w83781d.c          |  146 ++++++++++++-------
 drivers/hwmon/w83791d.c          |   13 +--
 drivers/hwmon/w83792d.c          |   20 +---
 drivers/hwmon/w83793.c           |   19 +--
 drivers/hwmon/w83795.c           |   13 +--
 drivers/hwmon/w83l785ts.c        |   15 +--
 drivers/hwmon/w83l786ng.c        |   17 +--
 drivers/hwmon/wm831x-hwmon.c     |    8 +-
 drivers/hwmon/wm8350-hwmon.c     |    2 +-
 106 files changed, 1228 insertions(+), 1620 deletions(-)

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH5HBAAoJEMsfJm/On5mByhwP/iXpRqtDtiVk6fm8cvjyq4x2
yTdN0YhkYMk5f31hjTu4v3/RQLTQCZLpyT9+XrYetnsAlVor7vIKTCgDMzkKyfVM
w9OxjCj79EOjBz2X5DSvWnaqwsGQfQuVXG4xpyB4KbJ7kgwZZuXceJg4DarYN6nL
NF8/Ib8OvkonZAHA7YBlumbJs9CxnkTEuBGUeTJwURJ5lmDEZxrlzrKbh/iFyGN0
sWbT+Qy1jeBWEIFRFvzvqyO/2fWIn7Q0K/Kw6soyHehlcOtLd6wi7OUnUlOxXN96
IuGBf1+5bYvHhtTZEYgrAkPYvnm7kIv0RcbOcVBCfuUtpce0YHTAa7SfvEvfBtUl
lUu/2sL7gsjElc64YmBgK9gmNtdGNZLml3ntgLB3nMTeZYCt+k8XAKzl1Iaq207s
ulOmVlWEnUu14ztIPNYLWLPX1P89Fumw3Le+7trdBulEqFkHpwg1ipXf416ZgAhm
X5xvYXqwPj+QkIQklxdu/MsuoCgEU9qUPcvDtNR672JOWSwr1FODGmq3V1ZPyErg
kWDP4Z3MXwZiDFOxoVE7GVjIkrO9a9hsJwPxrGyOIUpflEKgDVzmkh1Y1Ut5IiQc
DEPr1wuKNFQSXNBmIxOPpN1F1vVLfGDS87WIGmjYr+i6sRf7fx+rXsYKTbncpWpb
eYkwEsv2adQaVCUwLEjQ
=9UAe
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
