Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2EVFiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:38:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56961 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2EVFhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:45 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=208/8=5D=20arm-soc=3A=20board=20specific=20changes?=
Date: Mon, 21 May 2012 22:35:08 -0700
Message-Id: <1337664908-17478-9-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we generally attempt to get rid of board specific files and replace
them with device tree based descriptions, a lot of platforms have not
come that far:

In shmobile, we add two new board files because their recently started
effort to add DT support has not proceeded enough to use it for all of
the important hardware.

In Kirkwood, we are adding support for new boards with a combination of
DT and board file contents in multiple cases.

pxa/mmp and imx are extending support for existing board files but not
adding new ones.

Conflicts caused by this branch merge are three add/add conflicts:
* mach-mmp include file add/add context. Keep both.
* mach-shmobile add/add context conflicts due to one board being merged
  through the soc branch, the other here. Keep both, make sure to have
  a select USE_OF on both in Kconfig.

----------------------------------------------------------------

The following changes since commit ec98e8b8888dc92aacefc63e41d5237b7fd14ad8:

  Merge tag 'pm' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards

for you to fetch changes up to 48a5765e5104f1afd22c75c5030af3a6cf24b4c3:

  Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards

----------------------------------------------------------------

Alex Gershgorin (1):
      ARM: i.MX: i.MX35-PDK: Add regulator support

Ameya Palande (1):
      ARM: OMAP: rx51: Platform support for lis3lv02d accelerometer

Arnaud Patard (3):
      kirkwood/orion: fix orion_gpio_set_blink
      orion/kirkwood: create a generic function for gpio led blinking
      kirkwood: Add iconnect support

Arnd Bergmann (5):
      Merge branch 'next/board-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/boards
      Merge branch 'board-new' of git://git.kernel.org/.../rafael/renesas into next/boards
      Merge branch 'kirkwood_boards_for_v3.5' of git://git.infradead.org/users/jcooper/linux into next/boards
      ARM: shmobile: fix smp build
      Merge branch 'renesas/board2' into next/boards

Ashwin Bihari (1):
      Add MSUB support for the LogicPD OMAP3530 DevKits

Axel Lin (1):
      ARM: pxa: Use REGULATOR_SUPPLY macro

Denis Carikli (1):
      ARM: imx: eukrea_mbimxsd: add backlight and lcd support

Eric Bénard (11):
      ARM: imx: eukrea_cpuimx25: enable workaround ENGcm09152
      ARM: imx: eukrea_mbimxsd25: add spi controler and spidev support
      ARM: imx: eukrea_cpuimx25: add watchdog support
      ARM: imx: eukrea_mbimxsd35: add spi controler and spidev support
      ARM: imx: eukrea-cpuimx51: remove board
      ARM: imx: eukrea_cpuimx51sd: add watchdog support
      ARM: imx: eukrea_mbimxsd: add audio support
      ARM: imx: eukrea_cpuimx51sd: support rev2 PCB
      ARM: imx: eukrea_mbimxsd25: don't free twice GPIO_SWITCH1
      ARM: imx: eukrea_mbimxsd25: use IMX_GPIO_NR
      ARM: imx: eukrea_mbimxsd rename to eukrea_mbimxsd51

Govindraj.R (1):
      ARM: OMAP: omap2plus_defconfig: Enable ehci-omap and sms95xx support

Guennadi Liakhovetski (1):
      ARM: mach-shmobile: sh7372 CEU supports up to 8188x8188 images

Igor Grinberg (1):
      ARM: OMAP3: cm-t35: add support for power off

Jamie Lentin (4):
      ARM: kirkwood: Basic support for DNS-320 and DNS-325
      mtd: Add orion_nand devicetree bindings
      kirkwood: Allow nand to be configured via. devicetree
      ARM: kirkwood: Define DNS-320/DNS-325 NAND in fdt

Javier Martin (1):
      ARM i.MX: Visstrim_M10: Add board version detection.

Javier Martinez Canillas (2):
      ARM: OMAP2+: nand: Make board_onenand_init() visible to board code
      ARM: OMAP3: igep0020: Add support for Micron NAND Flash storage memory

