Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2CXWEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab2CXWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: =?UTF-8?q?=5BGIT=20PULL=2006/09=5D=20ARM=3A=20board=20specific=20updates?=
Date: Sat, 24 Mar 2012 22:02:45 +0000
Message-Id: <1332626568-17812-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:+pwkNUepJdM/i/gXUmE1bCU0QsiBaPhRxoVlpEjbNqM
 ZllsnFnOKkVDQMlNTslUkhbIyHFFV88uxLK3k9ytAkRB9uiTGj
 kMcDNyfegIRep7sRDU2JkYa0a8N+MZCO5HZZF4AGFAvvDxJH+C
 mnrCr1b1qwmSBnwOT4+c8lS/DbIOsQfJofrWjLG6A0+EynOeH5
 NTltY8LMesy0DzR5M4uuA8+k3eiGxU0Aw/SbxJeTgVsTqCiKYI
 ojQxBs5vJKWUYXllbtiTd6ibUBtibZyJ+IDbiONzMUBk9TC1Xu
 +P4EBypJ2y7kEYP7bQqRSIfPZ7PgFuk/ZM1Iwq701YgqaPiqOZ
 d7FE/NZd1pTbxhqLPb3A52Ecp5TexSISQGqw9uBeh7f+eMChNq
 UBl4P/52+oEBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes are all specific to one board only. We're trying to keep
the number of board files low, but generally board level updates are
ok on platforms that are working on moving towards DT based probing,
which will eventually lead to removing them.

The board-ams-delta.c board file gets a conflict between the removal of
ams_delta_config and the addition of a lot of other data. The Kconfig
file has two changes in the same line, and in exynos, the power domain
cleanup conflicts with the addition of the image sensor device.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "abd43e4 Merge branch 'next/boards'
into for-next", leading up to commit " b9e1122 Merge tag 'asoc-3.4'
of git://git.kernel.org/pub/scm", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards

Aaro Koskinen (1):
      ARM: OMAP: add minimal support for Nokia RM-696

Alex (1):
      ARM: OMAP: Add omap_reserve functionality

Alex Gershgorin (1):
      i.MX35-PDK: Add Camera support

Andrzej Pietrasiewicz (2):
      ARM: EXYNOS: Register JPEG on universal_c210
      ARM: EXYNOS: Register JPEG on nuri

Arnd Bergmann (11):
      Merge branch 'kirkwood/board' into next/boards
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards
      Merge branch 'omap1' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'features/imx27-visstrim' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'features/imx31-moboard' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge tag 'tegra-boards' of git://git.kernel.org/.../olof/tegra into tegra/boards
      Merge branch 'board-specific' of git://github.com/hzhuang1/linux into next/boards
      Merge tag 'imx35-cam-fb' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'for-3.4/boards' of git://git.kernel.org/.../olof/tegra into next/boards
      Merge tag 'asoc-3.4' of git://git.kernel.org/.../broonie/sound into next/boards
      Merge branch 'next/boards' into for-next

Fabio Estevam (2):
      ARM: mx28: Remove duplicate OCOTP error message
      ARM: mx28evk: Simplify GPIO requests

Grazvydas Ignotas (1):
      ARM: OMAP: pandora: add support for backlight and poweroff

Haojian Zhuang (2):
      ARM: mmp: append irq name of gpio device
      ARM: pxa: add dummy clock for pxa25x and pxa27x

Igor Grinberg (1):
      ARM: OMAP3: cm-t3517: add EMAC support

Ilya Yanok (1):
      ARM: OMAP: move generic EMAC init to separate file

Janusz Krzysztofik (12):
      ARM: OMAP1: ams-delta: register latch dependent devices later
      ARM: OMAP1: ams-delta: convert latches to basic_mmio_gpio
      ARM: OMAP1: ams-delta: supersede custom led device by leds-gpio
      LED: drop leds-ams-delta driver
      MTD: NAND: ams-delta: use GPIO instead of custom I/O
      omapfb: lcd_ams_delta: drive control lines over GPIO
      input: serio: ams-delta: toggle keyboard power over GPIO
      ARM: OMAP1: ams-delta: fix incorrect section tags
      ARM: OMAP1: ams-delta: clean up init data section assignments
      ARM: OMAP1: ams-delta: set up regulator over modem reset GPIO pin
      ARM: OMAP1: ams-delta: update the modem to use regulator API
      ASoC: OMAP: ams-delta: drop .set_bias_level callback

Jason Cooper (2):
      ARM: kirkwood: add dreamplug (fdt) support.
      ARM: kirkwood: convert uart0 to devicetree.

