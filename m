Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab1G0IEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:04:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46201 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1G0IEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:04:46 -0400
Date: Wed, 27 Jul 2011 01:04:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.1-rc0
Message-ID: <20110727080439.GA3535@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Aristeu Rozanski (1):
      Input: wacom - use only one interface with DTU-2231

Axel Lin (11):
      Input: tnetv107x-keypad - fix MODULE_ALIAS
      Input: tnetv107x-ts - fix MODULE_ALIAS
      Input: gpio_keys - fix a memory leak
      Input: atkbd - make dmi callback functions return 1
      Input: lifebook - make dmi callback functions return 1
      Input: cy8ctmg110_ts - fix checking return value of i2c_master_send
      Input: cy8ctmg110_ts - constify i2c_device_id table
      Input: cy8ctmg110_ts - set reset_pin and irq_pin from platform data
      Input: pmic8xxx-keypad - fix a leak of the IRQ during init failure
      Input: hp_sdc - staticize hp_sdc_kicker()
      Input: intel-mid-touch - remove pointless checking for variable 'found'

Chris Hudson (1):
      Input: add support for Kionix KXTJ9 accelerometer

Chris Moeller (1):
      Input: xpad - enable rumble support for XBox360 Wireless Controllers

Dan Carpenter (2):
      Input: kxtj9 - fix bug in probe()
      Input: kxtj9 - fix locking typo in kxtj9_set_poll()

Daniel Kurtz (4):
      Input: synaptics - set resolution for MT_POSITION_X/Y axes
      Input: synaptics - fuzz position for touchpad with reduced filtering
      Input: synaptics - rename set_slot to be more descriptive
      Input: synaptics - process button bits in AGM packets

David Jander (3):
      Input: gpio_keys - switch to using threaded IRQs
      Input: gpio_keys - move to late_initcall
      Input: gpio_keys - add support for device-tree platform data

Dmitry Torokhov (4):
      Input: sh_keysc - fix compile warning
      Input: synaptics - set minimum coordinates as reported by firmware
      Input: gpio_keys - switch to using SIMPLE_DEV_PM_OPS
      Input: synaptics - fix reporting of min coordinates

Edwin van Vliet (1):
      Input: aiptek - remove double define

Eric Miao (1):
      Input: add support for mma8450 accelerometer

Felipe Balbi (1):
      Input: lm8323 - convert to threaded IRQ

Hans-Christian Egtvedt (1):
      Input: update author email for gpio_mouse, at32psif, and atmel-wm97xx

Igor Grinberg (1):
      Input: ads7846 - cleanup GPIO initialization

Iiro Valkonen (2):
      Input: atmel_mxt_ts - update object list
      Input: atmel_mxt_ts - handle objects with multiple instances correctly

Jesper Juhl (1):
      Input: remove unneeded version.h includes

Jiejing Zhang (1):
      Input: mpr121 - improve sensibility of touch key

Joseph Lai (1):
      Input: add a driver to support InvenSense mpu3050 gyroscope chip

Leigh Brown (1):
      Input: lm8323 - use oneshot level triggered interrupts

Magnus Hörlin (1):
      Input: xpad - add support for two more dance pads and a guitar

Ping Cheng (7):
      Input: wacom - Cintiq 21UX2 does not have menu strips
      Input: wacom - Wacom Bamboo Pen D4 has 1024 pressure levels
      Input: wacom - add 3 new models - 6A, 6B, and 97
      Input: wacom - remove BTN_TOOL_FINGER for pad
      Input: wacom - add serial number for Graphire4 and old Bamboo
      Input: wacom - update Graphire4 and old Bamboo tablet buttons
      Input: wacom - cleanup a return value for the old Bamboo

Rakesh Iyer (1):
      Input: tegra-kbc - enable key autorepeat

Simon Budig (1):
      Input: add guarding parentheses to macros

Stefano Stabellini (1):
      Input: xen-kbdfront - enable driver for HVM guests

Wolfram Sang (4):
      Input: qt1070 - remove obsolete cleanup for clientdata
      Input: wm97xx - remove redundant define
      Input: wm97xx - refactor channel selection in poll_sample()
      Input: wm97xx - mark channels which need pen_down


Diffstat:
--------

 .../devicetree/bindings/gpio/gpio_keys.txt         |   36 +
 drivers/input/joystick/xpad.c                      |   31 +-
 drivers/input/keyboard/adp5588-keys.c              |    1 -
 drivers/input/keyboard/adp5589-keys.c              |    1 -
 drivers/input/keyboard/atkbd.c                     |    4 +-
 drivers/input/keyboard/gpio_keys.c                 |  166 ++++-
 drivers/input/keyboard/lm8323.c                    |   23 +-
 drivers/input/keyboard/mpr121_touchkey.c           |   16 +-
 drivers/input/keyboard/pmic8xxx-keypad.c           |    8 +-
 drivers/input/keyboard/qt1070.c                    |    2 -
 drivers/input/keyboard/sh_keysc.c                  |    2 +-
 drivers/input/keyboard/tegra-kbc.c                 |    2 +-
 drivers/input/keyboard/tnetv107x-keypad.c          |    2 +-
 drivers/input/misc/Kconfig                         |   38 ++
 drivers/input/misc/Makefile                        |    4 +-
 drivers/input/misc/bfin_rotary.c                   |    1 -
 drivers/input/misc/kxtj9.c                         |  671 ++++++++++++++++++++
 drivers/input/misc/mma8450.c                       |  256 ++++++++
 drivers/input/misc/mpu3050.c                       |  376 +++++++++++
 drivers/input/misc/xen-kbdfront.c                  |    2 +-
 drivers/input/mouse/gpio_mouse.c                   |    2 +-
 drivers/input/mouse/lifebook.c                     |    4 +-
 drivers/input/mouse/pxa930_trkball.c               |    1 -
 drivers/input/mouse/sentelic.c                     |    1 -
 drivers/input/mouse/synaptics.c                    |  107 ++--
 drivers/input/mouse/synaptics.h                    |   18 +-
 drivers/input/serio/at32psif.c                     |    2 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/tablet/aiptek.c                      |    1 -
 drivers/input/tablet/wacom_wac.c                   |   68 ++-
 drivers/input/touchscreen/ads7846.c                |   15 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |    4 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |  190 +++---
 drivers/input/touchscreen/cy8ctmg110_ts.c          |    8 +-
 drivers/input/touchscreen/intel-mid-touch.c        |   15 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |    6 +-
 drivers/input/touchscreen/tnetv107x-ts.c           |    2 +-
 drivers/input/touchscreen/wm9705.c                 |   25 +-
 drivers/input/touchscreen/wm9712.c                 |   27 +-
 drivers/input/touchscreen/wm9713.c                 |   25 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |    6 +-
 include/linux/input.h                              |    6 +-
 include/linux/input/kxtj9.h                        |   70 ++
 include/linux/wm97xx.h                             |   13 +-
 44 files changed, 1943 insertions(+), 317 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_keys.txt
 create mode 100644 drivers/input/misc/kxtj9.c
 create mode 100644 drivers/input/misc/mma8450.c
 create mode 100644 drivers/input/misc/mpu3050.c
 create mode 100644 include/linux/input/kxtj9.h

-- 
Dmitry

