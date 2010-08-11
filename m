Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab0HKL47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 07:56:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37628 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0HKL46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 07:56:58 -0400
Subject: [GIT PULL] regulator updates for 2.6.36
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 12:56:49 +0100
Message-ID: <1281527809.3080.93.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator updates for 2.6.36. Notable
updates for 2.6.36 include new regulator drivers for the AB8500, AD5398,
ISL6271, MAX8998 and TPS6586x PMICs. The other updates are mostly
trivial fixes.

Thanks

Liam

---

The following changes since commit 3d30701b58970425e1d45994d6cb82f828924fdd:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (8):
      max8998: fix off-by-one value range checking
      regulator: lp3971 - remove unnecessary ret value checking in lp3971_i2c_write()
      regulator: max1586 - fix a memory leak in max1586_pmic_remove()
      regulator: max8660 - fix a memory leak in max8660_remove()
      regulator: lp3971 - remove unnecessary ret value checking in lp3971_i2c_write()
      mfd: max8998 - fix incorrect kfree(i2c) in i2c_driver probe callback handler
      regulator: tps6586x - add regulator_unregister() in tps6586x_regulator_remove()
      regulator: tps6507x - add missing platform_set_drvdata in tps6507x_pmic_probe

Gary King (1):
      regulator: tps6586x: fix millivolt return values and SM2 table

Joonyoung Shim (1):
      regulator: Default GPIO controlled WM8994 regulators to disabled

Kyungmin Park (1):
      drivers: regulator: add Maxim 8998 driver

Marek Szyprowski (1):
      drivers: regulators: depend on MFD_MAX8998

Marek Vasut (2):
      ISL6271A voltage regulator support.
      tps65023: Allow registering similar TPS65021

Mark Brown (1):
      regulator: Remove default DEBUG define from TPS6586x

Mike Rapoport (2):
      regulator: add TPS6586X regulator driver
      regulator: tps6586x: add dependancy on MFD_TPS6585x

MyungJoo Ham (1):
      regulator: MAX8998: set_voltage bugfix. ramp_up delay and min/max voltage

Sonic Zhang (2):
      regulator: new drivers for AD5398 and AD5821
      regulator: make sure the regulator is available prior to the consumers.

Sundar R IYER (1):
      regulator: add support for regulators on the ab8500 MFD

Sundar R Iyer (1):
      ab8500-mfd: add regulator support to ab8500 mfd device

 drivers/mfd/Kconfig                    |   10 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/ab8500-core.c              |    4 +-
 drivers/mfd/max8998.c                  |  158 ++++++++
 drivers/regulator/Kconfig              |   34 ++
 drivers/regulator/Makefile             |    5 +
 drivers/regulator/ab8500.c             |  427 +++++++++++++++++++++
 drivers/regulator/ad5398.c             |  288 +++++++++++++++
 drivers/regulator/isl6271a-regulator.c |  236 ++++++++++++
 drivers/regulator/lp3971.c             |   10 +-
 drivers/regulator/max1586.c            |   10 +-
 drivers/regulator/max8660.c            |   10 +-
 drivers/regulator/max8998.c            |  635 ++++++++++++++++++++++++++++++++
 drivers/regulator/tps65023-regulator.c |    2 +
 drivers/regulator/tps6507x-regulator.c |    1 +
 drivers/regulator/tps6586x-regulator.c |  396 ++++++++++++++++++++
 drivers/regulator/wm8994-regulator.c   |    5 +-
 include/linux/mfd/ab8500.h             |    6 +
 include/linux/mfd/max8998-private.h    |  112 ++++++
 include/linux/mfd/max8998.h            |   78 ++++
 include/linux/regulator/ab8500.h       |   25 ++
 21 files changed, 2431 insertions(+), 22 deletions(-)
 create mode 100644 drivers/mfd/max8998.c
 create mode 100644 drivers/regulator/ab8500.c
 create mode 100644 drivers/regulator/ad5398.c
 create mode 100644 drivers/regulator/isl6271a-regulator.c
 create mode 100644 drivers/regulator/max8998.c
 create mode 100644 drivers/regulator/tps6586x-regulator.c
 create mode 100644 include/linux/mfd/max8998-private.h
 create mode 100644 include/linux/mfd/max8998.h
 create mode 100644 include/linux/regulator/ab8500.h