Javier Martin (5):
      i.MX27: visstrim_m10: Add m41t00 RTC support.
      i.MX27: visstrim_m10: Sort IMX_HAVE_PLATFORM_MXC_MMC properly.
      i.MX27: visstrim_m10: Register I2C devices after I2C busses have been added.
      i.MX27: visstrim_m10: Add video support.
      i.MX27: visstrim_m10: Add led support.

Kamil Debski (2):
      ARM: EXYNOS: add G2D to mach-nuri
      ARM: EXYNOS: add G2D to mach-universal

Lauri Hintsala (1):
      ARM: mxs: Add initial support for Bluegiga APX4 Development Kit

Marc Dietrich (3):
      ARM: dt: tegra: add ADT7461 temperature sensor to paz00 device tree
      ARM: dt: tegra: add the power gpio key to paz00 device tree
      ARM: dt: tegra: add the wifi led to paz00 device tree

Mark Brown (8):
      ARM: S3C64XX: Support GPIO LEDs on Cragganmore
      ARM: S3C64XX: Fix build of Cragganmore after SPI changes
      ARM: S3C64XX: Enable power management for disk on Cragganmore
      ARM: S3C64XX: Enable power management for WiFi on Cragganmore
      ARM: S3C64XX: Add hookup for Tomatin module on Cragganmore
      ARM: S3C64XX: Add a SPKVDD supply for CODECs on Cragganmore
      ARM: S3C64XX: Add some more Cragganmore module IDs to the table
      ARM: S3C64XX: Supply platform data for SPI on Cragganmore

Mircea Gherzan (1):
      ARM: OMAP: enable Bluetooth on the PandaBoard

MyungJoo Ham (1):
      ARM: EXYNOS: support Exynos4210-bus Devfreq driver on Nuri board

Olof Johansson (4):
      Merge branch 'mxs/boards' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/boards
      Merge branch 'ams-delta' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'board' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge branch 'next/board-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/boards

Paul Parsons (6):
      pxa/hx4700: Correct StrataFlash block size discovery
      pxa/hx4700: Add ASIC3 LED support
      pxa/hx4700: Fix PXA_GPIO_IRQ_BASE/IRQ_NUM values
      ARM: pxa/hx4700: Remove unwanted request for GPIO105
      ARM: pxa/hx4700: Reduce sleep mode battery discharge by 35%
      pxa/hx4700: Remove pcmcia platform_device structure

Philippe Rétornaz (2):
      mx31moboard: update maintainer
      mx31moboard: Add watchdog support

Sachin Kamat (13):
      ARM: EXYNOS: Enable G2D on ORIGEN
      ARM: S5PV210: Add missing FIMC media device to Aquila
      ARM: EXYNOS: Add missing FIMC media device to SMDKV310
      ARM: EXYNOS: Add missing FIMC media device to Origen
      ARM: EXYNOS: Enable G2D on SMDKV310
      ARM: S5PV210: Enable MFC on SMDKV210
      ARM: S5PV210: Enable MFC on SMDKC110
      ARM: S5PV210: Enable FIMC on SMDKV210
      ARM: S5PV210: Enable FIMC on SMDKC110
      ARM: EXYNOS: Enable JPEG on SMDKV310
      ARM: EXYNOS: Enable JPEG on Origen
      ARM: S5PV210: Add JPEG board definition
      ARM: S5PV210: Enable JPEG on SMDKV210

Sangwook Lee (1):
      ARM: EXYNOS: Enable Bluetooth on ORIGEN

Shawn Guo (1):
      ARM: mxs: detect SoC by checking CHIPID register

Stephen Warren (2):
      ARM: tegra: match SoC name not board name in DT board files
      ARM: tegra: update defconfig

Sylwester Nawrocki (3):
      ARM: EXYNOS: Increase virtual framebuffer size on Universal C210 board
      ARM: EXYNOS: Add support for S5K6AAFX image sensor on Universal C210 board
      ARM: SAMSUNG: Add support for S5K6AAFX camera on Nuri board

Thierry Reding (1):
      ARM: tegra: PCIe: Provide 3.3V supply voltage

Tony Lindgren (2):
      Merge branch 'omap1-part2' into omap1
      Merge branch 'omap1' into ams-delta

Tushar Behera (2):
      ARM: EXYNOS: Add __init attribute to nuri_camera_init()
      ARM: EXYNOS: Add __init attribute to universal_camera_init()

Uwe Kleine-König (1):
      ARM: OMAP4: board-4430sdp: don't initialize value that is never used

Vladimir Zapolskiy (1):
      ARM: OMAP3: RX-51: add explicit mux configuration of tsc2005 control gpios

Wolfram Sang (1):
      ARM: mxs: read correct values when setting up MAC

