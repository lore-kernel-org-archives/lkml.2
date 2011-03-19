Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1CSGpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 02:45:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36152 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1CSGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 02:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tKjDcU8PInbULEHU5ylAf/FCCq6n15VrRFaaoyIk5IbsGMjvccWgDQ2BFZA9TTgzFl
         JzM6/Sz9L2HW0jHL8t3JVc11+2DMNgGN0lhZhHngjGJloCd1RO3GV6UJ3E2/ES+dSReF
         qGJbHc4yLAC/u4prIp7a6c62nQkYNtRbYY3DY=
Date: Fri, 18 Mar 2011 23:44:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.39-rc0
Message-ID: <20110319064447.GA7298@core.coreip.homeip.net>
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

to receive updates for the input subsystem. Purely driver changes.

Changelog:
---------

Abraham Arce (1):
      Input: omap4-keypad - wire up runtime PM handling

Andy Botting (1):
      Input: bcm5974 - add support for MacBookPro8

Bo Shen (1):
      Input: add Atmel AT42QT1070 keypad driver

Chris Leech (1):
      Input: atmel_mxt_ts - add mXT224 identifier to id_table

Dan Carpenter (1):
      Input: uinput - reversed test in uinput_setup_device()

Daniel De Graaf (1):
      Input: xen-kbdfront - add grant reference for shared page

David Herrmann (1):
      Input: uinput - fix setting up device name

Dmitry Torokhov (24):
      Input: dvb-usb-remote - convert to new style of get/setkeycode
      Input: switch completely over to the new versions of get/setkeycode
      Input: input-polldev - fix a couple of typos
      Input: qt602240_ts - rename to atmel_mxt_ts
      Input: uinput - use memdup_user() and friends
      Input: tc3589x-keypad - fix 'double const' warning
      Input: xen-kbdfront - move to drivers/input/misc
      Input: tsc2005 - use spi_get/set_drvdata()
      Input: tsc2005 - convert to using dev_pm_ops
      Input: tsc2005 - remove incorrect module alias
      Input: tsc2005 - remove driver banner message
      Input: tsc2005 - add module description
      Input: tsc2005 - clear driver data after unbinding
      Input: tsc2005 - set up parent device
      Input: tsc2005 - set up bus type in input device
      Input: tsc2005 - rework driver initialization code
      Input: tsc2005 - hide selftest attribute if we can't reset
      Input: tsc2005 - use true/false for boolean variables
      Input: tsc2005 - do not use 0 in place of NULL
      Input: tsc2005 - don't use work for 'pen up' handling
      Input: tsc2005 - do not rearm timer in hardirq handler
      Input: tsc2005 - handle read errors from SPI layer
      Input: tsc2005 - add open/close
      Input: tsc2005 - remove 'disable' sysfs attribute

Henrik Rydberg (1):
      Input: bcm5974 - Report button also for zero fingers

HeungJun Kim (1):
      Input: mcs_touchkey - add shutdown handler

Heungjun Kim (1):
      Input: mcs_touchkey - add support for suspend/resume

Iiro Valkonen (5):
      Input: atmel_mxt_ts - get rid of qt602240 prefixes in names
      Input: atmel_mxt_ts - read whole message to make CHG low
      Input: atmel_mxt_ts - allow board code to suppliy controller config
      Input: atmel_mxt_ts - allow board code to specify IRQ flags
      Input: atmel_mxt_ts - remove matrix size check

Joonyoung Shim (2):
      Input: atmel_mxt_ts - remove firmware version check
      Input: atmel_mxt_ts - add objects of mXT1386 chip

Lauri Leukkunen (1):
      Input: introduce tsc2005 driver

Magnus Damm (1):
      Input: tca6416-keypad - suspend/resume wakeup support

Mark Brown (15):
      Input: ad7877 - convert to dev_pm_ops
      Input: ad7879 - convert SPI to dev_pm_ops
      Input: ads7846 - convert to dev_pm_ops
      Input: wm831x - add driver for Wolfson WM831x PMIC touchscreen controllers
      Input: wm831x-ts - remove use of ternary operator
      Input: ad714x-i2c - convert to dev_pm_ops
      Input: ad714x-spi - convert to dev_pm_ops
      Input: lm8323 - convert to dev_pm_ops
      Input: max7359 - convert to dev_pm_ops
      Input: adxl34x-i2c - convert to dev_pm_ops
      Input: adxl34x-spi - convert to dev_pm_ops
      Input: adxl34x - fix references to adx134x
      Input: synaptics_i2c - convert to dev_pm_ops
      Input: wm831x-ts - default pressure measurements on
      Input: wm831x-ts - ensure the controller is in a known state on open

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Peter Korsgaard (1):
      Input: evdev - fix evdev_write return value on partial writes

