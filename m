Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1C0TRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 15:17:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38406 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1C0TRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 15:17:12 -0400
Subject: [GIT PULL] regulator updates for 2.6.39
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 20:17:06 +0100
Message-ID: <1301253427.3372.7.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator updates for 2.6.39. It's
mostly new features for existing PMIC drivers this time and also some
core improvements for resume handling.

Thanks

Liam

---  

The following changes since commit 16c29dafcc86024048f1dbb8349d31cb22c7c55a:

  Merge branch 'syscore' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-03-25 21:07:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Axel Lin (1):
      regulator: Add MODULE_DEVICE_TABLE to max8997 and max8998

Bengt Jonsson (2):
      regulator: add support for USB voltage regulator
      regulator: initialization for ab8500 regulators

Igor Grinberg (1):
      regulator: fix typo in Kconfig

Linus Walleij (4):
      regulator: switch the ab3100 to use enable_time()
      regulator: add set_voltage_time_sel infrastructure
      regulator: provide consumer interface for fall/rise time
      regulator: add ab8500 enable and raise time delays

Mark Brown (3):
      regulator: If we fail when setting up a supply say which supply
      regulator: Convert WM831x regulators to genirq
      regulator: Remove more wm831x-specific IRQ operations

MyungJoo Ham (1):
      Regulator: add suspend-finish API for regulator core.

Randy Dunlap (1):
      regulator: fix tps6524x section mismatch

 arch/arm/mach-ux500/board-mop500-regulators.h |    2 +
 arch/arm/mach-ux500/board-mop500.c            |    1 +
 drivers/regulator/Kconfig                     |    2 +-
 drivers/regulator/ab3100.c                    |   51 +++--
 drivers/regulator/ab8500.c                    |  270 ++++++++++++++++++++++++-
 drivers/regulator/core.c                      |  116 +++++++++++-
 drivers/regulator/max8997.c                   |    1 +
 drivers/regulator/max8998.c                   |    1 +
 drivers/regulator/tps6524x-regulator.c        |    2 +-
 drivers/regulator/wm831x-dcdc.c               |   32 ++--
 drivers/regulator/wm831x-isink.c              |    8 +-
 drivers/regulator/wm831x-ldo.c                |   17 +-
 include/linux/mfd/ab8500.h                    |    6 +
 include/linux/regulator/ab8500.h              |   51 +++++-
 include/linux/regulator/consumer.h            |    2 +
 include/linux/regulator/driver.h              |   11 +-
 include/linux/regulator/machine.h             |    1 +
 17 files changed, 509 insertions(+), 65 deletions(-)


