Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0HCBqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:46:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51746 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0HCBqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=sq5r+avZrjQyq1BqYy0T83veW8GOkKA+706DCO3p8iqe0kJ1BgOT+XyOF6woQN/eQC
         eV6oY24ZdDXyBaiagusTj4npgjYe3o5mKKGrZU4nxRxH4lGB46+fD9/hGaxvRlWMTdl9
         Z0IKvw8VluQ97wcQAWr6SINX70kYk3+DigcZU=
Date: Mon, 2 Aug 2010 18:46:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.36-rc0
Message-ID: <20100803014608.GA3436@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
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

Anatolij Gustschin (2):
      Input: ads7846 - allow specifying irq trigger type in platform data
      Input: ads7846 - extend the driver for ads7845 controller support

Axel Lin (3):
      Input: wistron_btns - fix a memory leak in wb_module_init error path
      Input: atlas_btns - adds a missing owner field for atlas_acpi_driver
      Input: atlas_btns - fix mixing acpi_status and int for return value

Chris Bagwell (2):
      Input: synaptics - only report width on hardware that supports it
      Input: synaptics - set min/max for finger width

Chris Merrett (1):
      Input: xpad - add product ID for Hori Fighting Stick EX2

Christoph Egger (1):
      Input: i8042 - remove SPRUCE support

Christoph Fritz (1):
      Input: xpad - remove mouse buttons and axes for dance pads

Dan Carpenter (2):
      Input: lm8323 - fix error handling in lm8323_probe()
      Input: adxl34x - fix leak and use after free

Dmitry Torokhov (11):
      Input: usbtouchscreen - reduce number fo be16_to_cpu conversions
      Input: ad7879 - use threaded IRQ
      Input: ad7879 - add open and close methods
      Input: adxl34 - make enable/disable separate from suspend/resume
      Input: ads7846 - do not allow altering platform data
      Input: atlas_btns - switch to using pr_err() and friends
      Input: fix signedness warning in input_set_keycode()
      Input: change input handlers to use bool when possible
      Input: evdev - signal that device is writable in evdev_poll()
      Input: i8042 - reset keyboard controller wehen resuming from S2R
      Input: adp5588-keypad - fix NULL dereference in adp5588_gpio_add()

Grazvydas Ignotas (1):
      Input: gpio-keys - add gpiolib debounce support

Henrik Rydberg (7):
      Input: evdev - convert to dynamic event buffer
      Input: evdev - use driver hint to compute size of event buffer
      Input: bcm5974 - set the average number of events per MT event packet
      Input: hid-input - use a larger event buffer for MT devices
      Input: evdev - never leave the client buffer empty after write
      Input: introduce MT event slots
      Input: document the MT event slot protocol

Jiri Slaby (1):
      Input: tps6507x-ts - remove unneeded NULL test

Joonyoung Shim (3):
      Input: mcs - Add MCS touchkey driver
      Input: Add ATMEL QT602240 touchscreen driver
      Input: samsung-keypad - Add samsung keypad driver

Julien Moutinho (1):
      Input: mousedev - signal that device is writable in mousedev_poll()

Lars-Peter Clausen (1):
      Input: Add pwm beeper driver

Luo Jinghua (1):
      Input: bcm5974 - turn wellspring mode off if failed to start traffic

Luotao Fu (1):
      Input: matrix_keypad - add support for clustered irq

Markus Lehtonen (1):
      Input: twl4030-pwrbutton - replace __devinit with __init

Michael Hennerich (5):
      Input: add driver for ADXL345/346 Digital Accelerometers
      Input: adxl34x - add support for ADXL346 orientation sensing
      Input: ad7879 - use i2c_smbus_read_i2c_block_data() to lower overhead
      Input: ad7879 - fix spi word size to 16 bit
      Input: ad7879 - report EV_KEY/BTN_TOUCH events

Mike Frysinger (1):
      Input: ad7879 - split bus logic out

Oliver Neukum (4):
      Input: release pressed keys when resuming device
      Input: usbtouchscreen - implement basic suspend/resume
      Input: usbtouchscreen - implement runtime power management
      Input: usbtouchscreen - implement reset_resume

Petr Štetiar (2):
      Input: usbtouchscreen - add support for ET&T TC4UM touchscreen controller
      HID - blacklist ET&T TC4UH touchscreen controller

Ping Cheng (1):
      Input: wacom - add support for DTU2231 and DTU1631

Samuel Thibault (1):
      Input: keyboard - also match braille-only keyboards

Samuli Konttila (1):
      Input: cy8ctmg110 - capacitive touchscreen support

Xiaolong CHEN (1):
      Input: adp5588-keys - support GPI events for ADP5588 devices

Xiaolong Chen (1):
      Input: adp5588-keys - export unused GPIO pins


