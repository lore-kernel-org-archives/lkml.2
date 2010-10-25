Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0JYFR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 01:17:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41977 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0JYFRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 01:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=f/Wj5ZVgSalx1MFuCi4S6N9iwih1WxS9MFOq3LWuAUUgMLyNEccs0Af4y1mTGVUkae
         BHgzLkdX9hUQ7tehP8hlVzx2FrnsLfjxF8z47KMw/o/0BOrNw1j1UNuNwxk3C6HkHxw8
         xR/0FYeT2Na/oDm0RyaiVS9vrBJksnPDr89+E=
Date: Sun, 24 Oct 2010 22:17:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.37-rc0
Message-ID: <20101025051716.GD1438@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Abraham Arce (4):
      Input: add support for OMAP4 keyboard controller
      Input: omap4-keypad - use platform device helpers
      Input: omap4-keypad - SYSCONFIG register configuration
      Input: omap4-keypad - fix interrupt line configuration

Alan Cox (1):
      Staging: mrst_touchscreen - clean up input side

Alek Du (1):
      Staging: mrst-touchscreen - register platform interface

Andy Ross (1):
      Staging: mrst-touchscreen - simplify en/disable of interrupts for NEC

Arjan van de Ven (1):
      Staging: mrst-touchscreen - fix channel allocation

Axel Lin (7):
      Input: s3c2410_ts - fix s3c2410ts_probe error path
      Input: tps6507x-ts - add missing call to platform_set_drvdata()
      Input: tps6507x-ts - properly unregister input device on removal
      Input: tsc2007 - fix a redundant assignment for pdata
      Input: stmpe-ts - remove input_free_device() in stmpe_ts_remove()
      Input: stmpe-ts - return -ENOMEM when memory allocation fails
      Input: wm97xx-core - simplify error path in wm97xx_probe()

Chris Bagwell (4):
      Input: wacom - request tablet data for Bamboo Pens
      Input: wacom - move Bamboo Touch irq to its own function
      Input: wacom - add support for Bamboo Pen
      Input: wacom - disable Bamboo touchpad when pen is being used

Christoph Fritz (1):
      Input: i8042 - use unsigned char for 0x90

Davidlohr Bueso (1):
      Input: return -ENOMEM in select drivers when memory allocation fails

Dmitry Eremin-Solenikov (2):
      Input: serio - support multiple child devices per single parent
      Input: serio - add support for PS2Mult multiplexer protocol

Dmitry Torokhov (21):
      Staging: mrst_touchscreen - more fixes
      Input: mrst-touchscreen - move out of staging
      Input: fix a few typos
      Input: sparse-keymap - switch to using new keycode interface
      Input: media/IR - switch to using new keycode interface
      Input: hid-input - switch to using new keycode interface
      Input: serio - do not include linux/freezer.h
      Input: serio_driver - mark id_table and description as const
      Input: serio_driver - drop private pointer
      Input: gameport_driver - mark description as const pointer
      Input: gameport_driver - drop private pointer
      Input: ati_remote2 - switch to using new keycode interface
      Input: hid-input - allow mapping unknown usages
      Input: fm801-gp - add missing call to pci_disable_device()
      Input: sysrq - add locking to sysrq_filter()
      Input: emu10k1 - do not leave device enabled when probe fails
      Input: twl4030_keypad - fix error handling path
      Input: synaptics - simplify pass-through port handling
      Input: wacom - properly enable runtime PM
      Input: ad7877 - use attribute group to control visibility of attributes
      Input: ad7877 - switch to using threaded IRQ

Dzianis Kahanovich (1):
      Input: hil_kbd - add missing MODULE_DEVICE_TABLE()

Eric Millbrandt (1):
      Input: wm97xx-core - add retries to wm97xx_read_aux_adc

Henrik Rydberg (4):
      Input: wacom - add fuzz parameters to features
      Input: wacom - collect device quirks into single function
      Input: wacom - add support for the Bamboo Touch trackpad
      Input: wacom - add a quirk for low resolution Bamboo devices

Hitoshi Mitake (1):
      Input: mousedev - correct lockdep annotation

