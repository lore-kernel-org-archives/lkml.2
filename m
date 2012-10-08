Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2JHOpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:45:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34756 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2JHOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:45:09 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 8 Oct 2012 22:44:47 +0800
X-Google-Sender-Auth: iKNWrjA_LSf3BC5sqw5-3RpXzxs
Message-ID: <CAK5ve-KCF2hm_JydM7=bEFschY_tTcDF2CEXMbRYLCM-K-QfdQ@mail.gmail.com>
Subject: [GIT PULL] LED subsystem update for v3.7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider to pull the following changes since commit
55d512e245bc7699a8800e23df1a24195dd08217:

  Linux 3.6-rc5 (2012-09-08 16:43:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 2f73c3927318abe3d7fcaecadfbad89e2d12f881:

  leds: add output driver configuration for pca9633 led driver
(2012-09-24 19:12:29 +0800)

----------------------------------------------------------------
AnilKumar Ch (1):
      leds: leds-gpio: adopt pinctrl support

Axel Lin (2):
      leds: wm8350: Convert to devm_regulator_get()
      leds: lm3642: Use regmap_update_bits() in lm3642_chip_init()

Colin Cross (1):
      leds: triggers: send uevent when changing triggers

Fabio Baltieri (1):
      leds: delay led_set_brightness if stopping soft-blink

G.Shark Jeong (2):
      leds: Add new LED driver for lm355x chips
      leds: Add new LED driver for lm3642 chips

Kim, Milo (9):
      leds-lp5523: add channel name in the platform data
      leds-lp5523: set the brightness to 0 forcely on removing the driver
      leds-lp5523: change the return type of lp5523_set_mode()
      leds-lp5523: minor code style fixes
      leds-lp5523: support new LP55231 device
      leds-lp5523: add new device id for LP55231
      leds-lp5523: use the i2c device id rather than fixed name
      leds-lp5523: turn off the LED engines on unloading the driver
      leds-lp5523: Fix riskiness of the page fault

Ondrej Zary (2):
      leds-clevo-mail: add MODULE_DEVICE_TABLE
      leds-clevo-mail: Fix Clevo M5x0V DMI strings

Peter Meerwald (1):
      leds: add output driver configuration for pca9633 led driver

Sachin Kamat (2):
      leds-lm3530: Use devm_regulator_get function
      leds-lm3530: Fix smatch warnings

Tobias Klauser (3):
      leds: leds-gpio: use of_match_ptr()
      leds: leds-gpio: Use platform_{get,set}_drvdata
      leds: leds-gpio: Use of_get_child_count() helper

 Documentation/leds/leds-lp5523.txt         |  21 +-
 drivers/leds/Kconfig                       |  26 +-
 drivers/leds/Makefile                      |   3 +-
 drivers/leds/led-class.c                   |  15 +
 drivers/leds/led-core.c                    |  16 +-
 drivers/leds/led-triggers.c                |  17 +-
 drivers/leds/leds-clevo-mail.c             |  10 +-
 drivers/leds/leds-gpio.c                   |  19 +-
 drivers/leds/leds-lm3530.c                 |  16 +-
 drivers/leds/leds-lm3556.c                 | 512 --------------------------
 drivers/leds/leds-lm355x.c                 | 572 +++++++++++++++++++++++++++++
 drivers/leds/leds-lm3642.c                 | 462 +++++++++++++++++++++++
 drivers/leds/leds-lp5523.c                 |  75 ++--
 drivers/leds/leds-pca9633.c                |  19 +-
 drivers/leds/leds-wm8350.c                 |  29 +-
 drivers/leds/leds.h                        |   2 +
 include/linux/leds-lp5523.h                |   1 +
 include/linux/leds.h                       |   4 +
 include/linux/platform_data/leds-lm3556.h  |  50 ---
 include/linux/platform_data/leds-lm355x.h  |  66 ++++
 include/linux/platform_data/leds-lm3642.h  |  38 ++
 include/linux/platform_data/leds-pca9633.h |  35 ++
 22 files changed, 1350 insertions(+), 658 deletions(-)
 delete mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 drivers/leds/leds-lm355x.c
 create mode 100644 drivers/leds/leds-lm3642.c
 delete mode 100644 include/linux/platform_data/leds-lm3556.h
 create mode 100644 include/linux/platform_data/leds-lm355x.h
 create mode 100644 include/linux/platform_data/leds-lm3642.h
 create mode 100644 include/linux/platform_data/leds-pca9633.h
