Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2LQIAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:00:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36505 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2LQIAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:00:52 -0500
Date: Mon, 17 Dec 2012 00:00:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.8-rc0 (take 2)
Message-ID: <20121217080047.GA4106@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

*** This is the 2nd take with the corrected subject and hopefully more
sane diffstat ***

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. As usual, there are a couple
of new drivers, input core now supports managed input devices (devres),
a slew of drivers now have device tree support and a bunch of fixes and
cleanups.

There will be 2 conflicts: one in arch/arm/mach-ux500/board-mop500-stuib.c,
and another in drivers/input/touchscreen/ti_tscadc.c (which was renamed
into ti_am335x_tsc).

Thanks!

Changelog:
---------

Aaro Koskinen (2):
      Input: i8042-io - fix up region handling on MIPS
      Input: add Retu power button driver.

Alban Bedel (2):
      Input: tca8418_keypad - add support for device tree bindings
      Input: tca8418_keypad - add support for shared interrupt

Alexander Shiyan (2):
      Input: remove Compaq iPAQ H3600 (Bitsy) touchscreen driver
      Input: gpio-keys-polled - honor 'autorepeat' setting in platform data

Andreas Pretzsch (1):
      Input: imx_keypad - only set enabled columns to open-drain

Andy Shevchenko (1):
      Input: ALPS - print small buffers via %*ph

AnilKumar Ch (1):
      Input: matrix-keypad - add device tree support

Ashish Jangam (1):
      Input: add DA9055 Onkey driver

Bill Pemberton (6):
      Input: serio - remove CONFIG_HOTPLUG ifdefs
      Input: remove use of __devexit_p
      Input: remove use of __devinitdata
      Input: remove use of __devinitconst
      Input: remove use of __devinit
      Input: remove use of __devexit

Deepak Sikri (1):
      Input: spear-keyboard - fix for balancing the enable_irq_wake

Diego Calleja (1):
      Input: wacom - fix touch support for Bamboo Fun CTH-461

Dmitry Torokhov (15):
      Input: arc_ps2 - switch to using managed resources
      Input: fix sparse warning in multitouch code
      Input: fix sparse warning in __input_release_device()
      Input: introduce managed input devices (add devres support)
      Input: marix-keymap - automatically allocate memory for keymap
      OMAP: nokia770: remove custom implementation of ads7846_get_pendown_s=
tate
      Input: stmpe-keypad - add support for Device Tree bindings
      Input: gpio_keys - report initial state when opening the device
      Input: tca8418_keypad - use a temporary variable for parent device
      Input: tca8418_keypad - use dev_get_platdata() to retrieve platform d=
ata
      Input: tca8418_keypad - move device ID tables closer to where they ar=
e used
      Input: tca8418_keypad - increase severity of failures in probe()
      Input: tca8418-keypad - switch to using managed resources
      Input: gpio_keys - switch to using gpio_request_one()
      Input: gpio_keys_polled - switch to using gpio_request_one()

Florian Fainelli (1):
      Input: matrix-keymap - provide a proper module license

Guillermo A. Amaral (2):
      Input: xpad - minor formatting fixes
      Input: xpad - add a few new VID/PID combinations

Henrik Rydberg (1):
      Input: document new members of struct input_dev

Javier Martin (1):
      Input: qt2160 - fix qt2160_write() implementation

Jonas Aaberg (1):
      Input: gpio_keys - disable hardware on suspend

Kees Cook (2):
      Input: remove CONFIG_EXPERIMENTAL from keyboard drivers
      Input: remove CONFIG_EXPERIMENTAL from miscellaneous drivers

Lee Jones (4):
      ARM: ux500: Strip out duplicate touch screen platform information
      Input: bu21013_ts - request regulator that actually exists
      Input: bu21013_ts - move GPIO init and exit functions into the driver
      Input: bu21013_ts - add support for Device Tree booting

Mark Brown (3):
      Input: wm831x-ts - remove unneeded clearing of driver data
      Input: wm831x-ts - convert to devm_kzalloc()
      Input: wm831x-on - convert to devm_kzalloc()

