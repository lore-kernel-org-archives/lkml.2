Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2AZVgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:36:09 -0500
Received: from imr3.ericy.com ([198.24.6.13]:40486 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab2AZVgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:36:07 -0500
Message-ID: <1327613587.2649.231.camel@groeck-laptop>
Subject: Re: [lm-sensors] [GIT PULL] hwmon updates for 3.3
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Thu, 26 Jan 2012 13:33:07 -0800
In-Reply-To: <20120125052313.GA11583@ericsson.com>
References: <20120125052313.GA11583@ericsson.com>
Organization: Ericsson
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-ZV1laEdCoddTcVq8j33+"
X-Mailer: Evolution 3.2.1- 
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-ZV1laEdCoddTcVq8j33+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Linus,

I noticed you did not apply this set of patches. Please let me know if
this was an oversight, still coming, too much for a release candidate,
or some other problem.

Thanks,
Guenter

On Wed, 2012-01-25 at 00:23 -0500, Guenter Roeck wrote:
> Hi Linus,
>=20
> Please pull hwmon subsystem updates for Linux 3.3 from:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.gi=
t hwmon-for-linus
>=20
> Looks like a lot of changes, but almost all of it is cleanup, plus some
> error handling improvements, MAINTAINERS updates, and a couple of
> minor bug fixes.
>=20
> Thanks,
> Guenter
>=20
> ------
>=20
> The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d=
1f:
>=20
>   Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)
>=20
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
hwmon-for-linus
>=20
> Axel Lin (2):
>       hwmon: convert drivers/hwmon/* to use module_i2c_driver()
>       hwmon: convert drivers/hwmon/* to use module_spi_driver()
>=20
> Frans Meulenbroeks (26):
>       hwmon: (lm80) add error handling
>       hwmon: (amc6821) fix initialisation
>       hwmon: (mc13783-adc) remove space before tab
>       hwmon: remove () used with return
>       hwmon: use DEFINE_PCI_DEVICE_TABLE
>       hwmon: (i5k_amb) fix checkpatch issues
>       hwmon: (g760a) fix checkpatch issues
>       hwmon: (adm1029) fix checkpatch issues
>       hwmon: fix checkpatch issues
>       hwmon: (wm831x-hwmon) fix checkpatch issues
>       hwmon: (w83l785ts) fix checkpatch issues
>       hwmon: (ad7418) fix checkpatch issues
>       hwmon: (ad7414) fix checkpatch issues
>       hwmon: (ibmaem) fix checkpatch issues
>       hwmon: (sht15) fix checkpatch issues
>       hwmon: (smm665) fix checkpatch issues
>       hwmon: (adt7475) fix checkpatch issues
>       hwmon: (asus_atk0110) fix checkpatch issues
>       hwmon: (f71882fg) fix checkpatch issues
>       hwmon: (lm70) fix checkpatch issues
>       hwmon: (adt7411) fix checkpatch issues
>       hwmon: (adt7470) fix checkpatch issues
>       hwmon: (lm80) fix checkpatch warnings
>       hwmon: (lm80) reset device if error occurred
>       hwmon: (k8temp) fix checkpatch issues
>       hwmon: (lm83) fix checkpatch issues
>=20
> Guenter Roeck (31):
>       hwmon: (pmbus) Replace strict_strtol with kstrtol
>       hwmon: (max6650) Fix checkpatch issues
>       hwmon: (vt8231) Fix checkpatch issues
>       hwmon: (abituguru3) Fix checkpatch issues
>       hwmon: (adm1025) Fix checkpatch issues
>       hwmon: (adm1025) Limit data range when writing cpu0_vid
>       hwmon: (w83781d) Fix checkpatch issues
>       hwmon: (max6650) Fix multi-line comments
>       hwmon: (f71805f) Fix multi-line comments
>       hwmon: (adt7475) Fix multi-line comments
>       hwmon: (vt8231) Fix multi-line comments
>       hwmon: (ds1621) Fix checkpatch issues
>       hwmon: (ds1621) Fix multi-line comments
>       hwmon: (f71805f) Fix checkpatch issues
>       hwmon: (hwmon) Fix multi-line comments
>       hwmon: (hwmon-vid) Fix multi-line comments
>       hwmon: (it87) Fix multi-line comments
>       hwmon: (asc7621) Fix multi-line comments
>       hwmon: (smm665) Fix checkpatch error
>       hwmon: (wm831x-hwmon) Fix multi-line comments
>       hwmon: (pc87360) Fix multi-line comments
>       hwmon: (coretemp) Fix checkpatch error
>       hwmon: (jc42) Fix multi-line comments
>       hwmon: (ad7414) Fix multi-line comments
>       hwmon: (it87) Constify fixed string arrays
>       hwmon: (asus_atk0110) Fix multi-line comments
>       hwmon: (applesmc) Fix multi-line comments
>       hwmon: (wm8350-hwmon) Constify fixed string array
>       hwmon: (ltc4245) Fix multi-line comments
>       hwmon: (ltc4215) Fix multi-line comments
>       MAINTAINERS: Drop maintainer for MAX1668 hwmon driver
>=20
> Jean Delvare (1):
>       hwmon: (f71805f) Fix clamping of temperature limits
>=20
> Mark Brown (1):
>       MAINTAINERS: Add hwmon entries for Wolfson
>=20
>  MAINTAINERS                      |    8 +-
>  drivers/hwmon/abituguru3.c       |   56 +++++---
>  drivers/hwmon/ad7314.c           |   12 +--
>  drivers/hwmon/ad7414.c           |   21 +--
>  drivers/hwmon/ad7418.c           |   25 ++--
>  drivers/hwmon/adcxx.c            |   13 +--
>  drivers/hwmon/adm1021.c          |   13 +--
>  drivers/hwmon/adm1025.c          |   76 ++++++----
>  drivers/hwmon/adm1026.c          |   13 +--
>  drivers/hwmon/adm1029.c          |   28 +---
>  drivers/hwmon/adm1031.c          |   13 +--
>  drivers/hwmon/adm9240.c          |   14 +--
>  drivers/hwmon/ads1015.c          |   13 +--
>  drivers/hwmon/ads7871.c          |   13 +--
>  drivers/hwmon/adt7411.c          |   14 +--
>  drivers/hwmon/adt7462.c          |   13 +--
>  drivers/hwmon/adt7470.c          |   19 +--
>  drivers/hwmon/adt7475.c          |  105 ++++++++------
>  drivers/hwmon/amc6821.c          |   17 +--
>  drivers/hwmon/applesmc.c         |    6 +-
>  drivers/hwmon/asb100.c           |   13 +--
>  drivers/hwmon/asc7621.c          |    8 +-
>  drivers/hwmon/asus_atk0110.c     |   18 ++-
>  drivers/hwmon/atxp1.c            |   15 +--
>  drivers/hwmon/coretemp.c         |    4 +-
>  drivers/hwmon/ds1621.c           |   93 ++++++-------
>  drivers/hwmon/ds620.c            |   13 +--
>  drivers/hwmon/emc1403.c          |   13 +--
>  drivers/hwmon/emc2103.c          |   13 +--
>  drivers/hwmon/emc6w201.c         |   12 +--
>  drivers/hwmon/f71805f.c          |  211 ++++++++++++++++++++---------
>  drivers/hwmon/f71882fg.c         |    4 +-
>  drivers/hwmon/f75375s.c          |   13 +--
>  drivers/hwmon/fschmd.c           |   13 +--
>  drivers/hwmon/g760a.c            |   19 +--
>  drivers/hwmon/gl518sm.c          |   13 +--
>  drivers/hwmon/gl520sm.c          |   15 +--
>  drivers/hwmon/hwmon-vid.c        |   36 +++---
>  drivers/hwmon/hwmon.c            |   25 ++--
>  drivers/hwmon/i5k_amb.c          |   18 ++-
>  drivers/hwmon/ibmaem.c           |    2 +-
>  drivers/hwmon/it87.c             |  176 +++++++++++++++---------
>  drivers/hwmon/jc42.c             |   19 +--
>  drivers/hwmon/k10temp.c          |    2 +-
>  drivers/hwmon/k8temp.c           |   17 ++-
>  drivers/hwmon/lineage-pem.c      |   13 +--
>  drivers/hwmon/lm63.c             |   13 +--
>  drivers/hwmon/lm70.c             |   15 +--
>  drivers/hwmon/lm73.c             |   15 +--
>  drivers/hwmon/lm75.c             |   17 +--
>  drivers/hwmon/lm77.c             |   13 +--
>  drivers/hwmon/lm80.c             |  171 +++++++++++++++++------
>  drivers/hwmon/lm83.c             |   30 ++---
>  drivers/hwmon/lm85.c             |   14 +--
>  drivers/hwmon/lm87.c             |   13 +--
>  drivers/hwmon/lm90.c             |   13 +--
>  drivers/hwmon/lm92.c             |   13 +--
>  drivers/hwmon/lm93.c             |   13 +--
>  drivers/hwmon/lm95241.c          |   13 +--
>  drivers/hwmon/lm95245.c          |   13 +--
>  drivers/hwmon/ltc4151.c          |   13 +--
>  drivers/hwmon/ltc4215.c          |   28 ++---
>  drivers/hwmon/ltc4245.c          |   22 +--
>  drivers/hwmon/ltc4261.c          |   13 +--
>  drivers/hwmon/max1111.c          |   12 +--
>  drivers/hwmon/max16065.c         |   13 +--
>  drivers/hwmon/max1619.c          |   13 +--
>  drivers/hwmon/max1668.c          |   13 +--
>  drivers/hwmon/max6639.c          |   13 +--
>  drivers/hwmon/max6642.c          |   13 +--
>  drivers/hwmon/max6650.c          |  177 ++++++++++++-----------
>  drivers/hwmon/mc13783-adc.c      |    2 +-
>  drivers/hwmon/pc87360.c          |   73 ++++++----
>  drivers/hwmon/pcf8591.c          |    4 +-
>  drivers/hwmon/pmbus/adm1275.c    |   12 +--
>  drivers/hwmon/pmbus/lm25066.c    |   12 +--
>  drivers/hwmon/pmbus/ltc2978.c    |   12 +--
>  drivers/hwmon/pmbus/max16064.c   |   12 +--
>  drivers/hwmon/pmbus/max34440.c   |   12 +--
>  drivers/hwmon/pmbus/max8688.c    |   12 +--
>  drivers/hwmon/pmbus/pmbus.c      |   12 +--
>  drivers/hwmon/pmbus/pmbus_core.c |    2 +-
>  drivers/hwmon/pmbus/ucd9000.c    |   12 +--
>  drivers/hwmon/pmbus/ucd9200.c    |   12 +--
>  drivers/hwmon/pmbus/zl6100.c     |   12 +--
>  drivers/hwmon/sht15.c            |    2 +-
>  drivers/hwmon/sht21.c            |   23 +---
>  drivers/hwmon/sis5595.c          |    2 +-
>  drivers/hwmon/smm665.c           |   22 +--
>  drivers/hwmon/smsc47m192.c       |   13 +--
>  drivers/hwmon/thmc50.c           |   13 +--
>  drivers/hwmon/tmp102.c           |   12 +--
>  drivers/hwmon/tmp401.c           |   13 +--
>  drivers/hwmon/tmp421.c           |   13 +--
>  drivers/hwmon/via686a.c          |    2 +-
>  drivers/hwmon/vt8231.c           |  285 ++++++++++++++++++++++++--------=
------
>  drivers/hwmon/w83627hf.c         |    8 +-
>  drivers/hwmon/w83781d.c          |  146 ++++++++++++-------
>  drivers/hwmon/w83791d.c          |   13 +--
>  drivers/hwmon/w83792d.c          |   20 +---
>  drivers/hwmon/w83793.c           |   19 +--
>  drivers/hwmon/w83795.c           |   13 +--
>  drivers/hwmon/w83l785ts.c        |   15 +--
>  drivers/hwmon/w83l786ng.c        |   17 +--
>  drivers/hwmon/wm831x-hwmon.c     |    8 +-
>  drivers/hwmon/wm8350-hwmon.c     |    2 +-
>  106 files changed, 1228 insertions(+), 1620 deletions(-)


--=-ZV1laEdCoddTcVq8j33+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPIcaTAAoJEANmWzN1g3l3CH0IAIwmnue5VUUJbozlddVB13HS
eY50PwxtK/zn4vIP0yDIH9iQcSMr7HmsGbPfzjiEcHj+0vhXRDanjux3LNOYZilZ
g4RGjoapU7E7ZjQpZZI8NYGBMY0ujpVgf90M1tNerxczFxO1KFEi3NRASKTVcMXt
vMXmKldu8r540DxmH0UKD065GUc5Jd2GFkxeeAtPNBT8Q1mq94ZCWbU0xiYbue6i
DWdfwULTl5cfEfXGIDaAn8Y+LLWNCNcXAmruBR1uYH10FpfCLHDKWIZ93s+D+N3F
HgDFyOzFjxe/U5KfEa8nMRMDouqTEDnr6s3ZCnloRWVv8BiywYEy87wbL+dz5a8=
=Gj8u
-----END PGP SIGNATURE-----

--=-ZV1laEdCoddTcVq8j33+--