Diffstat:
--------

 Documentation/input/multi-touch-protocol.txt |  218 +++--
 arch/arm/plat-samsung/include/plat/keypad.h  |   43 +
 drivers/char/keyboard.c                      |    6 +-
 drivers/hid/hid-core.c                       |    1 +
 drivers/hid/hid-ids.h                        |    1 +
 drivers/hid/hid-input.c                      |    3 +
 drivers/input/evdev.c                        |   54 +-
 drivers/input/input.c                        |  182 +++--
 drivers/input/joydev.c                       |    7 +-
 drivers/input/joystick/xpad.c                |  108 ++-
 drivers/input/keyboard/Kconfig               |   21 +
 drivers/input/keyboard/Makefile              |    2 +
 drivers/input/keyboard/adp5588-keys.c        |  351 +++++++-
 drivers/input/keyboard/gpio_keys.c           |   19 +-
 drivers/input/keyboard/lm8323.c              |   12 +-
 drivers/input/keyboard/matrix_keypad.c       |  108 ++-
 drivers/input/keyboard/mcs_touchkey.c        |  239 +++++
 drivers/input/keyboard/samsung-keypad.c      |  491 +++++++++
 drivers/input/misc/Kconfig                   |   48 +
 drivers/input/misc/Makefile                  |    4 +
 drivers/input/misc/adxl34x-i2c.c             |  163 +++
 drivers/input/misc/adxl34x-spi.c             |  145 +++
 drivers/input/misc/adxl34x.c                 |  915 +++++++++++++++++
 drivers/input/misc/adxl34x.h                 |   30 +
 drivers/input/misc/atlas_btns.c              |   38 +-
 drivers/input/misc/pwm-beeper.c              |  199 ++++
 drivers/input/misc/twl4030-pwrbutton.c       |   12 +-
 drivers/input/misc/wistron_btns.c            |    4 +-
 drivers/input/mouse/bcm5974.c                |   23 +-
 drivers/input/mouse/synaptics.c              |    8 +-
 drivers/input/mousedev.c                     |   15 +-
 drivers/input/serio/i8042-ppcio.h            |   75 --
 drivers/input/serio/i8042.c                  |   65 +-
 drivers/input/tablet/wacom_wac.c             |   44 +
 drivers/input/tablet/wacom_wac.h             |    1 +
 drivers/input/touchscreen/Kconfig            |   67 +-
 drivers/input/touchscreen/Makefile           |    6 +-
 drivers/input/touchscreen/ad7879-i2c.c       |  143 +++
 drivers/input/touchscreen/ad7879-spi.c       |  198 ++++
 drivers/input/touchscreen/ad7879.c           |  625 ++++--------
 drivers/input/touchscreen/ad7879.h           |   30 +
 drivers/input/touchscreen/ads7846.c          |  206 +++-
 drivers/input/touchscreen/cy8ctmg110_ts.c    |  363 +++++++
 drivers/input/touchscreen/mcs5000_ts.c       |    6 +-
 drivers/input/touchscreen/qt602240_ts.c      | 1401 ++++++++++++++++++++++++++
 drivers/input/touchscreen/tps6507x-ts.c      |    3 -
 drivers/input/touchscreen/usbtouchscreen.c   |  215 +++--
 include/linux/i2c/adp5588.h                  |   37 +
 include/linux/i2c/mcs.h                      |   34 +
 include/linux/i2c/mcs5000_ts.h               |   24 -
 include/linux/i2c/qt602240_ts.h              |   38 +
 include/linux/input.h                        |   60 ++-
 include/linux/input/adxl34x.h                |  349 +++++++
 include/linux/input/cy8ctmg110_pdata.h       |   10 +
 include/linux/input/matrix_keypad.h          |    6 +
 include/linux/spi/ads7846.h                  |    3 +-
 56 files changed, 6496 insertions(+), 983 deletions(-)
 create mode 100644 arch/arm/plat-samsung/include/plat/keypad.h
 create mode 100644 drivers/input/keyboard/mcs_touchkey.c
 create mode 100644 drivers/input/keyboard/samsung-keypad.c
 create mode 100644 drivers/input/misc/adxl34x-i2c.c
 create mode 100644 drivers/input/misc/adxl34x-spi.c
 create mode 100644 drivers/input/misc/adxl34x.c
 create mode 100644 drivers/input/misc/adxl34x.h
 create mode 100644 drivers/input/misc/pwm-beeper.c
 create mode 100644 drivers/input/touchscreen/ad7879-i2c.c
 create mode 100644 drivers/input/touchscreen/ad7879-spi.c
 create mode 100644 drivers/input/touchscreen/ad7879.h
 create mode 100644 drivers/input/touchscreen/cy8ctmg110_ts.c
 create mode 100644 drivers/input/touchscreen/qt602240_ts.c
 create mode 100644 include/linux/i2c/mcs.h
 delete mode 100644 include/linux/i2c/mcs5000_ts.h
 create mode 100644 include/linux/i2c/qt602240_ts.h
 create mode 100644 include/linux/input/adxl34x.h
 create mode 100644 include/linux/input/cy8ctmg110_pdata.h

-- 
Dmitry

