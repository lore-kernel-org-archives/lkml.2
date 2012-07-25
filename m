Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2GYHCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:02:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61005 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2GYHCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:02:38 -0400
Date: Wed, 25 Jul 2012 00:02:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.6-rc0
Message-ID: <20120725070233.GA4850@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive first set of updates for the input subsystem. You will get a
new touchscreen driver (Melfas mms114), a new keypad driver for LPC32xx
SoC, large update to Atmel mXT touchscreen driver, a lot of drivers
acquired device tree support and a slew of other fixes.

Changelog:
---------

Bob Ross (1):
      Input: synaptics_usb - Remove TrackPoint name trailing whitespace

Chris Bagwell (2):
      Input: wacom - battery reporting improvements
      Input: wacom - Bamboo One 1024 pressure fix

Dan Carpenter (1):
      Input: ff-memless - fix a couple min_t() casts

Daniel Kurtz (24):
      Input: atmel_mxt_ts - derive phys from i2c client adapter
      Input: atmel_mxt_ts - use client name for irq
      Input: atmel_mxt_ts - detect OOM when creating mt slots
      Input: atmel_mxt_ts - warn if sysfs could not be created
      Input: atmel_mxt_ts - don't read T5 when dumping objects
      Input: atmel_mxt_ts - use scnprintf for object sysfs entry
      Input: atmel_mxt_ts - optimize reading objects in object sysfs entry
      Input: atmel_mxt_ts - print less overhead when dumping objects
      Input: atmel_mxt_ts - print all instances when dumping objects
      Input: atmel_mxt_ts - return errors from i2c layer
      Input: atmel_mxt_ts - add variable length __mxt_write_reg
      Input: atmel_mxt_ts - optimize writing of object table entries
      Input: atmel_mxt_ts - read ID information block in one i2c transaction
      Input: atmel_mxt_ts - update driver ID info logging
      Input: atmel_mxt_ts - add sysfs entries to read fw and hw version
      Input: atmel_mxt_ts - simplify event reporting
      Input: atmel_mxt_ts - add detail to touchevent debug message
      Input: atmel_mxt_ts - refactor when and how object table is freed
      Input: atmel_mxt_ts - cache T9 reportid range when reading object tab=
le
      Input: atmel_mxt_ts - refactor reportid checking in mxt_interrupt
      Input: atmel_mxt_ts - use T9 reportid range to init number of mt slots
      Input: atmel_mxt_ts - send all MT-B slots in one input report
      Input: atmel_mxt_ts - parse T6 reports
      Input: synaptics - print firmware ID and board number at init

Dmitry Torokhov (1):
      Input: wacom_i2c - fix compiler warning

Fabio Estevam (3):
      Input: imx_keypad - use clk_prepare_enable/clk_disable_unprepare()
      Input: imx_keypad - adapt the new kpp clock name
      Input: imx_keypad - check error returned by clk_prepare_enable()

Henrik Rydberg (2):
      Input: MT - Include win8 support
      Revert "Input: atmel_mxt_ts - warn if sysfs could not be created"

Jason Gerecke (2):
      Input: wacom - initialize and destroy LEDs for Intuos4 S tablets
      Input: wacom - remove code duplication

Joonyoung Shim (1):
      Input: add MELFAS mms114 touchscreen driver

Lee Jones (1):
      Input: ab8500-ponkey - add device tree support

Michael Hennerich (1):
      Input: ad7879 - add option to correct xy axis

Naveen Kumar Gaddipati (2):
      Input: nomadik-ske-keypad - add multi key press support
      Input: nomadik-ske-keypad - get rid of multiple interrupts

Peter Ujfalusi (1):
      Input: twl6040-vibra - update for device tree support

Ping Cheng (4):
      Input: wacom - rearrange type enum
      Input: wacom - add two new devices (0xed and 0xef)
      Input: wacom - BTN_TOOL_DOUBLETAP is not a valid device_type
      Input: wacom - TPC2FG doesn't store touch id for slots

Roland Stigge (1):
      Input: add support for key scan interface of the LPC32xx SoC

Sachin Kamat (1):
      Input: MT - fix null pointer warning

Shiraz Hashim (5):
      Input: spear_keyboard - use correct io accessors
      Input: spear_keyboard - rename bit definitions to reflect register
      Input: spear_keyboard - generalize keyboard frequency configuration
      Input: spear_keyboard - fix clock handling during suspend/resume
      Input: spear_keyboard - reconfigure operating frequency on suspend

Sourav Poddar (1):
      Input: omap4-keypad - add device tree support

Tobias Klauser (1):
      Input: gpio_keys - remove useless reinitialization of pdata->nbuttons