wu guoxing (1):
      ARM : mx35: 3ds-board: add framebuffer device


 arch/arm/Kconfig                                  |    1 +
 arch/arm/boot/dts/kirkwood-dreamplug.dts          |   25 ++
 arch/arm/boot/dts/kirkwood.dtsi                   |    6 +
 arch/arm/boot/dts/tegra-paz00.dts                 |   26 ++
 arch/arm/configs/tegra_defconfig                  |   33 ++-
 arch/arm/mach-exynos/Kconfig                      |   10 +
 arch/arm/mach-exynos/mach-nuri.c                  |   80 +++++-
 arch/arm/mach-exynos/mach-origen.c                |   37 +++
 arch/arm/mach-exynos/mach-smdkv310.c              |    3 +
 arch/arm/mach-exynos/mach-universal_c210.c        |   80 +++++-
 arch/arm/mach-imx/Kconfig                         |    5 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c       |  139 +++++++++-
 arch/arm/mach-imx/mach-mx31moboard.c              |    4 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                 |  216 ++++++++++++++
 arch/arm/mach-kirkwood/Kconfig                    |   14 +
 arch/arm/mach-kirkwood/Makefile                   |    1 +
 arch/arm/mach-kirkwood/Makefile.boot              |    2 +
 arch/arm/mach-kirkwood/board-dt.c                 |  180 ++++++++++++
 arch/arm/mach-mmp/mmp2.c                          |    1 +
 arch/arm/mach-mmp/pxa168.c                        |    1 +
 arch/arm/mach-mmp/pxa910.c                        |    1 +
 arch/arm/mach-mxs/Kconfig                         |   16 +
 arch/arm/mach-mxs/Makefile                        |    1 +
 arch/arm/mach-mxs/include/mach/digctl.h           |    1 +
 arch/arm/mach-mxs/include/mach/mxs.h              |   29 +-
 arch/arm/mach-mxs/include/mach/uncompress.h       |   13 +-
 arch/arm/mach-mxs/mach-apx4devkit.c               |  260 +++++++++++++++++
 arch/arm/mach-mxs/mach-m28evk.c                   |    7 +-
 arch/arm/mach-mxs/mach-mx28evk.c                  |   80 ++----
 arch/arm/mach-omap1/Kconfig                       |    4 +
 arch/arm/mach-omap1/board-ams-delta.c             |  314 ++++++++++++++++++---
 arch/arm/mach-omap2/Kconfig                       |    3 +-
 arch/arm/mach-omap2/Makefile                      |    3 +
 arch/arm/mach-omap2/am35xx-emac.c                 |  117 ++++++++
 arch/arm/mach-omap2/am35xx-emac.h                 |   15 +
 arch/arm/mach-omap2/board-4430sdp.c               |    5 +-
 arch/arm/mach-omap2/board-am3517evm.c             |  117 +--------
 arch/arm/mach-omap2/board-cm-t3517.c              |    2 +
 arch/arm/mach-omap2/board-omap3logic.c            |    2 +
 arch/arm/mach-omap2/board-omap3pandora.c          |   11 +
 arch/arm/mach-omap2/board-omap4panda.c            |    6 +
 arch/arm/mach-omap2/board-rm680.c                 |   14 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c      |   25 +-
 arch/arm/mach-pxa/hx4700.c                        |   44 ++--
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h       |    2 +
 arch/arm/mach-s3c64xx/Kconfig                     |    1 +
 arch/arm/mach-s3c64xx/mach-crag6410-module.c      |   31 ++-
 arch/arm/mach-s3c64xx/mach-crag6410.c             |   67 +++++-
 arch/arm/mach-s5pv210/Kconfig                     |    9 +
 arch/arm/mach-s5pv210/clock.c                     |    5 +
 arch/arm/mach-s5pv210/include/mach/map.h          |    4 +
 arch/arm/mach-s5pv210/mach-aquila.c               |    1 +
 arch/arm/mach-s5pv210/mach-smdkc110.c             |   14 +
 arch/arm/mach-s5pv210/mach-smdkv210.c             |   15 +
 arch/arm/mach-tegra/board-dt-tegra20.c            |    6 +-
 arch/arm/mach-tegra/board-dt-tegra30.c            |    2 +-
 arch/arm/mach-tegra/board-harmony-power.c         |    3 +-
 arch/arm/plat-omap/include/plat/board-ams-delta.h |   49 ++--
 arch/arm/plat-omap/include/plat/uncompress.h      |    1 +
 drivers/input/serio/ams_delta_serio.c             |   54 +++--
 drivers/leds/Kconfig                              |    7 -
 drivers/leds/Makefile                             |    1 -
 drivers/leds/leds-ams-delta.c                     |  126 --------
 drivers/mtd/nand/ams-delta.c                      |   74 ++++--
 drivers/video/omap/lcd_ams_delta.c                |   27 ++-
 sound/soc/omap/ams-delta.c                        |   34 +---
 66 files changed, 1929 insertions(+), 558 deletions(-)