Mischa Jonker (1):
      Input: serio - add ARC PS/2 driver

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup

Peter Ujfalusi (1):
      Input: twl4030-pwrbutton - switch to using TWL_MODULE_PM_MASTER define

Ping Cheng (4):
      Input: wacom - clean up device type code
      Input: wacom - add support for 2 new multi-touch tablets (0x100 and 0=
x101)
      Input: wacom - simplify type check for newer V5 devices
      Input: wacom - add support for a new MT device (0x4001)

Rolf Eike Beer (1):
      Input: HIL - remove one goto

Sachin Kamat (1):
      Input: samsung-keypad - switch to using managed resources

Sascha Hauer (1):
      Input: pwm-beeper - add devicetree probing support

Shubhrajyoti D (1):
      Input: as5011 - use C99-style structure initializators

Shubhrajyoti Datta (1):
      Input: cy8ctmg110_ts - use C99-style structure initializators

Tomasz Figa (1):
      Input: mms114 - add device tree bindings

Ulf Hansson (2):
      Input: nomadik-ske-keypad - fixup use of clk
      Input: nomadik-ske-keypad - start using the apb_pclk

Vipul Kumar Samar (3):
      Input: stmpe-ts - initialize the phys field in input device
      Input: stmpe-ts - add DT support for stmpe touchscreen
      Input: spear-keyboard - add clk_{un}prepare() support

Viresh Kumar (3):
      Input: spear-keyboard - switch to using managed resources
      Input: stmpe-keyboard - switch to using managed resources
      Input: stmpe-ts - switch to using managed resources

Wei Yongjun (1):
      Input: edt-ft5x06 - convert to use simple_open()

Xiaotian Feng (1):
      Input: HIL - do not call tasklet_disable right before tasklet_kill


