Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030643Ab2CTQ0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:26:08 -0400
Received: from imr4.ericy.com ([198.24.6.9]:48312 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2CTQ0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:26:05 -0400
Date: Tue, 20 Mar 2012 09:23:58 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.4
Message-ID: <20120320162358.GA5189@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.4 from tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Mostly cleanup. No new drivers this time around, but support for several chips
added to existing drivers: TPS40400, TPS40422, MTD040, MAX34446, ZL9101M,
ZL9117M, and LM96080. Also added watchdog support for SCH56xx, plus additional
sysfs attributes for a couple of drivers.

Thanks,
Guenter

------

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Axel Lin (2):
      hwmon: convert drivers/hwmon/* to use module_i2c_driver()
      hwmon: convert drivers/hwmon/* to use module_spi_driver()

Frans Meulenbroeks (25):
      hwmon: (lm80) add error handling
      hwmon: (amc6821) fix initialisation
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

Guenter Roeck (105):
      hwmon: (pmbus) Replace strict_strtol with kstrtol
      hwmon: (max6650) Fix checkpatch issues
      hwmon: (vt8231) Fix checkpatch issues
      hwmon: (abituguru3) Fix checkpatch issues
      hwmon: (adm1025) Fix checkpatch issues
      hwmon: (w83781d) Fix checkpatch issues
      hwmon: (max6650) Fix multi-line comments
      hwmon: (f71805f) Fix checkpatch issues
      hwmon: (adt7475) Fix multi-line comments
      hwmon: (vt8231) Fix multi-line comments
      hwmon: (ds1621) Fix checkpatch issues
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
      hwmon: (adt7462) Fix checkpatch issues
      hwmon: (atxp1) Fix checkpatch issues
      hwmon: (fschmd) Fix checkpatch issues
      hwmon: (lm87) Fix checkpatch issues
      hwmon: (lm87) Fix: do not use assignment in if condition
      hwmon: (lm92) Fix checkpatch issues
      hwmon: (lm93) Fix checkpatch issues
      hwmon: (pcf8591) Fix checkpatch issues
      hwmon: (sis5595) Fix checkpatch issues
      hwmon: (smsc47m192) Fix checkpatch issues
      hwmon: (smsc47m1) Fix: do not use assignment in if condition
      hwmon: (smsc47m1) Fix checkpatch issues
      hwmon: (thmc50) Fix checkpatch issues
      hwmon: (ultra45_env) Fix checkpatch issues
      hwmon: (w83791d) Fix checkpatch issues
      hwmon: (abituguru3) Fix multi-line comments
      hwmon: (ads7828) Fix multi-line comments
      hwmon: (ads7871) Fix multi-line comments
      hwmon: (amc6821) Fix multi-line comments
      hwmon: (emc1403) Fix multi-line comments
      hwmon: (f71882fg) Fix multi-line comments
      hwmon: (g760a) Fix multi-line comments
      hwmon: (ltc4151) Fix multi-line comments
      hwmon: (max1111) Fix multi-line comments
      hwmon: (w83627ehf) Fix multi-line comments
      hwmon: (abituguru) Fix checkpatch issues
      hwmon: (adm1021) Fix checkpatch issues
      hwmon: (adm1026) Fix checkpatch issues
      hwmon: (adm9240) Fix checkpatch issues
      hwmon: (asb100): Fix checkpatch issues
      hwmon: (dme1737) Fix checkpatch issues
      hwmon: (gl518sm) Fix checkpatch issues
      hwmon: (gl520sm) Fix checkpatch issues
      hwmon: (gl520sm) Fix: do not use assignment in if condition
      hwmon: (lm77) Fix checkpatch issues
      hwmon: (lm78) Fix checkpatch issues
      hwmon: (lm85) Fix checkpatch issues
      hwmon: (max1619): Fix checkpatch issues
      hwmon: (pc87360) Fix checkpatch issues
      hwmon: (pc87360) Fix: do not use assignment in if condition
      hwmon: (via686a) Fix checkpatch issues
      hwmon: (vt1211) Fix checkpatch issues
      hwmon: (vt1211) Fix: do not use assignment in if condition
      hwmon: (w83792d) Fix checkpatch issues
      hwmon: (w83793) Fix checkpatch issues
      hwmon: (w83l786ng) Fix checkpatch issues
      hwmon: (w83627hf) Fix checkpatch issues
      hwmon: (adm1029) Fix multi-line comments
      hwmon: (adm1031) Fix multi-line comments
      hwmon: (emc2103) Fix multi-line comments
      hwmon: (lm80) Fix multi-line comments
      hwmon: (max1668) Fix multi-line comments
      hwmon: (pc87427) Fix multi-line comments
      hwmon: (smsc47b397) Fix multi-line comments
      hwmon: (w83781d) Fix multi-line comments
      hwmon: (w83781d) Fix: do not use assignment in if condition
      hwmon: (w83l785ts) Fix multi-line comments
      hwmon: (w83l786ng) Fix multi-line comments
      hwmon: (lm70) Register hwmon device after creating attribute files, and remove it first
      hwmon: (lm70) Fix: do not use assignment in if condition
      hwmon: (hwmon-vid) Add new entries to VRM model table
      hwmon: (hwmon-vid) Fix checkpatch issues
      hwmon: (lineage-pem) Convert to use devm_kzalloc
      hwmon: (pmbus) Convert pmbus drivers to use devm_kzalloc
      hwmon: (pmbus) Simplify remove functions
      hwmon: (ltc4261) Convert to use devm_kzalloc
      hwmon: (smm665) Convert to use devm_kzalloc
      hwmon: (max16065) Convert to use devm_kzalloc
      hwmon: (jc42) Convert to use devm_kzalloc
      hwmon: (max34440) Add support for 'lowest' output voltage attribute
      hwmon: (pmbus) Add support for TI TPS40400 and TPS40422
      hwmon: (pmbus) Add support for Lineage Power MDT040
      hwmon: (pmbus) Add more virtual registers
      hwmon: (max34440) Add support for MAX34446
      hwmon: (adm1275) Add support for ADM1075
      hwmon: (zl6100) Add support for ZL9101M and ZL9117M
      hwmon: (jc42) Remove unnecessary device IDs
      hwmon: (w83627ehf) Add support for temperature offset registers

Hans de Goede (1):
      hwmon: (sch56xx) Add support for the integrated watchdog (v2)

Henrik Rydberg (1):
      hwmon: (applesmc) Silence uninitialized warnings

Jean Delvare (3):
      hwmon: (lm87) Reorganize the code
      hwmon: (lm87) Get rid of macro-generated functions
      hwmon: (lm80) Add detection of NatSemi/TI LM96080

 Documentation/hwmon/adm1275      |   30 +-
 Documentation/hwmon/jc42         |   39 +--
 Documentation/hwmon/lm80         |    9 +-
 Documentation/hwmon/max34440     |   30 ++-
 Documentation/hwmon/pmbus        |    9 +-
 Documentation/hwmon/sch5627      |    5 +
 Documentation/hwmon/sch5636      |    3 +
 Documentation/hwmon/zl6100       |    8 +
 drivers/hwmon/Kconfig            |   10 +-
 drivers/hwmon/abituguru.c        |  584 ++++++++++++++---------
 drivers/hwmon/abituguru3.c       |  267 +++++++----
 drivers/hwmon/ad7314.c           |   12 +-
 drivers/hwmon/ad7414.c           |   21 +-
 drivers/hwmon/ad7418.c           |   25 +-
 drivers/hwmon/adcxx.c            |   13 +-
 drivers/hwmon/adm1021.c          |   97 +++--
 drivers/hwmon/adm1025.c          |   76 ++--
 drivers/hwmon/adm1026.c          |  504 +++++++++++++--------
 drivers/hwmon/adm1029.c          |   47 +--
 drivers/hwmon/adm1031.c          |   73 ++--
 drivers/hwmon/adm9240.c          |   86 ++--
 drivers/hwmon/ads1015.c          |   13 +-
 drivers/hwmon/ads7828.c          |   59 ++--
 drivers/hwmon/ads7871.c          |   39 +-
 drivers/hwmon/adt7411.c          |   14 +-
 drivers/hwmon/adt7462.c          |   30 +-
 drivers/hwmon/adt7470.c          |   19 +-
 drivers/hwmon/adt7475.c          |  105 +++--
 drivers/hwmon/amc6821.c          |   74 ++--
 drivers/hwmon/applesmc.c         |   14 +-
 drivers/hwmon/asb100.c           |  200 +++++----
 drivers/hwmon/asc7621.c          |    8 +-
 drivers/hwmon/asus_atk0110.c     |   18 +-
 drivers/hwmon/atxp1.c            |  173 ++++---
 drivers/hwmon/coretemp.c         |    4 +-
 drivers/hwmon/dme1737.c          |  506 ++++++++++++---------
 drivers/hwmon/ds1621.c           |   93 ++--
 drivers/hwmon/ds620.c            |   13 +-
 drivers/hwmon/emc1403.c          |   25 +-
 drivers/hwmon/emc2103.c          |   63 ++--
 drivers/hwmon/emc6w201.c         |   12 +-
 drivers/hwmon/f71805f.c          |  201 ++++++---
 drivers/hwmon/f71882fg.c         |   63 ++-
 drivers/hwmon/f75375s.c          |   13 +-
 drivers/hwmon/fschmd.c           |  231 ++++++----
 drivers/hwmon/g760a.c            |   48 +--
 drivers/hwmon/gl518sm.c          |  115 +++--
 drivers/hwmon/gl520sm.c          |  243 ++++++----
 drivers/hwmon/hwmon-vid.c        |  159 +++----
 drivers/hwmon/hwmon.c            |   25 +-
 drivers/hwmon/i5k_amb.c          |   18 +-
 drivers/hwmon/ibmaem.c           |    2 +-
 drivers/hwmon/it87.c             |  176 +++++---
 drivers/hwmon/jc42.c             |   97 ++---
 drivers/hwmon/k10temp.c          |    2 +-
 drivers/hwmon/k8temp.c           |   17 +-
 drivers/hwmon/lineage-pem.c      |   24 +-
 drivers/hwmon/lm63.c             |   13 +-
 drivers/hwmon/lm70.c             |   38 +-
 drivers/hwmon/lm73.c             |   15 +-
 drivers/hwmon/lm75.c             |   17 +-
 drivers/hwmon/lm77.c             |  172 ++++---
 drivers/hwmon/lm78.c             |  206 ++++++---
 drivers/hwmon/lm80.c             |  247 +++++++---
 drivers/hwmon/lm83.c             |   30 +-
 drivers/hwmon/lm85.c             |  374 +++++++++------
 drivers/hwmon/lm87.c             |  958 ++++++++++++++++++++------------------
 drivers/hwmon/lm90.c             |   13 +-
 drivers/hwmon/lm92.c             |  111 +++--
 drivers/hwmon/lm93.c             |  696 +++++++++++++++++-----------
 drivers/hwmon/lm95241.c          |   13 +-
 drivers/hwmon/lm95245.c          |   13 +-
 drivers/hwmon/ltc4151.c          |   16 +-
 drivers/hwmon/ltc4215.c          |   28 +-
 drivers/hwmon/ltc4245.c          |   22 +-
 drivers/hwmon/ltc4261.c          |   28 +-
 drivers/hwmon/max1111.c          |   15 +-
 drivers/hwmon/max16065.c         |   36 +--
 drivers/hwmon/max1619.c          |   34 +-
 drivers/hwmon/max1668.c          |   51 +--
 drivers/hwmon/max6639.c          |   13 +-
 drivers/hwmon/max6642.c          |   13 +-
 drivers/hwmon/max6650.c          |  177 ++++----
 drivers/hwmon/pc87360.c          |  602 ++++++++++++++----------
 drivers/hwmon/pc87427.c          |   72 ++--
 drivers/hwmon/pcf8591.c          |  143 ++++---
 drivers/hwmon/pmbus/Kconfig      |   17 +-
 drivers/hwmon/pmbus/adm1275.c    |  124 ++++--
 drivers/hwmon/pmbus/lm25066.c    |   46 +--
 drivers/hwmon/pmbus/ltc2978.c    |   50 +--
 drivers/hwmon/pmbus/max16064.c   |   20 +-
 drivers/hwmon/pmbus/max34440.c   |  139 +++++-
 drivers/hwmon/pmbus/max8688.c    |   20 +-
 drivers/hwmon/pmbus/pmbus.c      |   40 +--
 drivers/hwmon/pmbus/pmbus.h      |   57 ++-
 drivers/hwmon/pmbus/pmbus_core.c |   87 ++--
 drivers/hwmon/pmbus/ucd9000.c    |   47 +--
 drivers/hwmon/pmbus/ucd9200.c    |   43 +--
 drivers/hwmon/pmbus/zl6100.c     |   44 +--
 drivers/hwmon/sch5627.c          |   11 +-
 drivers/hwmon/sch5636.c          |   11 +-
 drivers/hwmon/sch56xx-common.c   |  519 ++++++++++++++++++++-
 drivers/hwmon/sch56xx-common.h   |   10 +-
 drivers/hwmon/sht15.c            |    2 +-
 drivers/hwmon/sht21.c            |   23 +-
 drivers/hwmon/sis5595.c          |  307 ++++++++-----
 drivers/hwmon/smm665.c           |   34 +-
 drivers/hwmon/smsc47b397.c       |   64 ++--
 drivers/hwmon/smsc47m1.c         |  291 ++++++++-----
 drivers/hwmon/smsc47m192.c       |  145 ++++---
 drivers/hwmon/thmc50.c           |   84 ++--
 drivers/hwmon/tmp102.c           |   12 +-
 drivers/hwmon/tmp401.c           |   13 +-
 drivers/hwmon/tmp421.c           |   13 +-
 drivers/hwmon/ultra45_env.c      |   34 +-
 drivers/hwmon/via686a.c          |  357 +++++++++------
 drivers/hwmon/vt1211.c           |  389 ++++++++--------
 drivers/hwmon/vt8231.c           |  285 +++++++-----
 drivers/hwmon/w83627ehf.c        |  261 +++++++----
 drivers/hwmon/w83627hf.c         |  272 +++++++----
 drivers/hwmon/w83781d.c          |  475 +++++++++++--------
 drivers/hwmon/w83791d.c          |  331 ++++++++------
 drivers/hwmon/w83792d.c          |  397 +++++++++-------
 drivers/hwmon/w83793.c           |  453 ++++++++++--------
 drivers/hwmon/w83795.c           |   13 +-
 drivers/hwmon/w83l785ts.c        |   30 +-
 drivers/hwmon/w83l786ng.c        |  190 +++++----
 drivers/hwmon/wm831x-hwmon.c     |    8 +-
 drivers/hwmon/wm8350-hwmon.c     |    2 +-
 129 files changed, 8581 insertions(+), 6219 deletions(-)

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaK8eAAoJEMsfJm/On5mBhRcP/1UXx6jNIou9aYASp+WkcTN5
89yq6mfPPDFHf3w5qQu79M+RCt+Qia4FS3SEA6X/WAtJRwwi6jPB1HDAX77YrdrM
bqH1OQPs9cXQlGelB5JNMIni/rhmAtrPMskOID6Fd82Yg7JGL92/8q18uvOQzkgY
dhsJuhU7hjUp9tZu3lhExRRSTDNG6KZSp7U4G5dype4saxEfCHbJkKMWVmKbc/8e
MudXoahBnJtUxPIVAOCGV5COIeC2iDoJiGebEWo0BqQRh3KNSnk+uii5FFM87LMe
dJJxcWJ5f7zDMQsIsNYKklv9RiJX4Qt5is01AEiNouJMsgOeQ2EzoHM22XGvSvGX
Sesy82B2Zoigl8/r0TL1NjjpTMY3loPYkTLUoWHGd7FpvjyppxknsMi1y8xeeTEu
VcSelwjBbPub5tgpP+HQqhCJZLt3hKMauyUDLF0PJm8eEnx+FjAOKslxObZv4DQK
KUHPsHlABhMIDFtOlLEQ1Q7x+Tifxi8Ow6bkABmIxz+b60+V27y6P4y6z77yLWkF
qR+/HflltG9T+IITUARSWB/nV4m/r0IYd9M2xPYUTW4jZ8D9+r8KdqEWkboe92LY
J7YJFL+BcgXms7tz010LgK5f371OBQx3GidKXZHGIQ+JZ9pq2ajrn8aZU8Ad9trx
bEamJIIM5gsrBcyyM1X6
=zMbw
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
