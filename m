Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2AIJIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:08:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35978 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2AIJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:08:04 -0500
Date: Mon, 9 Jan 2012 01:07:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.3-rc0
Message-ID: <20120109090759.GA2319@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Axel Lin (4):
      Input: ad7879-i2c - remove redundant MODULE_ALIAS
      Input: samsung-keypad - remove redundant MODULE_ALIAS
      Input: mc13783-pwrbutton - convert to use module_platform_driver()
      Input: keyboard - staticise non-exported symbols

Chris Bagwell (7):
      Input: wacom - cleanup feature report for bamboos
      Input: wacom - remove unused bamboo HID parsing
      Input: wacom - add some comments to wacom_parse_hid
      Input: wacom - relax Bamboo stylus ID check
      Input: wacom - read 3rd gen Bamboo Touch HID data
      Input: wacom - 3rd gen Bamboo P&Touch packet support
      Input: wacom - ignore unwanted bamboo packets

Courtney Cavin (1):
      Input: add driver for Sharp gp2ap002a00f proximity sensor

Daniel Drake (2):
      Input: synaptics - add support for Relative mode
      Input: synaptics - update OLPC XO exclusion

Dima Zavin (3):
      Input: evdev - only allow reading events if a full packet is present
      Input: evdev - if no events and non-block, return EAGAIN not 0
      Input: evdev - do not block waiting for an event if fd is nonblock

Dmitry Torokhov (15):
      Input: i8042 - also perform controller reset when suspending
      Input: samsung-keypad - switch to using SIMPLE_DEV_PM_OPS
      Input: samsung-keypad - enable compiling on other platforms
      Input: ad7879 - consolidate PM methods
      Input: htcpen - switch to DMI-based autoloading
      Input: migor-ts - convert to a threaded IRQ
      Input: migor-ts - use proper client data accessor functions
      Input: migor-ts - rework probe() to simplify error path
      Input: psmouse - make sure we do not use stale methods
      Input: ucb1400_ts - convert to use dev_pm_ops
      Input: ucb1400_ts - set driver owner
      Input: usb1400_ts - add __devinit/__devexit section annotations
      Input: ucb1400_ts - drop inline annotations
      Input: ucb1400_ts - convert to threaded IRQ
      Input: ucb1400-ts - switch to using dev_xxx() for diagnostic messages

Heikki Krogerus (2):
      Input: mpu3050 - ensure we enable interrupts
      Input: mpu3050 - configure the sampling method

Heiko St=FCbner (2):
      Input: add generic GPIO-tilt driver
      Input: add driver for AUO In-Cell touchscreens using pixcir ICs

JJ Ding (8):
      Input: convert obsolete strict_strtox to kstrtox
      Input: elantech - add support for elantech fast command
      Input: elantech - add resolution query support for v4 hardware
      Input: keyboard - use macro module_platform_driver()
      Input: misc - use macro module_platform_driver()
      Input: mouse - use macro module_platform_driver()
      Input: serio - use macro module_platform_driver()
      Input: touchscreen - use macro module_platform_driver()

Jason Gerecke (2):
      Input: wacom - add support for Cintiq 24HD
      Input: wacom - add LED support for Cintiq 24HD

Jianchun Bian (1):
      Input: add driver for pixcir i2c touchscreens

Jonathan Cameron (1):
      Input: ad7879-i2c - use swapped variant of i2c_smbus_read_word_data

Kyle Manna (1):
      Input: tca8418_keypad - initial driver release

Lars-Peter Clausen (1):
      Input: remove redundant spi driver bus initialization

Mark Brown (1):
      Input: samsung-keypad - implement runtime power management support

Michael Gebetsroither (1):
      Input: usbtouchscreen - add ELO IntelliTouch 2700 support

Naga Radhesh (1):
      Input: tc3589x-keypad - add missing kerneldoc

Olof Johansson (2):
      Input: mpu3050 - add of_match table for device-tree probing
      Input: tegra-kbc - add device tree bindings

Rakesh Iyer (1):
      Input: tegra-kbc - report wakeup key for some platforms