Diffstat:
--------

 .../bindings/input/gpio-matrix-keypad.txt          |  46 ++
 .../devicetree/bindings/input/pwm-beeper.txt       |   7 +
 .../devicetree/bindings/input/stmpe-keypad.txt     |  39 ++
 .../devicetree/bindings/input/tca8418_keypad.txt   |   8 +
 .../bindings/input/touchscreen/mms114.txt          |  34 ++
 .../bindings/input/touchscreen/stmpe.txt           |  43 ++
 arch/arm/mach-omap1/board-nokia770.c               |  14 +-
 arch/arm/mach-ux500/board-mop500-stuib.c           |  71 +--
 drivers/input/gameport/emu10k1-gp.c                |   6 +-
 drivers/input/gameport/fm801-gp.c                  |   6 +-
 drivers/input/input-mt.c                           |   2 +-
 drivers/input/input.c                              | 181 ++++++--
 drivers/input/joystick/as5011.c                    |  29 +-
 drivers/input/joystick/maplecontrol.c              |   6 +-
 drivers/input/joystick/walkera0701.c               |   7 +-
 drivers/input/joystick/xpad.c                      |  33 +-
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/keyboard/adp5520-keys.c              |   6 +-
 drivers/input/keyboard/adp5588-keys.c              |  18 +-
 drivers/input/keyboard/adp5589-keys.c              |  21 +-
 drivers/input/keyboard/bf54x-keys.c                |   6 +-
 drivers/input/keyboard/davinci_keyscan.c           |   4 +-
 drivers/input/keyboard/ep93xx_keypad.c             |   6 +-
 drivers/input/keyboard/gpio_keys.c                 |  90 ++--
 drivers/input/keyboard/gpio_keys_polled.c          |  26 +-
 drivers/input/keyboard/hilkbd.c                    |  10 +-
 drivers/input/keyboard/imx_keypad.c                |   9 +-
 drivers/input/keyboard/jornada680_kbd.c            |   6 +-
 drivers/input/keyboard/jornada720_kbd.c            |   6 +-
 drivers/input/keyboard/lm8323.c                    |   6 +-
 drivers/input/keyboard/lm8333.c                    |   6 +-
 drivers/input/keyboard/locomokbd.c                 |   8 +-
 drivers/input/keyboard/lpc32xx-keys.c              |   8 +-
 drivers/input/keyboard/matrix_keypad.c             | 129 ++++--
 drivers/input/keyboard/max7359_keypad.c            |   6 +-
 drivers/input/keyboard/mcs_touchkey.c              |   6 +-
 drivers/input/keyboard/mpr121_touchkey.c           |  12 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |  38 +-
 drivers/input/keyboard/omap-keypad.c               |   6 +-
 drivers/input/keyboard/omap4-keypad.c              |  10 +-
 drivers/input/keyboard/opencores-kbd.c             |   6 +-
 drivers/input/keyboard/pmic8xxx-keypad.c           |  10 +-
 drivers/input/keyboard/pxa27x_keypad.c             |   6 +-
 drivers/input/keyboard/pxa930_rotary.c             |   6 +-
 drivers/input/keyboard/qt1070.c                    |   8 +-
 drivers/input/keyboard/qt2160.c                    |  31 +-
 drivers/input/keyboard/samsung-keypad.c            | 109 ++---
 drivers/input/keyboard/sh_keysc.c                  |   6 +-
 drivers/input/keyboard/spear-keyboard.c            |  98 ++---
 drivers/input/keyboard/stmpe-keypad.c              | 142 +++---
 drivers/input/keyboard/tc3589x-keypad.c            |   6 +-
 drivers/input/keyboard/tca6416-keypad.c            |   8 +-
 drivers/input/keyboard/tca8418_keypad.c            | 179 ++++----
 drivers/input/keyboard/tegra-kbc.c                 |  16 +-
 drivers/input/keyboard/tnetv107x-keypad.c          |   6 +-
 drivers/input/keyboard/twl4030_keypad.c            |   8 +-
 drivers/input/keyboard/w90p910_keypad.c            |   6 +-
 drivers/input/matrix-keymap.c                      |  23 +-
 drivers/input/misc/88pm80x_onkey.c                 |   6 +-
 drivers/input/misc/88pm860x_onkey.c                |   6 +-
 drivers/input/misc/Kconfig                         |  29 +-
 drivers/input/misc/Makefile                        |   2 +
 drivers/input/misc/ab8500-ponkey.c                 |   6 +-
 drivers/input/misc/ad714x-i2c.c                    |   6 +-
 drivers/input/misc/ad714x-spi.c                    |   6 +-
 drivers/input/misc/adxl34x-i2c.c                   |   6 +-
 drivers/input/misc/adxl34x-spi.c                   |   6 +-
 drivers/input/misc/bfin_rotary.c                   |   6 +-
 drivers/input/misc/bma150.c                        |  28 +-
 drivers/input/misc/cma3000_d0x_i2c.c               |   6 +-
 drivers/input/misc/cobalt_btns.c                   |   6 +-
 drivers/input/misc/da9052_onkey.c                  |   6 +-
 drivers/input/misc/da9055_onkey.c                  | 171 ++++++++
 drivers/input/misc/dm355evm_keys.c                 |   6 +-
 drivers/input/misc/gp2ap002a00f.c                  |   8 +-
 drivers/input/misc/gpio_tilt_polled.c              |   6 +-
 drivers/input/misc/ixp4xx-beeper.c                 |   6 +-
 drivers/input/misc/kxtj9.c                         |  16 +-
 drivers/input/misc/m68kspkr.c                      |   6 +-
 drivers/input/misc/max8925_onkey.c                 |   6 +-
 drivers/input/misc/max8997_haptic.c                |   6 +-
 drivers/input/misc/mc13783-pwrbutton.c             |   6 +-
 drivers/input/misc/mma8450.c                       |   6 +-
 drivers/input/misc/mpu3050.c                       |   8 +-
 drivers/input/misc/pcap_keys.c                     |   6 +-
 drivers/input/misc/pcf50633-input.c                |   6 +-
 drivers/input/misc/pcf8574_keypad.c                |   6 +-
 drivers/input/misc/pcspkr.c                        |   6 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   6 +-
 drivers/input/misc/pmic8xxx-pwrkey.c               |   6 +-
 drivers/input/misc/pwm-beeper.c                    |  20 +-
 drivers/input/misc/rb532_button.c                  |   6 +-
 drivers/input/misc/retu-pwrbutton.c                |  99 +++++
 drivers/input/misc/rotary_encoder.c                |   9 +-
 drivers/input/misc/sgi_btns.c                      |   6 +-
 drivers/input/misc/sparcspkr.c                     |  14 +-
 drivers/input/misc/twl4030-pwrbutton.c             |   3 +-
 drivers/input/misc/twl4030-vibra.c                 |   6 +-
 drivers/input/misc/twl6040-vibra.c                 |   6 +-
 drivers/input/misc/wistron_btns.c                  |  20 +-
 drivers/input/misc/wm831x-on.c                     |  11 +-
 drivers/input/misc/xen-kbdfront.c                  |   2 +-
 drivers/input/mouse/alps.c                         |  10 +-
 drivers/input/mouse/gpio_mouse.c                   |   6 +-
 drivers/input/mouse/maplemouse.c                   |   6 +-
 drivers/input/mouse/navpoint.c                     |   6 +-
 drivers/input/mouse/pxa930_trkball.c               |   6 +-
 drivers/input/mouse/synaptics_i2c.c                |   6 +-
 drivers/input/serio/Kconfig                        |   9 +
 drivers/input/serio/Makefile                       |   1 +
 drivers/input/serio/altera_ps2.c                   |   6 +-
 drivers/input/serio/ambakmi.c                      |   6 +-
 drivers/input/serio/arc_ps2.c                      | 274 ++++++++++++
 drivers/input/serio/ct82c710.c                     |   6 +-
 drivers/input/serio/gscps2.c                       |   6 +-
 drivers/input/serio/hil_mlc.c                      |  13 +-
 drivers/input/serio/i8042-io.h                     |   2 +-
 drivers/input/serio/i8042-sparcio.h                |   6 +-
 drivers/input/serio/i8042.c                        |   6 +-
 drivers/input/serio/maceps2.c                      |   8 +-
 drivers/input/serio/pcips2.c                       |   6 +-
 drivers/input/serio/q40kbd.c                       |   6 +-
 drivers/input/serio/rpckbd.c                       |   6 +-
 drivers/input/serio/sa1111ps2.c                    |  12 +-
 drivers/input/serio/serio.c                        |  11 -
 drivers/input/serio/xilinx_ps2.c                   |   8 +-
 drivers/input/tablet/wacom_sys.c                   |  58 ++-
 drivers/input/tablet/wacom_wac.c                   |  32 +-
 drivers/input/tablet/wacom_wac.h                   |   2 +
 drivers/input/touchscreen/88pm860x-ts.c            |   8 +-
 drivers/input/touchscreen/Kconfig                  |  12 -
 drivers/input/touchscreen/Makefile                 |   1 -
 drivers/input/touchscreen/ad7877.c                 |   6 +-
 drivers/input/touchscreen/ad7879-i2c.c             |   6 +-
 drivers/input/touchscreen/ad7879-spi.c             |   6 +-
 drivers/input/touchscreen/ads7846.c                |  10 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           |   6 +-
 drivers/input/touchscreen/atmel_tsadcc.c           |   6 +-
 drivers/input/touchscreen/auo-pixcir-ts.c          |   8 +-
 drivers/input/touchscreen/bu21013_ts.c             | 125 ++++--
 drivers/input/touchscreen/cy8ctmg110_ts.c          |  19 +-
 drivers/input/touchscreen/cyttsp_i2c.c             |   6 +-
 drivers/input/touchscreen/cyttsp_spi.c             |   6 +-
 drivers/input/touchscreen/da9034-ts.c              |   6 +-
 drivers/input/touchscreen/da9052_tsi.c             |  10 +-
 drivers/input/touchscreen/edt-ft5x06.c             |  28 +-
 drivers/input/touchscreen/eeti_ts.c                |   6 +-
 drivers/input/touchscreen/egalax_ts.c              |   8 +-
 drivers/input/touchscreen/h3600_ts_input.c         | 479 -----------------=
