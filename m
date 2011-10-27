Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1J0FUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 01:20:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43434 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1J0FUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 01:20:02 -0400
Date: Wed, 26 Oct 2011 22:19:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.2-rc0
Message-ID: <20111027051953.GA20121@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get updates to
Synaptics and Elantech drivers bringing support for newer revisions of
their hardware, some new input drivers and assorted fixes for existing
ones.

Changelog:
---------

Amy Maloche (1):
      Input: add support for pm8xxx based vibrator driver

Chris Bagwell (3):
      Input: wacom - remove unneeded touch pressure initialization
      Input: wacom - add ABS_DISTANCE to Bamboo Pen reports
      Input: wacom - correct max Y value on medium bamboos

Dan Carpenter (1):
      Input: force feedback - potential integer wrap in input_ff_create()

Daniel Kurtz (10):
      Input: synaptics - refactor y inversion
      Input: synaptics - refactor agm packet parsing
      Input: synaptics - refactor initialization of abs position axes
      Input: synaptics - add image sensor support
      Input: synaptics - decode AGM packet types
      Input: mt - document devices reporting more touches than slots
      Input: synaptics - process finger (<=3D3) transitions
      Input: add BTN_TOOL_QUINTTAP for reporting 5 fingers on touchpad
      Input: synaptics - process finger (<=3D5) transitions
      Input: atmel_mxt_ts - use snprintf for sysfs attribute show method

Dmitry Torokhov (22):
      Input: polldev - immediately poll device upon opening
      Input: wacom_w8001 - implement open and close
      Input: wacom_w8001 - simplify w8001_remove
      Input: tsc2007 - convert to threaded IRQ
      Input: tsc2007 - add open and close methods
      Input: tegra-kbc - tighten locking
      Input: penmount - rework handling of different protocols
      Input: penmount - simplify unregister procedure
      Input: mma8450 - silence some 'uninitialized variable' warnings
      Input: synaptics_i2c - wrap suspend and resume in CONFIG_PM_SLEEP
      Input: ad7879-i2c - wrap suspend and resume in CONFIG_PM_SLEEP
      Input: lm8323 - wrap suspend and resume in CONFIG_PM_SLEEP
      Input: psmouse - switch to using dev_*() for messages
      Input: serio_raw - use kref instead of rolling out its own refcounting
      Input: serio_raw - rename serio_raw_list to serio_raw_client
      Input: serio_raw - perform proper locking when adding clients to list
      Input: serio_raw - use bool for boolean data
      Input: serio_raw - use dev_*() for messages
      Input: serio_raw - fix coding style issues
      Input: serio_raw - explicitly mark disconnected ports as dead
      Input: serio_raw - kick clients when disconnecting port
      Input: serio_raw - fix memory leak when closing char device

Eduard Hasenleithner (1):
      Input: wacom - add Intuos4 LED and OLED control

Eric Andersson (1):
      Input: add driver for Bosch Sensortec's BMA150 accelerometer

Harvey Yang (1):
      Input: tc3589x-keypad - fix section mismatch warning

Hui Wang (1):
      Input: imx_keypad - add pm suspend and resume support

JJ Ding (10):
      Input: elantech - correct x, y value range for v2 hardware
      Input: elantech - get rid of ETP_2FT_* in elantech.h
      Input: elantech - use firmware provided x, y ranges
      Input: elantech - remove ETP_EDGE_FUZZ_V2
      Input: elantech - packet checking for v2 hardware
      Input: elantech - clean up elantech_init
      Input: elantech - add v3 hardware support
      Input: elantech - add v4 hardware support
      Input: elantech - better support all those v2 variants
      Input: elantech - remove module parameter force_elantech

John Sung (4):
      Input: penmount - fix the protocol
      Input: penmount - add PenMount 6000 support
      Input: penmount - add PenMount 3000 support
      Input: penmount - add PenMount 6250 support

Michael Hennerich (1):
      Input: adp5589-keys - add support for the ADP5585 derivatives

