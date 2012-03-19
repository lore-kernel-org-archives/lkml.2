Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032276Ab2CSRxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:53:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35225 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030417Ab2CSRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:53:23 -0400
Date: Mon, 19 Mar 2012 17:53:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for 3.4
Message-ID: <20120319175319.GB12384@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.4

for you to fetch changes up to 4992fa1fd425f1934f503ffa96b68e235b89db9a:

  Merge tag 'topic/twl' into regulator-next (2012-03-19 17:17:32 +0000)

----------------------------------------------------------------

regulator: Updates for 3.4

This has been a fairly quiet release from a regulator point of view, the
only real framework features added were devm support and a convenience
helper for setting up fixed voltage regulators.

We also added a couple of drivers (but will drop the BQ240022 driver via
the arm-soc tree as it's been replaced by the more generic
gpio-regulator driver) and Axel Lin continued his relentless and
generally awesome stream of fixes and cleanups.

----------------------------------------------------------------

Looking at the history here I should've branched the supply topic branch
off differently, I can't remember why I did things that way now but it
doesn't seem sensible to rebase everything at this late stage so I'm
sending the pull request as-is.

AnilKumar Ch (1):
      regulator: tps65217: Add tps65217 regulator driver

Axel Lin (48):
      regulator: s5m8767: Add missing breaks
      regulator: s5m8767: Remove redundant MODULE_ALIAS
      regulator: Update tps65217-regulator for DT changes
      regulator: Add empty devm_regulator_bulk_get for !CONFIG_REGULATOR
      regulator: Add devm_regulator_put in consumer.h
      regulator: add devm_regulator_* to the list of managed interfaces
      regulator: Kill s5m8767_get_reg_id function
      regulator: Remove redundant regmap_update_bits call for TPS65023_REG_CON_CTRL2
      regulator: Show correct chip id for max8649
      ARM: U300: Don't specify regulator consumers by struct device
      regulator: Remove obsolete consumer_dev related comment
      regulator: Simplify regulator_bulk_get and regulator_bulk_enable error paths
      regulator: Set delay to 0 if set_voltage_time_sel callback returns error
      regulator: tps62360: Remove pointless test for unsigned less than zero
      regulator: Fix module desciption for tps65910 regulator
      regulator: Sort Kconfig and Makefile entries
      regulator: Convert ab8499 to use get_voltage_sel()
      regulator: Fix the logic of s5m8767_set_voltage_time_sel
      regulator: Fix n_voltage settings for pcf50633 regulator
      regulator: Kill max8997_get_rid function
      regulator: Kill max8998_get_ldo function
      regulator: Simplify the code to get selector in isl6271a_set_voltage
      regulator: Add a pointer to aat2870_data in struct aat2870_regulator
      regulator: ad5398: Use DIV_ROUND_UP macro to calculate selector
      regulator: max1586: Use DIV_ROUND_UP macro to calculate selector
      regulator: max8660: Use DIV_ROUND_UP macro to calculate selector
      regulator: wm8400: Use DIV_ROUND_UP macro to calculate selector
      regulator: da903x: Use DIV_ROUND_UP macro to calculate selector
      regulator: tps65217: Use DIV_ROUND_UP macro to calculate selector
      regulator: Remove unused i2c variable in s5m8767_pmic_probe
      regulator: Silence error message in max8998_pmic_probe
      regulator: max8649: Use DIV_ROUND_UP macro to calculate selector
      regulator: Simplify the implementation of tps65912_get_voltage_dcdc
      regulator: Rename set_voltage_sel callback function name to *_sel
      regulator: tps6524x: Remove unneeded comment for N_REGULATORS
      regulator: Rename s5m8767_convert_voltage to s5m8767_convert_voltage_to_sel
      regulator: Use array to store dcdc_range settings for tps65912
      regulator: Use DIV_ROUND_CLOSEST in wm8350_isink_get_current
      regulator: Merge tps65217_pmic_ldo234_ops and tps65217_pmic_dcdc_ops to tps65217_pmic_ops
      regulator: Fix the logic of tps65910_get_mode
      regulator: tps65912: Use simple equations to get register address
      regulator: max8925: Use DIV_ROUND_UP macro
      regulator: Use tps65912_set_voltage_sel for both DCDCx and LDOx
      regulator: Simplify implementation of tps65912_get_voltage_dcdc
      regulator: s5m8767: Check pdata->buck[2|3|4]_gpiodvs earlier
      regulator: Make s5m8767_get_voltage_register always return correct register
      regulator: Refactor tps6507x to use one tps6507x_pmic_ops for all LDOs and DCDCs
      regulator: Convert tps6507x to set_voltage_sel