Kuninori Morimoto (29):
      ARM: mach-shmobile: mackerel: Add FSI DMAEngine support
      ARM: mach-shmobile: bonito: make sure static function
      ARM: mach-shmobile: add armadillo800eva board support.
      ARM: mach-shmobile: armadillo800eva: add defconfig
      ARM: mach-shmobile: armadillo800eva: add support LCDC0
      ARM: mach-shmobile: armadillo800eva: add support gpio_key
      ARM: mach-shmobile: armadillo800eva: add support sh_eth
      ARM: mach-shmobile: armadillo800eva: add support ST1232
      ARM: mach-shmobile: armadillo800eva: add USB function support
      ARM: mach-shmobile: armadillo800eva: add SDHI0 support
      ARM: mach-shmobile: armadillo800eva: add SDHI1 support
      ARM: mach-shmobile: armadillo800eva: add MMCIF support
      ARM: mach-shmobile: r8a7740: reserve DMA memory for the frame buffer
      ARM: mach-shmobile: clock-r8a7740: add sh-eth clock
      ARM: mach-shmobile: armadillo800eva: defconfig update
      ARM: mach-shmobile: add KZM-A9-GT board support
      ARM: mach-shmobile: kzm9g: add defconfig
      ARM: mach-shmobile: kzm9g: add SMSC 9221 support
      ARM: mach-shmobile: kzm9g: add external USB Host support
      ARM: mach-shmobile: kzm9g: add LCDC support
      ARM: mach-shmobile: kzm9g: add ST1232 Touchscreen support
      ARM: mach-shmobile: pfc-sh73a0: fixup MSEL2CR MSEL18 for I2C-3
      ARM: mach-shmobile: sh73a0.h: add GPIO_NR
      ARM: mach-shmobile: kzm9g: correct screen direction
      ARM: mach-shmobile: kzm9g: add MMCIF support
      ARM: mach-shmobile: kzm9g: add SDHI support
      ARM: mach-shmobile: kzm9g: add PCF8757 gpio-key
      ARM: mach-shmobile: kzm9g: defconfig update
      ARM: mach-shmobile: kzm9g: enable SMP boot

Magnus Damm (2):
      ARM: mach-shmobile: Use DT_MACHINE for KZM9G
      ARM: mach-shmobile: Use DT_MACHINE for armadillo 800 eva

Mans Rullgard (1):
      ARM: OMAP2+: craneboard: register emac device

Marek Szyprowski (2):
      ARM: EXYNOS: Add DRM core device support for Universal C210 board
      ARM: EXYNOS: Add DRM core support for NURI board

Mark Brown (1):
      ARM: S3C64XX: Hook up new style regulator-regulator supplies on Cragganmore

Mircea Gherzan (1):
      ARM: OMAP: WiLink platform data for the PandaBoard

Neil Zhang (4):
      ARM: mmp: add usb device support for PXA910
      ARM: mmp: add usb device support for ttc dkb
      ARM: mmp: add usb host support for PXA168
      ARM: mmp: add usb host support for aspen

Olof Johansson (6):
      Merge tag 'imx-features-board-20120411-2' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards
      Merge tag 'imx-eukrea' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge tag 'omap-board-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'board' of git://git.kernel.org/.../rafael/renesas into next/boards
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards

Paul Parsons (6):
      ARM: pxa: hx4700: Initialize DS1WM clock_rate
      ARM: pxa: hx4700: Enable ASIC3 GPIO as a wakeup source
      ARM: pxa: hx4700: Add PCMCIA/CF support
      ARM: pxa: Add standard UART to hx4700_pin_config[]
      pcmcia: add driver for hx4700
      ARM: pxa: hx4700: Add Synaptics NavPoint touchpad

Peter Ujfalusi (3):
      OMAP4: twl-common: Add twl6030 V1V8, V2V1 SMPS common configuration
      OMAP: 4430SDP: Use common configuration for V1V8, V2V1 supplies
      OMAP: omap4panda: Use common configuration for V1V8, V2V1 supplies

Rafael J. Wysocki (3):
      Merge branch 'renesas-kzm9g' into renesas-board-new
      Merge branch 'renesas-armadillo800eva' into renesas-board-new
      Merge branch 'renesas-kzm9g' into renesas-board-new

Ricardo Neri (3):
      ARM: OMAP: devices: Register platform devices for HDMI audio
      ARM: OMAP4: board-4430sdp: Register platform device for HDMI audio codec
      ARM: OMAP4: board-omap4panda: Register platform device for HDMI audio codec

Robert Jarzmik (1):
      ARM: pxa: mioa701 add camera output enable gpio

Russ Dill (1):
      ARM: OMAP: Mark Beagleboard-xM MMC bus as 4-bit