Ping Cheng (4):
      Input: wacom - do not send 2FGT Tablet PC events in TAP format
      Input: wacom - process pen data in its own routine
      Input: wacom - support one finger touch the touchscreen way
      Input: wacom - support 2FGT in MT format


Diffstat:
--------

 arch/arm/mach-s5pv210/mach-goni.c                  |    8 +-
 drivers/hid/hid-apple.c                            |    6 +
 drivers/hid/hid-core.c                             |    6 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/hid-input.c                            |    4 +-
 drivers/input/Kconfig                              |   10 -
 drivers/input/Makefile                             |    2 -
 drivers/input/evdev.c                              |   10 +-
 drivers/input/input-polldev.c                      |    4 +-
 drivers/input/input.c                              |   55 +-
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/lm8323.c                    |   15 +-
 drivers/input/keyboard/max7359_keypad.c            |   17 +-
 drivers/input/keyboard/mcs_touchkey.c              |   57 +-
 drivers/input/keyboard/omap4-keypad.c              |   74 +-
 drivers/input/keyboard/qt1070.c                    |  276 ++++
 drivers/input/keyboard/tc3589x-keypad.c            |   22 +-
 drivers/input/keyboard/tca6416-keypad.c            |   28 +
 drivers/input/misc/Kconfig                         |   13 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/ad714x-i2c.c                    |   17 +-
 drivers/input/misc/ad714x-spi.c                    |   17 +-
 drivers/input/misc/adxl34x-i2c.c                   |   16 +-
 drivers/input/misc/adxl34x-spi.c                   |   20 +-
 drivers/input/misc/ati_remote2.c                   |    4 +-
 drivers/input/misc/uinput.c                        |   48 +-
 drivers/input/{ => misc}/xen-kbdfront.c            |   83 +-
 drivers/input/mouse/bcm5974.c                      |   28 +-
 drivers/input/mouse/synaptics_i2c.c                |   16 +-
 drivers/input/sparse-keymap.c                      |    4 +-
 drivers/input/tablet/wacom_sys.c                   |   12 +-
 drivers/input/tablet/wacom_wac.c                   |  247 ++---
 drivers/input/tablet/wacom_wac.h                   |    6 +-
 drivers/input/touchscreen/Kconfig                  |   45 +-
 drivers/input/touchscreen/Makefile                 |    4 +-
 drivers/input/touchscreen/ad7877.c                 |   19 +-
 drivers/input/touchscreen/ad7879-spi.c             |   17 +-
 drivers/input/touchscreen/ads7846.c                |   16 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           | 1211 +++++++++++++++++
 drivers/input/touchscreen/qt602240_ts.c            | 1406 --------------------
 drivers/input/touchscreen/tsc2005.c                |  756 +++++++++++
 drivers/input/touchscreen/wm831x-ts.c              |  368 +++++
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |  109 +-
 drivers/media/rc/rc-main.c                         |    4 +-
 .../linux/i2c/{qt602240_ts.h => atmel_mxt_ts.h}    |   34 +-
 include/linux/i2c/mcs.h                            |    1 +
 include/linux/input-polldev.h                      |    4 +-
 include/linux/input.h                              |   12 +-
 include/linux/mfd/wm831x/pdata.h                   |    3 +-
 include/linux/spi/tsc2005.h                        |   41 +
 51 files changed, 3284 insertions(+), 1906 deletions(-)
 create mode 100644 drivers/input/keyboard/qt1070.c
 rename drivers/input/{ => misc}/xen-kbdfront.c (85%)
 create mode 100644 drivers/input/touchscreen/atmel_mxt_ts.c
 delete mode 100644 drivers/input/touchscreen/qt602240_ts.c
 create mode 100644 drivers/input/touchscreen/tsc2005.c
 create mode 100644 drivers/input/touchscreen/wm831x-ts.c
 rename include/linux/i2c/{qt602240_ts.h => atmel_mxt_ts.h} (50%)
 create mode 100644 include/linux/spi/tsc2005.h

-- 
Dmitry