Seth Forshee (6):
      Input: ALPS - move protocol information to Documentation
      Input: ALPS - add protocol version field in alps_model_info
      Input: ALPS - remove assumptions about packet size
      Input: ALPS - add support for protocol versions 3 and 4
      Input: ALPS - add semi-MT support for v3 protocol
      Input: ALPS - add documentation for protocol versions 3 and 4

Tai-hwa Liang (1):
      Input: sentelic - document the latest hardware

Zhang Jiejing (1):
      Input: add EETI eGalax I2C capacitive multi touch driver


Diffstat:
--------

 Documentation/ABI/testing/sysfs-driver-wacom       |   17 +-
 .../devicetree/bindings/input/tegra-kbc.txt        |   18 +
 Documentation/input/alps.txt                       |  188 ++++
 Documentation/input/gpio-tilt.txt                  |  103 ++
 Documentation/input/sentelic.txt                   |  364 +++++++-
 arch/arm/mach-tegra/include/mach/kbc.h             |    1 +
 arch/arm/plat-samsung/include/plat/keypad.h        |   27 +-
 drivers/input/evdev.c                              |   20 +-
 drivers/input/input-polldev.c                      |    8 +-
 drivers/input/keyboard/Kconfig                     |   21 +-
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/adp5520-keys.c              |   13 +-
 drivers/input/keyboard/amikbd.c                    |   15 +-
 drivers/input/keyboard/atkbd.c                     |   40 +-
 drivers/input/keyboard/bf54x-keys.c                |   16 +-
 drivers/input/keyboard/davinci_keyscan.c           |   13 +-
 drivers/input/keyboard/ep93xx_keypad.c             |   14 +-
 drivers/input/keyboard/gpio_keys_polled.c          |   14 +-
 drivers/input/keyboard/imx_keypad.c                |   14 +-
 drivers/input/keyboard/jornada680_kbd.c            |   14 +-
 drivers/input/keyboard/jornada720_kbd.c            |   14 +-
 drivers/input/keyboard/lm8323.c                    |   11 +-
 drivers/input/keyboard/matrix_keypad.c             |   14 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |   15 +-
 drivers/input/keyboard/omap-keypad.c               |   15 +-
 drivers/input/keyboard/omap4-keypad.c              |   13 +-
 drivers/input/keyboard/opencores-kbd.c             |   13 +-
 drivers/input/keyboard/pmic8xxx-keypad.c           |   13 +-
 drivers/input/keyboard/pxa27x_keypad.c             |   14 +-
 drivers/input/keyboard/pxa930_rotary.c             |   13 +-
 drivers/input/keyboard/samsung-keypad.c            |  107 ++-
 drivers/input/keyboard/sh_keysc.c                  |   14 +-
 drivers/input/keyboard/spear-keyboard.c            |   13 +-
 drivers/input/keyboard/stmpe-keypad.c              |   13 +-
 drivers/input/keyboard/tc3589x-keypad.c            |   15 +-
 drivers/input/keyboard/tca8418_keypad.c            |  430 ++++++++
 drivers/input/keyboard/tegra-kbc.c                 |  132 ++-
 drivers/input/keyboard/tnetv107x-keypad.c          |   14 +-
 drivers/input/keyboard/twl4030_keypad.c            |   13 +-
 drivers/input/keyboard/w90p910_keypad.c            |   14 +-
 drivers/input/misc/88pm860x_onkey.c                |   13 +-
 drivers/input/misc/Kconfig                         |   25 +
 drivers/input/misc/Makefile                        |    2 +
 drivers/input/misc/ab8500-ponkey.c                 |   13 +-
 drivers/input/misc/adxl34x-spi.c                   |    1 -
 drivers/input/misc/adxl34x.c                       |   16 +-
 drivers/input/misc/ati_remote2.c                   |   19 +-
 drivers/input/misc/bfin_rotary.c                   |   13 +-
 drivers/input/misc/cobalt_btns.c                   |   14 +-
 drivers/input/misc/dm355evm_keys.c                 |   13 +-
 drivers/input/misc/gp2ap002a00f.c                  |  299 ++++++
 drivers/input/misc/gpio_tilt_polled.c              |  213 ++++
 drivers/input/misc/ixp4xx-beeper.c                 |   13 +-
 drivers/input/misc/max8925_onkey.c                 |   13 +-
 drivers/input/misc/mc13783-pwrbutton.c             |   14 +-
 drivers/input/misc/mpu3050.c                       |  128 +++-
 drivers/input/misc/pcap_keys.c                     |   14 +-
 drivers/input/misc/pcf50633-input.c                |   13 +-
 drivers/input/misc/pcspkr.c                        |   14 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   13 +-
 drivers/input/misc/pmic8xxx-pwrkey.c               |   13 +-
 drivers/input/misc/pwm-beeper.c                    |   13 +-
 drivers/input/misc/rb532_button.c                  |   14 +-
 drivers/input/misc/rotary_encoder.c                |   14 +-
 drivers/input/misc/sgi_btns.c                      |   13 +-
 drivers/input/misc/twl4030-pwrbutton.c             |   15 +-
 drivers/input/misc/twl4030-vibra.c                 |   14 +-
 drivers/input/misc/twl6040-vibra.c                 |   13 +-
 drivers/input/misc/wm831x-on.c                     |   13 +-
 drivers/input/mouse/alps.c                         | 1036 ++++++++++++++++=