----
 drivers/input/touchscreen/htcpen.c                 |   6 +-
 drivers/input/touchscreen/ili210x.c                |   6 +-
 drivers/input/touchscreen/intel-mid-touch.c        |  14 +-
 drivers/input/touchscreen/jornada720_ts.c          |   6 +-
 drivers/input/touchscreen/lpc32xx_ts.c             |   6 +-
 drivers/input/touchscreen/max11801_ts.c            |   8 +-
 drivers/input/touchscreen/mc13783_ts.c             |   4 +-
 drivers/input/touchscreen/mcs5000_ts.c             |   6 +-
 drivers/input/touchscreen/mms114.c                 |  68 ++-
 drivers/input/touchscreen/pcap_ts.c                |   6 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          |   6 +-
 drivers/input/touchscreen/s3c2410_ts.c             |   6 +-
 drivers/input/touchscreen/st1232.c                 |   8 +-
 drivers/input/touchscreen/stmpe-ts.c               | 133 +++---
 drivers/input/touchscreen/tnetv107x-ts.c           |   6 +-
 drivers/input/touchscreen/tps6507x-ts.c            |   4 +-
 drivers/input/touchscreen/tsc2005.c                |   8 +-
 drivers/input/touchscreen/tsc2007.c                |   6 +-
 drivers/input/touchscreen/ucb1400_ts.c             |   8 +-
 drivers/input/touchscreen/w90p910_ts.c             |   6 +-
 drivers/input/touchscreen/wacom_i2c.c              |   6 +-
 drivers/input/touchscreen/wm831x-ts.c              |  12 +-
 drivers/mfd/stmpe.c                                |   2 +
 include/linux/input.h                              |  10 +-
 include/linux/input/bu21013.h                      |  10 +-
 174 files changed, 2253 insertions(+), 1659 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/gpio-matrix-key=