Bengt Jonsson (1):
      regulators/db8500: split off shared dbx500 code

Fabio Estevam (1):
      regulator: mc13xxx-regulator-core: Fix the build when driver is selected as module

Karol Lewandowski (1):
      regulator: max8997: Avoid spaces in regulator names

Kim, Milo (1):
      regulator: fix wrong header name in description

Laxman Dewangan (10):
      regulator: TPS62360: Add tps62360 regulator driver
      regulator: tps65910: Add regulator info for RTC rail
      regulator: tps65910: Initialize n_voltages for rails.
      regulator: tps65910: use appropriate variable names.
      regulator: tps65910: Sleep control through external inputs
      regulator: twl6030: Fix voltage selection logic
      regulator: tps65910: Correct VIO voltage configuration
      regulator: tps65910: Sleep off rails when ext sleep configured
      regulator: tps65910: Provide settling time for enabling rails
      regulator: tps65910: Provide settling time for DCDC voltage change

Mark Brown (17):
      regulator: Update s5m8767 for device tree API changes
      regulator: Implement devm_regulator_free()
      regulator: Provide devm_regulator_bulk_get()
      regulator: wm8350: Don't specify consumer supplies with struct device
      Merge branch 'regulator-drivers' into regulator-supply
      regulator: Remove support for supplies specified by struct device
      mfd: twl-core: Don't specify regulator consumers by struct device
      regulator: Don't add the function name to pr_fmt
      regulator: Complain if a voltage range is specified but can't be used
      regulator: Clean up debugfs error handling a bit
      regulator: s5m8767: Fix unused variable warning in probe()
      regulator: wm8994: Convert to devm_kzalloc()
      Merge remote-tracking branch 'regulator/topic/drivers' into regulator-next
      Merge remote-tracking branch 'regulator/topic/stub' into regulator-next
      Merge remote-tracking branches 'regulator/topic/devm' and 'regulator/topic/stub' into regulator-next
      Merge remote-tracking branch 'regulator/topic/supply' into regulator-next
      Merge tag 'topic/twl' into regulator-next

Peter Ujfalusi (2):
      regulator: twl-regulator: Add fixed LDO for V1V8, V2V1 supply
      mfd: twl-core: regulator configuration for twl6030 V1V8, V2V1 SMPS

Rajendra Nayak (2):
      regulator: twl: adapt twl-regulator driver to dt
      regulator: Fix up a confusing dev_warn when DT lookup fails

Sangbeom Kim (3):
      regulator: Add S5M8767A regulator driver
      regulator: Add S5M8767 configuration
      regulator: Fix s5m8767_set_voltage_time_sel calculation value

Sascha Hauer (5):
      regulator: provide a helper for registering a fixed regulator
      ARM i.MX pcm037: register a dummy regulator for the smsc911x device
      ARM i.MX 3ds debugboard: register a dummy regulator for the smsc911x device
      regulator: mc13783: bail out without platform data
      regulator fixed: Do not report enumaratable voltages if there are none

Stephen Boyd (2):
      regulator: Add devm_regulator_get()
      regulator: Remove ifdefs for debugfs code

Sylwester Nawrocki (1):
      regulator: Reverse the disable sequence in regulator_bulk_disable()

Tero Kristo (2):
      regulator: twl4030: add support for external voltage get/set
      regulator: twl6030: add support for vdd1, vdd2 and vdd3 regulators

Thierry Reding (1):
      regulator: tps6586x: fix typo in debug message

