Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2DDOSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 10:18:32 -0400
Received: from imr4.ericy.com ([198.24.6.9]:33608 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab2DDOSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 10:18:31 -0400
Date: Wed, 4 Apr 2012 07:16:10 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.4-rc2
Message-ID: <20120404141609.GA17301@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull hwmon fixes for Linux 3.4-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
hwmon-for-linus

Fix crash in ad7314 driver
Add support for AMD Trinity CPUs to k10temp driver
Fix __initdata/__initconst mixup in w83627ehf driver
Fix runtime warnings in acpi_power_meter and max6639 drivers
Fix build warnings in adm1031, f75375s, sht15, and gpio-fan drivers

Thanks,
Guenter

------

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hw=
mon-for-linus

Andre Przywara (1):
      hwmon: (k10temp) Add support for AMD Trinity CPUs

Graeme Smecher (1):
      hwmon: (ad7314) Adds missing spi_dev initialization

Guenter Roeck (4):
      hwmon: (gpio-fan) Fix Kconfig dependencies
      hwmon: (sht15) Fix Kconfig dependencies
      hwmon: (f75375s) Fix warning message seen in some configurations
      hwmon: (adm1031) Fix compiler warning

Kyle McMartin (1):
      hwmon: (acpi_power_meter) fix lockdep spew due to non-static lock cla=
ss

Mark Brown (1):
      hwmon: (max6639) Convert to dev_pm_ops

Uwe Kleine-K=F6nig (1):
      hwmon: (w83627ehf) mark const init data with __initconst instead of _=
_initdata

 Documentation/hwmon/k10temp      |    2 +-
 drivers/hwmon/Kconfig            |    7 ++++---
 drivers/hwmon/acpi_power_meter.c |    2 ++
 drivers/hwmon/ad7314.c           |    1 +
 drivers/hwmon/adm1031.c          |   20 ++++++++------------
 drivers/hwmon/f75375s.c          |    2 ++
 drivers/hwmon/k10temp.c          |    4 ++++
 drivers/hwmon/max6639.c          |   15 +++++++++++----
 drivers/hwmon/w83627ehf.c        |   18 +++++++++---------
 9 files changed, 42 insertions(+), 29 deletions(-)

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfFepAAoJEMsfJm/On5mBfboP/3pKayEFAYljk9hL9UOOFSBx
UXE7mmopjxtYg9lVZt7qS+XdhiRJeIn9bWYVyY7rwWzkbPDz8CMaBfnAZtZOvXn5
iQBSTnClqJLqdw6O8hrO80PtBc4YSdb2KJI3pSEIErlt1Yd9foeNgPbtRArwvse7
XJ5cA3Zbmzw3ayIujnaZp0bnZDyCCSZ8Uq2Gt5AdFym9qEqE7MfiwzR1PvsWhyn/
hS3ZP2wVaGGm0O1GsYQ/tpQTTcW2ZHpK8f0j3W926sHsyw4p2jn1s5NnhdgbesDL
+B/lMuSdNmdBc6BKN/JDwk43yTjNnLDf03AQu0qnnEAqwBjuA+gQBOGbgoJro08g
dS0BLXxsVRYJAF7MFPVNSyIUEM4Ro6wm7g7JSqJsAeQ7Pk3aVba+r67khitQokB3
NtvBfVT329K9Xq54x49+iAreIJ2zu5Sbxhw6MTLBNvBxmB/Iem/wrPbpSdG1SfjN
+NgRoinS1Og3/yRihWCKM8oSZ4h8aFH/yYjYBFKnCJ/bEunCmJ/1Y2OW8X+y4uGV
w7JNJeFGX3Cntb/k09BPEJqHGA0uZfHQSi0UmF8QpoR3lT3mfpwlTNjdpyGBriGl
S+8Fbut96r9z2aOVmVDkqtQJpreTYw558pkTuWxEHcZzl4WR3aUFqYLS+CgLurEi
OWSSx5qvZPBcc2IEaIJu
=RgGQ
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