++--
 drivers/input/mouse/alps.h                         |   19 +
 drivers/input/mouse/amimouse.c                     |   16 +-
 drivers/input/mouse/elantech.c                     |   80 ++-
 drivers/input/mouse/elantech.h                     |    2 +
 drivers/input/mouse/gpio_mouse.c                   |   13 +-
 drivers/input/mouse/hgpk.c                         |   18 +-
 drivers/input/mouse/logips2pp.c                    |    9 +-
 drivers/input/mouse/psmouse-base.c                 |  229 +++--
 drivers/input/mouse/psmouse.h                      |    3 +
 drivers/input/mouse/pxa930_trkball.c               |   14 +-
 drivers/input/mouse/sentelic.c                     |   43 +-
 drivers/input/mouse/synaptics.c                    |  197 +++-
 drivers/input/mouse/synaptics.h                    |    5 +
 drivers/input/mouse/trackpoint.c                   |   17 +-
 drivers/input/serio/altera_ps2.c                   |   13 +-
 drivers/input/serio/at32psif.c                     |   14 +-
 drivers/input/serio/i8042.c                        |   23 +-
 drivers/input/serio/rpckbd.c                       |   14 +-
 drivers/input/serio/xilinx_ps2.c                   |   14 +-
 drivers/input/tablet/aiptek.c                      |   34 +-
 drivers/input/tablet/wacom_sys.c                   |  101 ++-
 drivers/input/tablet/wacom_wac.c                   |  187 ++++-
 drivers/input/tablet/wacom_wac.h                   |    5 +-
 drivers/input/touchscreen/88pm860x-ts.c            |   13 +-
 drivers/input/touchscreen/Kconfig                  |   41 +
 drivers/input/touchscreen/Makefile                 |    3 +
 drivers/input/touchscreen/ad7877.c                 |   17 +-
 drivers/input/touchscreen/ad7879-i2c.c             |   31 +-
 drivers/input/touchscreen/ad7879-spi.c             |   27 +-
 drivers/input/touchscreen/ad7879.c                 |   23 +-
 drivers/input/touchscreen/ad7879.h                 |    4 +-
 drivers/input/touchscreen/ads7846.c                |    9 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |   13 +-
 drivers/input/touchscreen/atmel_tsadcc.c           |   15 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |  652 ++++++++++++
 drivers/input/touchscreen/da9034-ts.c              |   13 +-
 drivers/input/touchscreen/egalax_ts.c              |  303 ++++++
 drivers/input/touchscreen/htcpen.c                 |    7 +-
 drivers/input/touchscreen/intel-mid-touch.c        |   13 +-
 drivers/input/touchscreen/jornada720_ts.c          |   14 +-
 drivers/input/touchscreen/lpc32xx_ts.c             |   13 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |   14 +-
 drivers/input/touchscreen/mc13783_ts.c             |   13 +-
 drivers/input/touchscreen/migor_ts.c               |  117 +--
 drivers/input/touchscreen/pcap_ts.c                |   14 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          |  239 +++++
 drivers/input/touchscreen/s3c2410_ts.c             |   14 +-
 drivers/input/touchscreen/stmpe-ts.c               |   15 +-
 drivers/input/touchscreen/tnetv107x-ts.c           |   14 +-
 drivers/input/touchscreen/tps6507x-ts.c            |   13 +-
 drivers/input/touchscreen/ucb1400_ts.c             |  287 +++---
 drivers/input/touchscreen/usbtouchscreen.c         |   36 +
 drivers/input/touchscreen/w90p910_ts.c             |   14 +-
 drivers/input/touchscreen/wm831x-ts.c              |   13 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |   14 +-
 include/linux/input/auo-pixcir-ts.h                |   56 ++
 include/linux/input/gp2ap002a00f.h                 |   22 +
 include/linux/input/gpio_tilt.h                    |   73 ++
 include/linux/input/pixcir_ts.h                    |   10 +
 include/linux/input/samsung-keypad.h               |   43 +
 include/linux/input/tca8418_keypad.h               |   44 +
 include/linux/ucb1400.h                            |    6 +-
 132 files changed, 5550 insertions(+), 1644 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/tegra-kbc.txt
 create mode 100644 Documentation/input/alps.txt
 create mode 100644 Documentation/input/gpio-tilt.txt
 create mode 100644 drivers/input/keyboard/tca8418_keypad.c
 create mode 100644 drivers/input/misc/gp2ap002a00f.c
 create mode 100644 drivers/input/misc/gpio_tilt_polled.c
 create mode 100644 drivers/input/touchscreen/auo-pixcir-ts.c
 create mode 100644 drivers/input/touchscreen/egalax_ts.c
 create mode 100644 drivers/input/touchscreen/pixcir_i2c_ts.c
 create mode 100644 include/linux/input/auo-pixcir-ts.h
 create mode 100644 include/linux/input/gp2ap002a00f.h
 create mode 100644 include/linux/input/gpio_tilt.h
 create mode 100644 include/linux/input/pixcir_ts.h
 create mode 100644 include/linux/input/samsung-keypad.h
 create mode 100644 include/linux/input/tca8418_keypad.h