James Ketrenos (1):
      Input: cy8ctmg110 - add fuzz to ABS_X and ABS_Y to remove jitter

Jason Wang (1):
      Input: ads7846 - switch to using threaded IRQ

Kevin Wells (1):
      Input: add LPC32xx touchscreen controller driver

Mauro Carvalho Chehab (1):
      Input: add support for large scancodes

Michael Hennerich (4):
      Input: ad7877 - implement specified chip select behavior
      Input: ad7877 - implement EV_KEY:BTN_TOUCH reporting
      Input: ad7877 - filter events where pressure is beyond the maximum
      Input: adp5588-keys - use more obvious i2c_device_id name string

Mike Turquette (1):
      Input: omap4-keypad - wake-up on events & long presses

Naveen Kumar Gaddipati (1):
      Input: add ROHM BU21013 touch panel controller support

Nicolas Kaiser (1):
      Input: ab8500-ponkey - fix IRQ freeing in error path

Peter Hutterer (3):
      Input: wacom_w8001 - send BTN_TOOL_PEN/RUBBER and BTN_STYLUS events
      Input: wacom_w8001 - support (and ignore) touch tablets
      Input: wacom_w8001 - add multitouch slot support

Ping Cheng (2):
      Input: wacom - parse the Bamboo device family
      Input: wacom - specify Cinitq supported tools

Rahul Ruikar (1):
      Input: emu10k1-gp - add missing calls to pci_disable_device()

Sundar Iyer (2):
      Input: add support for Nomadik SKE keypad controller
      ux500 - add platform data for Nomadik SKE keypad controller

Sundar R Iyer (1):
      Input: add support for PowerOn button on the AB8500 MFD

Tejun Heo (1):
      Input: hp680_ts_input - use cancel_delayed_work_sync()

Xing Wei (3):
      Input: add support for Hanwang tablets
      Input: hanwang - make compatible with xf86-input-wacom driver
      Input: hanwang - add support for Art Master HD 5012 tablet