pad.txt
 create mode 100644 Documentation/devicetree/bindings/input/pwm-beeper.txt
 create mode 100644 Documentation/devicetree/bindings/input/stmpe-keypad.txt
 create mode 100644 Documentation/devicetree/bindings/input/tca8418_keypad.=
txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/mms=
114.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/stm=
pe.txt
 create mode 100644 drivers/input/misc/da9055_onkey.c
 create mode 100644 drivers/input/misc/retu-pwrbutton.c
 create mode 100644 drivers/input/serio/arc_ps2.c
 delete mode 100644 drivers/input/touchscreen/h3600_ts_input.c


--=20
Dmitry


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQztEvAAoJEH70+W8r6ZYqp/cP+wWYDoQ26RRRZ/xIK+fAAUwt
Z08bDsiNcAeiaO3zLh1PZ6GyiSJPawW+6O1xkk2x9wbz7GXkUe7JyUUV9YRfLfrs
su4E3NlxYb61rH5XYZh8vLFUv+wxNKKL1JC3oqep3CRIth1XU1mNORnoyc9AjdfW
4zq7q69myM8oroRCrC0V9CQyUqHMfQ3yTxwTR1F1KwohmubG/baQ+O6r2vFsuX5o
97AsMyLc0H7gr8tAD/AOGAjKizPGV0WlSd2IdUBtf2apsS7J+ou7Qq3bxjuO+Mw5
9AgUZmuVjYKIOMyaacdp0OQNOg9F+oL+vzOjgnEdrvuPqSnrrepzPGigSQYjve7J
C1RIdkbQuzC6vN9ssGTYUv3VB3J1FJ/J9rTWr5kOWmpiA4pEjNNRR1orD2UQm6TQ
XxhaLWzm+smV78fNXLL+ID0topvq5h3s7slnLnConMHE68YLOrUlENzw2l2bSOKc
Nt7MnZznE05QZA5QTJQiUeRxCTwpIjyUuBAq8PdTtmE8Hzjm5JKcfNKRUF/ezfjM
TDj46orhePkuJqhjWKSmj1ppmt/r60/z/+rFi0PdS3cRgwecUogzJzuoynBtqDef
P2REU01N2Ynml60hmnFUtgvbTLSWqmczdeDqbmde29Yz+vVcDtPSdniUrQ4TQ7iv
ete2uy6PrFyvc/4NMWMH
=1rCy
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