Vipul Kumar Samar (1):
      Input: spear-keyboard - fix disable device_init_wakeup in remove

weixing (1):
      Input: hanwang - add support for Art Master II tablet


Diffstat:
--------

 .../devicetree/bindings/input/lpc32xx-key.txt      |   28 +
 .../devicetree/bindings/input/omap-keypad.txt      |   31 ++
 .../devicetree/bindings/input/twl6040-vibra.txt    |   37 --
 Documentation/input/multi-touch-protocol.txt       |  118 ++++-
 arch/arm/plat-spear/include/plat/keyboard.h        |    2 +
 drivers/input/ff-memless.c                         |    4 +-
 drivers/input/input-mt.c                           |    2 +-
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/gpio_keys.c                 |    1 -
 drivers/input/keyboard/imx_keypad.c                |   25 +-
 drivers/input/keyboard/lpc32xx-keys.c              |  394 ++++++++++++++
 drivers/input/keyboard/nomadik-ske-keypad.c        |   76 ++-
 drivers/input/keyboard/omap4-keypad.c              |  127 +++--
 drivers/input/keyboard/spear-keyboard.c            |  137 +++--
 drivers/input/misc/ab8500-ponkey.c                 |    9 +
 drivers/input/misc/twl6040-vibra.c                 |   42 +-
 drivers/input/mouse/synaptics.c                    |   38 +-
 drivers/input/mouse/synaptics.h                    |    3 +
 drivers/input/mouse/synaptics_usb.c                |    2 +-
 drivers/input/tablet/hanwang.c                     |   57 +-
 drivers/input/tablet/wacom_sys.c                   |  101 ++--
 drivers/input/tablet/wacom_wac.c                   |   27 +-
 drivers/input/tablet/wacom_wac.h                   |    8 +-
 drivers/input/touchscreen/Kconfig                  |   12 +
 drivers/input/touchscreen/Makefile                 |    1 +
 drivers/input/touchscreen/ad7879.c                 |    5 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |  463 +++++++++--------
 drivers/input/touchscreen/mms114.c                 |  544 ++++++++++++++++=
++++
 drivers/input/touchscreen/wacom_i2c.c              |    2 +-
 include/linux/i2c/mms114.h                         |   24 +
 include/linux/input.h                              |    8 +-
 include/linux/spi/ad7879.h                         |    2 +
 33 files changed, 1839 insertions(+), 502 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/lpc32xx-key.txt
 create mode 100644 Documentation/devicetree/bindings/input/omap-keypad.txt
 delete mode 100644 Documentation/devicetree/bindings/input/twl6040-vibra.t=
xt
 create mode 100644 drivers/input/keyboard/lpc32xx-keys.c
 create mode 100644 drivers/input/touchscreen/mms114.c
 create mode 100644 include/linux/i2c/mms114.h

--=20
Dmitry


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQD5oJAAoJEH70+W8r6ZYqi2oP/iN381ahMvrgntdU6U1CyXAk
3x6ScAx6NbaiDzR7sdZQouNEzBX+tvwzU+Uta2HxKV9qhnYtIsIfU+Ciqmg1/uBL
v+pSS5txP1k82Jn2tkQTfITMRshhk86mtIOtVqPhQ5TrpwViCdnzI6EoU/KVu8Z3
y1ikBB5TrV4qDB6+Gsx9R5K+jj+1tDDHXNs/dYlsu/na1ngZEvwGUNYAqeF3ERGW
mbSFxs64CkGfNLZ2MGRmV30jSl4Al6Lw2SDg73XqEoKnEdajp2bum2ur30ppCaDc
spL5P/eo7wVOaOGRbqHkOE8m/hxwlC29ClHT6YtE6gTHpXYz4W1c0r6AL5KpdwKM
jp5CWG1M0MTzLR42+c5lhaPjlgn95EG8lIQ5TR3tX1kuHLDUhc13Qtjm0TVTqetZ
Xxl3UWMJorOu3cEwSqdgP3oxNT8UbpPa5W+BJQ+wdS1YcqLVkNFlz1m0VtVzwd7O
J51WZJlfjN73YlCqsvKzdvt8UUf6wXdgplqdibBcJqyXxAtBr6ICzMiSeP/mfj7i
bwzPh+7/nzteSw9as7pJpgQo/yuHUKbJ+rx6kmmg+5nviA83mmfG57zNaLkP6oCd
JuqkloB+zFjgF1uE9xz2udny7tb7ZNJMIVY+VYGnS0NNIVB5ukjKwgMRqjQRecnu
1Vl8p85/Abe26wWfkV0d
=av+K
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