Diffstat:
--------

 arch/arm/mach-ux500/board-mop500.c                 |  129 +++
 arch/arm/mach-ux500/clock.c                        |    1 +
 arch/arm/mach-ux500/devices-db8500.c               |   20 +
 arch/arm/mach-ux500/include/mach/devices.h         |    1 +
 arch/arm/mach-ux500/pins-db8500.h                  |   32 +-
 arch/arm/plat-nomadik/include/plat/ske.h           |   50 ++
 arch/arm/plat-omap/include/plat/omap4-keypad.h     |   14 +
 drivers/char/keyboard.c                            |   31 +-
 drivers/char/sysrq.c                               |   15 +-
 drivers/hid/hid-core.c                             |    5 +
 drivers/hid/hid-ids.h                              |    4 +
 drivers/hid/hid-input.c                            |  108 ++-
 drivers/input/evdev.c                              |  100 ++-
 drivers/input/gameport/emu10k1-gp.c                |   44 +-
 drivers/input/gameport/fm801-gp.c                  |   10 +-
 drivers/input/input.c                              |  198 ++++--
 drivers/input/keyboard/Kconfig                     |   19 +
 drivers/input/keyboard/Makefile                    |    2 +
 drivers/input/keyboard/adp5588-keys.c              |    2 +-
 drivers/input/keyboard/hil_kbd.c                   |    2 +
 drivers/input/keyboard/nomadik-ske-keypad.c        |  408 +++++++++
 drivers/input/keyboard/omap4-keypad.c              |  318 +++++++
 drivers/input/keyboard/twl4030_keypad.c            |    7 +-
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/ab8500-ponkey.c                 |  157 ++++
 drivers/input/misc/ati_remote2.c                   |   93 ++-
 drivers/input/misc/powermate.c                     |    2 +-
 drivers/input/mouse/elantech.c                     |    2 +-
 drivers/input/mouse/psmouse-base.c                 |    4 +-
 drivers/input/mouse/synaptics.c                    |   38 +-
 drivers/input/mouse/synaptics.h                    |    2 +
 drivers/input/mouse/trackpoint.c                   |    2 +-
 drivers/input/mousedev.c                           |    2 +-
 drivers/input/serio/Kconfig                        |    9 +
 drivers/input/serio/Makefile                       |    1 +
 drivers/input/serio/i8042.c                        |    2 +-
 drivers/input/serio/ps2mult.c                      |  318 +++++++
 drivers/input/serio/serio.c                        |  125 ++-
 drivers/input/sparse-keymap.c                      |   81 ++-
 drivers/input/tablet/Kconfig                       |   11 +
 drivers/input/tablet/Makefile                      |    1 +
 drivers/input/tablet/hanwang.c                     |  446 ++++++++++
 drivers/input/tablet/wacom.h                       |    1 +
 drivers/input/tablet/wacom_sys.c                   |   77 ++-
 drivers/input/tablet/wacom_wac.c                   |  253 ++++++-
 drivers/input/tablet/wacom_wac.h                   |   15 +
 drivers/input/touchscreen/Kconfig                  |   34 +
 drivers/input/touchscreen/Makefile                 |    3 +
 drivers/input/touchscreen/ad7877.c                 |  144 ++--
 drivers/input/touchscreen/ads7846.c                |  886 ++++++++++----------
 drivers/input/touchscreen/bu21013_ts.c             |  648 ++++++++++++++
 drivers/input/touchscreen/cy8ctmg110_ts.c          |    4 +-
 drivers/input/touchscreen/hp680_ts_input.c         |    6 +-
 drivers/input/touchscreen/intel-mid-touch.c        |  687 +++++++++++++++
 drivers/input/touchscreen/lpc32xx_ts.c             |  411 +++++++++
 drivers/input/touchscreen/s3c2410_ts.c             |    2 +-
 drivers/input/touchscreen/stmpe-ts.c               |   11 +-
 drivers/input/touchscreen/tps6507x-ts.c            |    3 +-
 drivers/input/touchscreen/tsc2007.c                |    2 +-
 drivers/input/touchscreen/wacom_w8001.c            |  185 ++++-
 drivers/input/touchscreen/wm97xx-core.c            |   18 +-
 drivers/media/IR/ir-keytable.c                     |  393 ++++++---
 drivers/mfd/ab8500-core.c                          |   20 +
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/mrst-touchscreen/Kconfig           |    7 -
 drivers/staging/mrst-touchscreen/Makefile          |    3 -
 drivers/staging/mrst-touchscreen/TODO              |    2 -
 drivers/staging/mrst-touchscreen/intel-mid-touch.c |  864 -------------------
 include/linux/gameport.h                           |    4 +-
 include/linux/input.h                              |   57 +-
 include/linux/input/bu21013.h                      |   44 +
 include/linux/serio.h                              |   10 +-
 include/media/rc-map.h                             |    2 +-
 75 files changed, 5781 insertions(+), 1845 deletions(-)
 create mode 100644 arch/arm/plat-nomadik/include/plat/ske.h
 create mode 100644 arch/arm/plat-omap/include/plat/omap4-keypad.h
 create mode 100644 drivers/input/keyboard/nomadik-ske-keypad.c
 create mode 100644 drivers/input/keyboard/omap4-keypad.c
 create mode 100644 drivers/input/misc/ab8500-ponkey.c
 create mode 100644 drivers/input/serio/ps2mult.c
 create mode 100644 drivers/input/tablet/hanwang.c
 create mode 100644 drivers/input/touchscreen/bu21013_ts.c
 create mode 100644 drivers/input/touchscreen/intel-mid-touch.c
 create mode 100644 drivers/input/touchscreen/lpc32xx_ts.c
 delete mode 100644 drivers/staging/mrst-touchscreen/Kconfig
 delete mode 100644 drivers/staging/mrst-touchscreen/Makefile
 delete mode 100644 drivers/staging/mrst-touchscreen/TODO
 delete mode 100644 drivers/staging/mrst-touchscreen/intel-mid-touch.c
 create mode 100644 include/linux/input/bu21013.h

-- 
Dmitry