Michael Tandy (1):
      Input: adxl34x - documentation cleanup

Philip Rakity (1):
      Input: tsc2007 - make sure that X plate resistance is specified

Ping Cheng (4):
      Input: wacom - lower the LED luminance
      Input: wacom - don't expose LED inactive option
      Input: wacom - add LED support for Cintiq 21ux2
      Input: wacom - make LED status readable through sysfs

Rakesh Iyer (1):
      Input: tegra-kbc - fix wakeup from suspend

Randy Dunlap (1):
      Input: twl6040-vibra - fix compiler warning

Sebastian Andrzej Siewior (1):
      Input: add a driver for TSC-40 serial touchscreen

Tobias Klauser (1):
      Input: gpio_keys - use of_property_read_u32()

Wanlong Gao (1):
      Input: ad714x-i2c - change placement of __init/__exit annotations

Yong Zhang (1):
      Input: remove IRQF_DISABLED from drivers


Diffstat:
--------

 Documentation/ABI/testing/sysfs-driver-wacom |   72 +++
 Documentation/ABI/testing/sysfs-wacom        |   10 -
 Documentation/input/elantech.txt             |  295 ++++++++++-
 Documentation/input/multi-touch-protocol.txt |   14 +
 drivers/input/ff-core.c                      |   11 +-
 drivers/input/input-mt.c                     |    1 +
 drivers/input/input-polldev.c                |    6 +-
 drivers/input/keyboard/Kconfig               |    4 +-
 drivers/input/keyboard/adp5588-keys.c        |    2 +-
 drivers/input/keyboard/adp5589-keys.c        |  609 +++++++++++++++++-----
 drivers/input/keyboard/davinci_keyscan.c     |    2 +-
 drivers/input/keyboard/ep93xx_keypad.c       |    2 +-
 drivers/input/keyboard/gpio_keys.c           |   24 +-
 drivers/input/keyboard/imx_keypad.c          |   46 ++-
 drivers/input/keyboard/jornada720_kbd.c      |    2 +-
 drivers/input/keyboard/lm8323.c              |    2 +-
 drivers/input/keyboard/matrix_keypad.c       |    1 -
 drivers/input/keyboard/pxa27x_keypad.c       |    2 +-
 drivers/input/keyboard/pxa930_rotary.c       |    2 +-
 drivers/input/keyboard/tc3589x-keypad.c      |    2 +-
 drivers/input/keyboard/tegra-kbc.c           |   85 ++--
 drivers/input/keyboard/w90p910_keypad.c      |    2 +-
 drivers/input/misc/Kconfig                   |   45 ++-
 drivers/input/misc/Makefile                  |    4 +-
 drivers/input/misc/ad714x-i2c.c              |    4 +-
 drivers/input/misc/bma150.c                  |  691 ++++++++++++++++++++++=
++
 drivers/input/misc/ixp4xx-beeper.c           |    2 +-
 drivers/input/misc/mma8450.c                 |   20 +-
 drivers/input/misc/pm8xxx-vibrator.c         |  296 +++++++++++
 drivers/input/misc/twl6040-vibra.c           |    2 +-
 drivers/input/mouse/alps.c                   |   52 +-
 drivers/input/mouse/elantech.c               |  734 ++++++++++++++++++++++=
