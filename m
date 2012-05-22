Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2EVUVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:21:21 -0400
Received: from imr4.ericy.com ([198.24.6.9]:44564 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab2EVUVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:21:18 -0400
Date: Tue, 22 May 2012 13:18:59 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.5-rc1
Message-ID: <20120522201859.GA1068@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.5-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to 4573acbc461b8089198500cee06ef0cdc5b70e82:

  hwmon: (it87) Make temp3 attribute conditional for IT8782F (2012-05-22 06:48:49 -0700)

----------------------------------------------------------------
hwmon updates for 3.5-rc1

New driver for INA219 and INA226, added support for IT8782F and IT8783E/F to
it87 driver, plus cleanups in a couple of drivers.

----------------------------------------------------------------
Axel Lin (1):
      hwmon: use module_pci_driver

Felten, Lothar (1):
      hwmon: INA219 and INA226 support

Guenter Roeck (9):
      hwmon: (it87) Add support for IT8782F and IT8783E/F
      hwmon: (ad7314) Remove unused defines, and rename OFFSET to SHIFT
      hwmon: (ntc_thermistor) Convert to devm_kzalloc
      hwmon: (ntc_thermistor) Return error code from hwmon_device_register
      hwmon: (ntc_thermistor) Optimize and fix build warning
      hwmon: (ntc_thermistor) Fix checkpatch warning
      hwmon: (it87) Create voltage attributes only if voltage is enabled
      hwmon: (it87) Convert to use devm_kzalloc and devm_request_region
      hwmon: (it87) Make temp3 attribute conditional for IT8782F

Kyle McMartin (5):
      acpi_power_meter: use the same struct {rw,ro}_sensor_template for both
      acpi_power_meter: use a {RW,RO}_SENSOR_TEMPLATE macro to clean things up
      acpi_power_meter: remove duplicate code between register_{ro,rw}_attrs
      acpi_power_meter: drop meter_rw_attrs, use common meter_attrs
      acpi_power_meter: clean up code around setup_attrs

 Documentation/hwmon/ina2xx           |   29 +++
 Documentation/hwmon/it87             |   28 ++-
 drivers/hwmon/Kconfig                |   13 ++
 drivers/hwmon/Makefile               |    1 +
 drivers/hwmon/acpi_power_meter.c     |  166 +++++++---------
 drivers/hwmon/ad7314.c               |   11 +-
 drivers/hwmon/fam15h_power.c         |   13 +-
 drivers/hwmon/ina2xx.c               |  368 ++++++++++++++++++++++++++++++++
 drivers/hwmon/it87.c                 |  384 +++++++++++++++++++++++++---------
 drivers/hwmon/k10temp.c              |   13 +-
 drivers/hwmon/k8temp.c               |   13 +-
 drivers/hwmon/ntc_thermistor.c       |  191 ++++++++---------
 include/linux/platform_data/ina2xx.h |   19 ++
 13 files changed, 902 insertions(+), 347 deletions(-)
 create mode 100644 Documentation/hwmon/ina2xx
 create mode 100644 drivers/hwmon/ina2xx.c
 create mode 100644 include/linux/platform_data/ina2xx.h

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPu/SzAAoJEMsfJm/On5mB26MP/ROaSbB4ijExFD1vGaJ1EumB
8eTtPvdfqNFOUe/Y4vgrq+f9ITyU+WDAkTsEPYmP22r68t3h1EAzHyM+LkBg5pmF
+nOW/kG57KmUxy52CEVphe7nRitc5M0PIsZZT91SCux6nKkrjrMdMdxGQgcTlM4E
yQPcFlXG9/32Fam4uFkmHVrdAgkKyaCO6KsaOitegQroZkYm4GujsIvPy73lfchS
ysTMck5SJqTnlrVFbfDGv4um3o5/zhav+LAkxDNPRJldBbnvjGwZw0xssKQuDQBQ
a8ZNDiIevwzoP/eZhXUz2BNbJ9eOqoa6CbVRbNAwS9zsoRqQaLn0V6ecpHedlBnt
GaKq/0VugKODstQSgK0Hh3KzidjFZsRjvsu6/7AZ1jVYuppKKgOxGIjHQ/5Jm7gf
QOXqoRiws8plPNsuLGFmhsedXNMcw2Ohfcb5DV0/nltjuw3soBc8tsNSst1ShdvG
wSZR50SFtUQq9ScT6wby4gX3cctb4eiMZBnH+OE4RYf207CTY6J8Q83A8JF/96qf
ewLj70WYe6/wYaJtqCP2au4f+AbwZNLry/DsDXeM6pgp/xwoTXJlVL8yNIbtia4P
D59Ui3f9J1JpyjG9j3ZTz8sv8fkrtrV2e93g1kvhfWPVb62Kk4iXpcRc79TtCxFz
SLGBop8+bmrydNws2Sn0
=Gw7Y
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
