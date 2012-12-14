Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2LNBE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:04:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59117 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2LNBE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:04:26 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 13 Dec 2012 17:04:04 -0800
Message-ID: <CAK5ve-+z47xJrT_aJZXWmyD0_BMAt6s9P+XwOR5dgzztvNGWKg@mail.gmail.com>
Subject: [GIT PULL] LED subsystem update for v3.8
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider to pull the following changes since commit
9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 2f05e1d4458f9cb68d4d36fb47e6830fec03c80e:

  leds: leds-lp5521: return an error code on error in probe()
(2012-12-03 11:16:58 -0800)

----------------------------------------------------------------
Axel Lin (4):
      leds: lm3642: Return proper error in
lm3642_[torch|strobe]_pin_store error paths
      leds: lm355x: Return proper error for
lm3556_indicator_pattern_store error path
      leds: lm355x: Fix up world writable sysfs file
      leds: lm3642: Fix up world writable sysfs files

Dan Carpenter (1):
      leds: leds-lp5521: return an error code on error in probe()

Fabio Baltieri (1):
      leds: add led_trigger_rename function

Jingoo Han (19):
      leds: leds-gpio: use gpio_request_one
      leds: leds-lt3593: use gpio_request_one
      leds: leds-ns2: use gpio_request_one
      leds: renesas: use gpio_request_one
      leds: leds-fsg: use devm_ioremap
      leds: leds-cobalt-raq: use devm_ioremap
      leds: leds-cobalt-qube: use devm_ioremap
      leds: renesas: use devm_ functions
      leds: leds-bd2802: replace strict_strtoul() with kstrtoul()
      leds: leds-netxbig: replace strict_strtoul() with kstrtoul()
      leds: leds-ns2: replace strict_strtoul() with kstrtoul()
      leds: leds-ss4200: replace strict_strtoul() with kstrtoul()
      leds: ledtrig-backlight: replace strict_strtoul() with kstrtoul()
      leds: ledtrig-gpio: replace strict_strtoul() with kstrtoul()
      leds: leds-lp5523: fix build warnings
      leds: leds-88pm860x: drop devm_kfree of devm_kzalloc'd data
      led: Add dependency on CONFIG_LEDS_TRIGGERS to led_trigger_rename_static()
      leds: leds-lp5521: replace strict_strtoul() with kstrtoul()
      leds: leds-lp5523: replace strict_strtoul() with kstrtoul()

Roland Stigge (1):
      leds: leds-gpio: Defer probing in case of deferred gpio probing

Sachin Kamat (21):
      leds: lp5521: Fix return value
      leds: lp5523: Fix return value
      leds: lp3944: Fix return value
      leds: leds-gpio: use devm_gpio_request_one
      leds: leds-lt3593: use devm_gpio_request_one
      leds: leds-ns2: use devm_gpio_request_one
      leds: led-class: Fix checkpatch warning
      leds: leds-adp5520: Fix checkpatch warnings
      leds: leds-bd2802: Fix checkpatch warnings
      leds: leds-da903x: Fix checkpatch error and warnings
      leds: leds-gpio: Use dev_info instead of printk
      leds: leds-lt3593: Fix checkpatch warnings
      leds: leds-net48xx: Use linux/io.h instead of asm/io.h
      leds: leds-pca955x: Use dev_info instead of printk
      leds: leds-pwm: Fix checkpatch warning
      leds: leds-wm8350: Use dev_err instead of printk
      leds: leds-wrap: Use <linux/io.h> instead of <asm/io.h>
      leds: ledtrig-backlight: Fix checkpatch error
      leds: led-triggers: Fix checkpatch warnings
      leds: leds-rb532: Fix checkpatch errors
      leds: leds-clevo-mail: Use pr_* instead of printks

 drivers/leds/led-class.c         |    2 +-
 drivers/leds/led-triggers.c      |   25 +++++++++++++++++++------
 drivers/leds/leds-88pm860x.c     |    9 ++-------
 drivers/leds/leds-adp5520.c      |    4 ++--
 drivers/leds/leds-bd2802.c       |   10 +++++-----
 drivers/leds/leds-clevo-mail.c   |   11 +++++------
 drivers/leds/leds-cobalt-qube.c  |   11 ++++-------
 drivers/leds/leds-cobalt-raq.c   |   11 ++++-------
 drivers/leds/leds-da903x.c       |   10 +++++-----
 drivers/leds/leds-fsg.c          |   15 +++++----------
 drivers/leds/leds-gpio.c         |   37 ++++++++++++++++++-------------------
 drivers/leds/leds-lm355x.c       |    4 ++--
 drivers/leds/leds-lm3642.c       |   12 ++++++------
 drivers/leds/leds-lp3944.c       |    2 +-
 drivers/leds/leds-lp5521.c       |   13 ++++++++++---
 drivers/leds/leds-lp5523.c       |   24 +++++++++++++++++++-----
 drivers/leds/leds-lt3593.c       |   20 ++++++--------------
 drivers/leds/leds-net48xx.c      |    2 +-
 drivers/leds/leds-netxbig.c      |    2 +-
 drivers/leds/leds-ns2.c          |   36 +++++++++++-------------------------
 drivers/leds/leds-pca955x.c      |    2 +-
 drivers/leds/leds-pwm.c          |    2 +-
 drivers/leds/leds-rb532.c        |    2 +-
 drivers/leds/leds-renesas-tpu.c  |   25 ++++++++++---------------
 drivers/leds/leds-ss4200.c       |    2 +-
 drivers/leds/leds-wm8350.c       |    4 ++--
 drivers/leds/leds-wrap.c         |    2 +-
 drivers/leds/ledtrig-backlight.c |    4 ++--
 drivers/leds/ledtrig-gpio.c      |    2 +-
 include/linux/leds.h             |   17 +++++++++++++++++
 30 files changed, 164 insertions(+), 158 deletions(-)