Ying-Chun Liu (PaulLiu) (1):
      regulator: Add Anatop regulator driver

 .../bindings/regulator/twl-regulator.txt           |   68 ++
 Documentation/driver-model/devres.txt              |    5 +
 arch/arm/mach-imx/mach-pcm037.c                    |    9 +
 arch/arm/mach-u300/i2c.c                           |    2 -
 arch/arm/plat-mxc/3ds_debugboard.c                 |    9 +
 drivers/mfd/twl-core.c                             |   49 ++-
 drivers/regulator/Kconfig                          |  299 +++++----
 drivers/regulator/Makefile                         |   46 +-
 drivers/regulator/aat2870-regulator.c              |   14 +-
 drivers/regulator/ab8500.c                         |   10 +-
 drivers/regulator/ad5398.c                         |    4 +-
 drivers/regulator/anatop-regulator.c               |  241 ++++++
 drivers/regulator/core.c                           |  200 ++++--
 drivers/regulator/da903x.c                         |   12 +-
 drivers/regulator/db8500-prcmu.c                   |  118 +---
 drivers/regulator/dbx500-prcmu.c                   |  241 ++++++
 drivers/regulator/dbx500-prcmu.h                   |   63 ++
 drivers/regulator/fixed-helper.c                   |   53 ++
 drivers/regulator/fixed.c                          |    4 +-
 drivers/regulator/isl6271a-regulator.c             |   14 +-
 drivers/regulator/max1586.c                        |    4 +-
 drivers/regulator/max8649.c                        |    5 +-
 drivers/regulator/max8660.c                        |   16 +-
 drivers/regulator/max8925-regulator.c              |    4 +-
 drivers/regulator/max8997.c                        |   37 +-
 drivers/regulator/max8998.c                        |   16 +-
 drivers/regulator/mc13783-regulator.c              |    3 +
 drivers/regulator/pcf50633-regulator.c             |   27 +-
 drivers/regulator/s5m8767.c                        |  790 ++++++++++++++++++++
 drivers/regulator/tps62360-regulator.c             |  472 ++++++++++++
 drivers/regulator/tps65023-regulator.c             |    4 -
 drivers/regulator/tps6507x-regulator.c             |  283 ++------
 drivers/regulator/tps65217-regulator.c             |  378 ++++++++++
 drivers/regulator/tps6524x-regulator.c             |    4 +-
 drivers/regulator/tps6586x-regulator.c             |    2 +-
 drivers/regulator/tps65910-regulator.c             |  398 +++++++++--
 drivers/regulator/tps65912-regulator.c             |  340 ++-------
 drivers/regulator/twl-regulator.c                  |  327 ++++++--
 drivers/regulator/wm8350-regulator.c               |    6 +-
 drivers/regulator/wm8400-regulator.c               |    6 +-
 drivers/regulator/wm8994-regulator.c               |    4 +-
 include/linux/i2c/twl.h                            |   14 +-
 include/linux/mfd/tps65910.h                       |    7 +
 include/linux/regulator/consumer.h                 |   22 +
 include/linux/regulator/driver.h                   |    6 +-
 include/linux/regulator/fixed.h                    |   13 +
 include/linux/regulator/machine.h                  |    2 -
 include/linux/regulator/tps62360.h                 |   57 ++
 48 files changed, 3660 insertions(+), 1048 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/twl-regulator.txt
 create mode 100644 drivers/regulator/anatop-regulator.c
 create mode 100644 drivers/regulator/dbx500-prcmu.c
 create mode 100644 drivers/regulator/dbx500-prcmu.h
 create mode 100644 drivers/regulator/fixed-helper.c
 create mode 100644 drivers/regulator/s5m8767.c
 create mode 100644 drivers/regulator/tps62360-regulator.c
 create mode 100644 drivers/regulator/tps65217-regulator.c
 create mode 100644 include/linux/regulator/tps62360.h

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZ3KCAAoJEBus8iNuMP3dQd4P/2Nhqps72uO42Gx9p7SdBNGD
BaXTlK9Oa+Z+nfVwu9uSlPvSHQw8gXyzYdiMvG7uoShIHHtrVDhLs4INPTt0tCi7
QXdBZ4XMPz9VTGp6gg7wSKfj5/hKuuZSImHlF726gDjxm8EZ4rUt98aTtpNWchDD
O79xgj6ki8p+qeEk5xDsuBtlkuRIhB1lbrAQKrUAEYAt5NfgZwIVRK/hVZSD8w6K
zZIish/kNLTmNQ262mJXAGGJRdPzbvdqN0YqZQOq6iio6KYASjFtq5xMTOKTBoGM
F3VL4+qHe0wEWdyp9+UL8onbpr+YyNyLV8OulYu6AgFV0fLv/cT92Y2kVpkO6dk8
NGobMiiZWB1AkyLtfLWWMof4QPfDDPEOSyWjvfy02IdDlBF50260AERBzQ3zLY5r
JVZW/2d/Qr4x3IKivi5YNwPQmdRM/0E4acr7ixz3/hN70htBWBJKCW83kGSaGZXy
C7rJWXIvkrPpc+7euhCtfrYX5eSgtk6zVdlMS4CxTaPgSlHFtxf3eS2yGBrS5eB+
JcLOGRq8jnNoIgYnHtuTGLKP00q1c8phIc6qegYfrIo4OpKi/F5EJUBV5tJVxDNA
K5NsMdRHhJX0adkbRxUITLzsoOorhlH5HYt4TKmUBvEhkp//VgoAJTb4OPeutje3
cb8QYQH6IbmZM4e3OmlD
=MIdb
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