----
 drivers/input/mouse/elantech.h               |   57 ++-
 drivers/input/mouse/hgpk.c                   |   84 ++--
 drivers/input/mouse/hgpk.h                   |   11 -
 drivers/input/mouse/lifebook.c               |    6 +-
 drivers/input/mouse/logips2pp.c              |   16 +-
 drivers/input/mouse/psmouse-base.c           |   67 ++-
 drivers/input/mouse/psmouse.h                |   25 +
 drivers/input/mouse/pxa930_trkball.c         |    2 +-
 drivers/input/mouse/sentelic.c               |   13 +-
 drivers/input/mouse/synaptics.c              |  610 ++++++++++++++++++---
 drivers/input/mouse/synaptics.h              |   27 +-
 drivers/input/mouse/synaptics_i2c.c          |    4 +-
 drivers/input/serio/serio_raw.c              |  215 +++++----
 drivers/input/tablet/wacom.h                 |   10 +-
 drivers/input/tablet/wacom_sys.c             |  356 ++++++++++++-
 drivers/input/tablet/wacom_wac.c             |   48 +-
 drivers/input/touchscreen/Kconfig            |   12 +
 drivers/input/touchscreen/Makefile           |    1 +
 drivers/input/touchscreen/ad7879-i2c.c       |    6 +-
 drivers/input/touchscreen/atmel_mxt_ts.c     |   21 +-
 drivers/input/touchscreen/atmel_tsadcc.c     |    2 +-
 drivers/input/touchscreen/h3600_ts_input.c   |    4 +-
 drivers/input/touchscreen/hp680_ts_input.c   |    2 +-
 drivers/input/touchscreen/jornada720_ts.c    |    2 +-
 drivers/input/touchscreen/lpc32xx_ts.c       |    2 +-
 drivers/input/touchscreen/penmount.c         |  199 ++++++-
 drivers/input/touchscreen/s3c2410_ts.c       |    2 +-
 drivers/input/touchscreen/tsc2007.c          |  200 ++++----
 drivers/input/touchscreen/tsc40.c            |  184 +++++++
 drivers/input/touchscreen/w90p910_ts.c       |    2 +-
 drivers/input/touchscreen/wacom_w8001.c      |   29 +-
 include/linux/bma150.h                       |   46 ++
 include/linux/i2c/tsc2007.h                  |    2 +-
 include/linux/input.h                        |    3 +-
 include/linux/input/adp5589.h                |  157 +++----
 include/linux/input/adxl34x.h                |   21 +-
 include/linux/serio.h                        |    1 +
 include/linux/uinput.h                       |    2 +-
 70 files changed, 4531 insertions(+), 966 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-wacom
 delete mode 100644 Documentation/ABI/testing/sysfs-wacom
 create mode 100644 drivers/input/misc/bma150.c
 create mode 100644 drivers/input/misc/pm8xxx-vibrator.c
 create mode 100644 drivers/input/touchscreen/tsc40.c
 create mode 100644 include/linux/bma150.h

--=20
Dmitry


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOqOn4AAoJEH70+W8r6ZYqgrwQAK654QX7LtH+r/LhV/SoecX8
LVQbuw2Q4Lmh9NfyrJ4mXKlmE8SbLWlnBWerHOqlMvAgF5YsHVXt68Nl/9YvMv6b
aMcy8gvzCj5qBDkrNUbpylzAnbIf/MDhl6NvZJ2KtuJo6DKYKXbvNkXy5AfK5lFX
BG3JjY9JVY0PGdgV01TslgFxfVQiT45p2fmT2TxvzURfg/RLWUnxqohWCxyuqdFK
v5nil3wiLbNNOWcnyQ+klTEAcIhLmaiYScsFR9V+upSuB3usbzjzX6xmAEfXd5z2
4sQS0MWozpjDMdTD6cnSdwTVg2RiMYfKtEBF7z90t83ON8daFMDkq4Hjp7dNongz
b8Qaxa1I+OEafRefwTp4qxdsOp8d/iwRJyAZ2eTpM+oyKgzyJqndiTJlWUpxpPZt
dSrKMc5or3jKVL9pn90uoT7NPPCPMVzd7z1CsH7cOiblKdMZuLRwpdeWAL+zUDdn
uG3GBEtd8XVXBmtXMiOblNmxd55vRB/yhiXc4Nkasr3BPmiG/bjy3hSbpHKsKLik
MBpqTg/wDvg1BjiA1ijBiOv98xYmLyIjqOo3/Nsi3JHim2m7hoEfbBf0LDTHRaUl
yD0qeCcUk7idpz0nB1x89G8QWI8S50UZX/edO8188LdZk9kmf4NlMEmPz9EFtIuw
l/LI5mAOhQzkj6eswx+x
=qdwS
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