Thanks!

--=20
Dmitry


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCq5vAAoJEH70+W8r6ZYq7J4QAJfKBwF0lFJG4OXwsu26ZvrH
scfFsrFx4fD2DN501L9nVY12he1IkwzzbhM6zp1DD2CR3MZ/6OAwnEyYDfj2A/fc
E8nSDg7DwLy6HQUKxWrwfqY8/TqM7dG61YGRVYqHEHBlXmxLww+15HboFM2bawwD
8BlzweKLeYFnis8RGo42x013y4VQsTAdPwE0jOn9OXfMKBisDnMxkcIYvBzbHFrv
X/EADUpVw/pQRnEF55Cgc7lHECZIA9W7x2sozKiFgJ9o/qcZE5VJ3f3dgJZ4I6FU
6eVyq02vB/3VjXLCRBvchCOFtTFdl9zCZ2C+KPDfg+wjtC9CDDV+xw1+ui3HKjfH
icLASk0WoL6oPzIBO3qaugwAD62pVfOdt+cQ8vgjg1LKR9Zi7AM27HfdiTut9KVl
mT1IECAZ6gShrtzgvKQeNqfzqOj9L4xQsenyX62RIixtX+ONjANTrCT8qlxJqvwj
2Wj67kG74Upi7m/hsUSKM9dmfvFCeS8gNhYAxS6z2YxVSDp/FV2NB6gqIXzhAeHS
3jRdLEl1sxzmJ0thLBomooT0vLaEc9tro+LY8MUos04GPpz9jfqR7IoC5dduWNKC
G+mH144pDHlnxUtmqlR6l7KbYFaRf0babGRNi6oxETQSIjCb4oG11WkN8uA30lwb
F/D5ce6xW4S+J2DI2Hjz
=yYQ6
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
