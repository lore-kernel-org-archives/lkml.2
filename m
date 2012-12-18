Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab2LRXl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:41:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56687 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2LRXly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:41:54 -0500
Date: Wed, 19 Dec 2012 00:41:50 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c-embedded for 3.8
Message-ID: <20121218234150.GA32374@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
X-Mutt-PGP: S<0x7D7F551B>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

please pull the i2c-embedded changes for 3.8 which include:

* CBUS driver (an I2C variant)
* continued rework of the omap driver
* s3c2410 gets lots of fixes and gains pinctrl support
* at91 gains DMA support
* the GPIO muxer gains devicetree probing
* typical fixes and additions all over

All patches have been in linux-next before. Please pull.

Kind regards,

   Wolfram


The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-next

for you to fetch changes up to 972deb4f49b5b6703d9c6117ba0aeda2180d4447:

  i2c: omap: Remove the OMAP_I2C_FLAG_RESET_REGS_POSTIDLE flag (2012-11-28 =
11:36:32 +0100)

----------------------------------------------------------------
Aaro Koskinen (1):
      i2c: i2c-cbus-gpio: introduce driver

Abhilash Kesavan (2):
      i2c: s3c2410: Fix code to free gpios
      i2c: s3c2410: Add fix for i2c suspend/resume

Andreas Larsson (3):
      i2c: ocores: Add irq support for sparc
      i2c: ocores: Add support for the GRLIB port of the controller and use=
 function pointers for getreg and setreg functions
      i2c: ocores: Move grlib set/get functions into #ifdef CONFIG_OF block

Bo Shen (1):
      i2c: i2c-gpio: fix name issue with multiple i2c gpio nodes

Chuansheng Liu (1):
      i2c: nomadik: Fix the usage of wait_for_completion_timeout

Daniel Kurtz (4):
      i2c: s3c2410: grab adapter lock while changing i2c clock
      i2c: s3c2410: do not generate STOP for QUIRK_HDMIPHY
      i2c: s3c2410: use exponential back off while polling for bus idle
      i2c: s3c2410: do not special case HDMIPHY stuck bus detection

Felipe Balbi (1):
      i2c: omap: ensure writes to dev->buf_len are ordered

Kuninori Morimoto (1):
      i2c: rcar: used devm_request_and_ioremap() instead of devm_ioremap()

Ludovic Desroches (4):
      i2c: at91: fix SMBus quick command
      i2c: at91: fix compilation warning
      i2c: at91: change struct members indentation
      i2c: at91: add dma support

Marek Vasut (2):
      i2c: mxs: Handle i2c DMA failure properly
      i2c: mxs: Do not disable the I2C SMBus quick mode

Mark Brown (3):
      i2c: s3c2410: Refactor ifdefs for PM_SLEEP
      i2c: s3c2410: Convert to devm_request_and_ioremap()
      i2c: s3c2410: Remove recently introduced performance overheads

Maxime Ripard (2):
      i2c: mux: Add dt support to i2c-mux-gpio driver
      ARM: dts: cfa10049: Add the i2c muxer buses to the CFA-10049

Paul Walmsley (1):
      Revert "ARM: OMAP: convert I2C driver to PM QoS for MPU latency const=
raints"

Sebastien Guiriec (1):
      i2c: omap: adopt pinctrl support

Shinya Kuribayashi (4):
      i2c: i2c-sh_mobile: calculate clock parameters at driver probing time
      i2c: i2c-sh_mobile: optimize ICCH/ICCL values according to I2C bus sp=
eed
      i2c: i2c-sh_mobile: support I2C hardware block with a faster operatin=
g clock
      i2c: i2c-sh_mobile: fix spurious transfer request timed out

Shubhrajyoti D (10):
      i2c: omap: Fix the revision register read
      i2c: omap: use revision check for OMAP_I2C_FLAG_APPLY_ERRATA_I207
      i2c: omap: remove the dtrev
      ARM: i2c: omap: Remove the i207 errata flag
      i2c: omap: re-factor omap_i2c_init function
      i2c: omap: make reset a seperate function
      i2c: omap: Restore i2c context always
      i2c: omap: cleanup the sysc write
      i2c: omap: Move the remove constraint
      i2c: omap: Remove the OMAP_I2C_FLAG_RESET_REGS_POSTIDLE flag

Thierry Reding (1):
      i2c: ocores: Use devm_request_and_ioremap()

Tomasz Figa (1):
      i2c: s3c2410: Add support for pinctrl

Wolfram Sang (2):
      i2c: rcar: fix section mismatch
      i2c: omap: don't save a value only needed for read-clearing

 .../devicetree/bindings/i2c/i2c-cbus-gpio.txt      |   27 ++
 .../devicetree/bindings/i2c/i2c-mux-gpio.txt       |   81 +++++
 .../devicetree/bindings/i2c/i2c-ocores.txt         |    2 +-
 .../devicetree/bindings/i2c/samsung-i2c.txt        |   20 +-
 arch/arm/boot/dts/imx28-cfa10049.dts               |   24 ++
 arch/arm/mach-omap2/board-n8x0.c                   |   42 +++
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |    3 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |    3 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   12 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    3 +-
 arch/arm/plat-omap/i2c.c                           |   21 ++
 drivers/i2c/busses/Kconfig                         |   10 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-at91.c                      |  345 ++++++++++++++++=
++--
 drivers/i2c/busses/i2c-cbus-gpio.c                 |  300 +++++++++++++++++
 drivers/i2c/busses/i2c-gpio.c                      |    6 +-
 drivers/i2c/busses/i2c-mxs.c                       |    4 +-
 drivers/i2c/busses/i2c-nomadik.c                   |   14 -
 drivers/i2c/busses/i2c-ocores.c                    |  164 ++++++++--
 drivers/i2c/busses/i2c-omap.c                      |  258 ++++++++-------
 drivers/i2c/busses/i2c-rcar.c                      |    6 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |  212 +++++++-----
 drivers/i2c/busses/i2c-sh_mobile.c                 |  150 ++++++---
 drivers/i2c/muxes/i2c-mux-gpio.c                   |  145 ++++++--
 include/linux/i2c-omap.h                           |    3 +-
 include/linux/i2c/i2c-sh_mobile.h                  |    1 +
 include/linux/platform_data/i2c-cbus-gpio.h        |   27 ++
 27 files changed, 1507 insertions(+), 377 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cbus-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mux-gpio.txt
 create mode 100644 drivers/i2c/busses/i2c-cbus-gpio.c
 create mode 100644 include/linux/platform_data/i2c-cbus-gpio.h

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDQ/z4ACgkQD27XaX1/VRvhuwCgqwwIhB161k1Etavgt14V2uJI
hboAn0dH0x8Ium5H479oJB+uh06LFKl3
=26VV
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