Sachin Kamat (5):
      ARM: EXYNOS: Make BT platform data structure static in mach-origen.c file
      ARM: EXYNOS: Add DRM device to Origen
      ARM: EXYNOS: Add DRM device to SMDKV310
      ARM: EXYNOS: Add MFC device to SMDK4X12
      ARM: EXYNOS: Add FIMC device to SMDK4X12

Santosh Shilimkar (1):
      ARM: OMAP2PLUS: Enable HIGHMEM

Sascha Hauer (1):
      ARM: pxa: use ioremap to access CPLD

Simon Baatz (1):
      ARM: kirkwood: Add support for RaidSonic IB-NAS6210/6220 using devicetree

Tushar Behera (1):
      ARM: EXYNOS: Increase framebuffer virtual size for origen

Uwe Kleine-König (1):
      ARM: imx_v4_v5_defconfig: enable adc and touch driver of mc13783


 .../devicetree/bindings/mtd/orion-nand.txt      |  50 ++
 arch/arm/boot/dts/kirkwood-dns320.dts           |  64 ++
 arch/arm/boot/dts/kirkwood-dns325.dts           |  59 ++
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |  44 ++
 arch/arm/boot/dts/kirkwood-iconnect.dts         |  26 +
 arch/arm/boot/dts/kirkwood.dtsi                 |  15 +-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts   |  22 +
 arch/arm/boot/dts/sh73a0-kzm9g.dts              |  22 +
 arch/arm/configs/armadillo800eva_defconfig      | 142 ++++
 arch/arm/configs/imx_v4_v5_defconfig            |   4 +-
 arch/arm/configs/kzm9g_defconfig                | 139 ++++
 arch/arm/configs/omap2plus_defconfig            |   2 +
 arch/arm/mach-exynos/Kconfig                    |   9 +
 arch/arm/mach-exynos/mach-nuri.c                |  33 +
 arch/arm/mach-exynos/mach-origen.c              |  35 +-
 arch/arm/mach-exynos/mach-smdk4x12.c            |  16 +
 arch/arm/mach-exynos/mach-smdkv310.c            |  30 +
 arch/arm/mach-exynos/mach-universal_c210.c      |  33 +
 arch/arm/mach-imx/Kconfig                       |  35 +-
 arch/arm/mach-imx/Makefile                      |   4 +-
 arch/arm/mach-imx/eukrea_mbimx51-baseboard.c    | 206 -----
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c  |  51 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c  |  42 +
 ...baseboard.c => eukrea_mbimxsd51-baseboard.c} | 120 ++-
 arch/arm/mach-imx/mach-cpuimx51.c               | 301 -------
 arch/arm/mach-imx/mach-cpuimx51sd.c             |  50 +-
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c        |   2 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |  55 ++
 arch/arm/mach-imx/mach-mx35_3ds.c               | 193 +++++
 arch/arm/mach-kirkwood/Kconfig                  |  22 +
 arch/arm/mach-kirkwood/Makefile                 |   3 +
 arch/arm/mach-kirkwood/Makefile.boot            |   4 +
 arch/arm/mach-kirkwood/board-dnskw.c            | 275 +++++++
 arch/arm/mach-kirkwood/board-dt.c               |  13 +
 arch/arm/mach-kirkwood/board-ib62x0.c           | 143 ++++
 arch/arm/mach-kirkwood/board-iconnect.c         | 165 ++++
 arch/arm/mach-kirkwood/common.c                 |  12 +
 arch/arm/mach-kirkwood/common.h                 |  18 +
 arch/arm/mach-mmp/Kconfig                       |   7 +
 arch/arm/mach-mmp/aspenite.c                    |  20 +
 arch/arm/mach-mmp/devices.c                     | 282 +++++++
 arch/arm/mach-mmp/include/mach/devices.h        |   3 +
 arch/arm/mach-mmp/include/mach/pxa168.h         |   8 +-
 arch/arm/mach-mmp/include/mach/pxa910.h         |   3 +
 arch/arm/mach-mmp/include/mach/regs-usb.h       | 253 ++++++
 arch/arm/mach-mmp/pxa168.c                      |  20 +-
 arch/arm/mach-mmp/pxa910.c                      |   2 +-
 arch/arm/mach-mmp/ttc_dkb.c                     |  37 +
 arch/arm/mach-omap2/Kconfig                     |   1 +
 arch/arm/mach-omap2/board-4430sdp.c             |  10 +-
 arch/arm/mach-omap2/board-am3517crane.c         |   2 +
 arch/arm/mach-omap2/board-cm-t35.c              |   5 +
 arch/arm/mach-omap2/board-flash.c               |   4 +-
 arch/arm/mach-omap2/board-flash.h               |  11 +
 arch/arm/mach-omap2/board-igep0020.c            |  74 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |   7 +-
 arch/arm/mach-omap2/board-omap3logic.c          |  26 +-
 arch/arm/mach-omap2/board-omap4panda.c          |  24 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |  88 ++-
 arch/arm/mach-omap2/devices.c                   |  31 +
 arch/arm/mach-omap2/twl-common.c                |  43 +
 arch/arm/mach-omap2/twl-common.h                |   2 +
 arch/arm/mach-orion5x/dns323-setup.c            |  25 +-
 arch/arm/mach-pxa/balloon3.c                    |   4 +-
 arch/arm/mach-pxa/cm-x300.c                     |   4 +-
 arch/arm/mach-pxa/em-x270.c                     |   5 +-
 arch/arm/mach-pxa/hx4700.c                      |  47 +-
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h     |   1 +
 arch/arm/mach-pxa/include/mach/mioa701.h        |   3 +
 .../mach-pxa/include/mach/pcm990_baseboard.h    |  68 +-
 arch/arm/mach-pxa/magician.c                    |   8 +-
 arch/arm/mach-pxa/mioa701.c                     |   6 +-
 arch/arm/mach-pxa/palm27x.c                     |   4 +-
 arch/arm/mach-pxa/pcm990-baseboard.c            |  83 +-
 arch/arm/mach-pxa/spitz.c                       |   4 +-
 arch/arm/mach-pxa/stargate2.c                   |   5 +-
 arch/arm/mach-pxa/vpac270.c                     |   4 +-
 arch/arm/mach-pxa/z2.c                          |   4 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c           |  18 +
 arch/arm/mach-shmobile/Kconfig                  |  18 +-
 arch/arm/mach-shmobile/Makefile                 |   2 +
 arch/arm/mach-shmobile/board-ap4evb.c           |   2 +
 arch/arm/mach-shmobile/board-armadillo800eva.c  | 784 +++++++++++++++++++
 arch/arm/mach-shmobile/board-bonito.c           |   2 +-
 arch/arm/mach-shmobile/board-kzm9g.c            | 460 +++++++++++
 arch/arm/mach-shmobile/board-mackerel.c         |  10 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |   3 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h    |   3 +
 arch/arm/mach-shmobile/pfc-sh73a0.c             |   4 +-
 arch/arm/mach-shmobile/platsmp.c                |   3 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          |   7 +
 arch/arm/plat-orion/gpio.c                      |  27 +-
 arch/arm/plat-orion/include/plat/gpio.h         |   2 +
 drivers/mtd/nand/orion_nand.c                   |  47 +-
 drivers/pcmcia/Kconfig                          |   2 +-
 drivers/pcmcia/Makefile                         |   1 +
 drivers/pcmcia/pxa2xx_hx4700.c                  | 121 +++
 include/linux/mfd/asic3.h                       |   1 +
 include/linux/ti_wilink_st.h                    |   2 +
 99 files changed, 4393 insertions(+), 823 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/orion-nand.txt
 create mode 100644 arch/arm/boot/dts/kirkwood-dns320.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-dns325.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-ib62x0.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-iconnect.dts
 create mode 100644 arch/arm/boot/dts/r8a7740-armadillo800eva.dts
 create mode 100644 arch/arm/boot/dts/sh73a0-kzm9g.dts
 create mode 100644 arch/arm/configs/armadillo800eva_defconfig
 create mode 100644 arch/arm/configs/kzm9g_defconfig
 delete mode 100644 arch/arm/mach-imx/eukrea_mbimx51-baseboard.c
 rename arch/arm/mach-imx/{eukrea_mbimxsd-baseboard.c => eukrea_mbimxsd51-baseboard.c} (51%)
 delete mode 100644 arch/arm/mach-imx/mach-cpuimx51.c
 create mode 100644 arch/arm/mach-kirkwood/board-dnskw.c
 create mode 100644 arch/arm/mach-kirkwood/board-ib62x0.c
 create mode 100644 arch/arm/mach-kirkwood/board-iconnect.c
 create mode 100644 arch/arm/mach-mmp/include/mach/regs-usb.h
 create mode 100644 arch/arm/mach-shmobile/board-armadillo800eva.c
 create mode 100644 arch/arm/mach-shmobile/board-kzm9g.c
 create mode 100644 drivers/pcmcia/pxa2xx_hx4700.c
