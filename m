Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2JAX5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:57:36 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57381 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JAX5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:31 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=201/12=5D=20ARM=3A=20soc=3A=20non-critical=20bug=20fixes?=
Date: Mon,  1 Oct 2012 16:56:56 -0700
Message-Id: <1349135827-24790-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were submitted as bug fixes before v3.6 but not considered important
enough to be included in it. Some of them cross over to cleanup territory
as well, and aren't strictly bugfixes.


Conflicts: none

----------------------------------------------------------------

The following changes since commit d9a807461fc8cc0d6ba589ea0730d139122af012:

  Merge tag 'usb-3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-non-critical

for you to fetch changes up to b10dcdcac43b2b5adf800a19f782fef38ada75a1:

  Merge tag 'ep93xx-fixes-for-3.7' of git://github.com/RyanMallon/linux-ep93xx into next/fixes-non-critical

----------------------------------------------------------------

Arnd Bergmann (8):
      watchdog/mpc8xxx: add a const qualifier
      powerpc/fsl_msi: drop unneeded cast to non-const pointer
      mfd/da9052: make i2c_device_id array const
      i2c/mpc: make data used as *of_device_id.data const
      macintosh/mediabay: make data used as *of_device_id.data const
      can: mpc5xxx_can: make data used as *of_device_id.data const
      ARM: ep93xx: use __iomem pointers for MMIO
      ARM: nomadik: remove NAND_NO_READRDY use

Axel Lin (2):
      ARM: ux500: Fix build error due to missing include of asm/pmu.h in cpu-db8500.c
      ARM: ep93xx: Fix build error due to 'SZ_32M' undeclared

David Brown (1):
      ARM: msm: Remove call to missing FPGA init on 8660

Julia Lawall (1):
      ARM: S3C24xx: delete double assignment

Kukjin Kim (1):
      ARM: EXYNOS: fix address for EXYNOS4 MDMA1

Laxman Dewangan (2):
      dma: tegra: make tegra_dma.chip_data a pointer to const data
      dma: tegra: make data used as *of_device_id.data const

Lee Jones (1):
      ARM: ux500: Provide SMSC911x fixed-regulator when not booting DT

Linus Walleij (1):
      ARM: ux500: set proper GIC flags

Olof Johansson (9):
      Merge branch 'ofdeviceiddata' of git://git.pengutronix.de/git/ukl/linux into next/fixes-non-critical
      Merge tag 'ux500-core-updates' of http://git.kernel.org/.../linusw/linux-stericsson into next/fixes-non-critical
      Merge tag 'imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical
      Merge tag 'msm-fix-noncrit-for-3.7' of git://git.kernel.org/.../davidb/linux-msm into next/fixes-non-critical
      Merge tag 'tegra-for-3.7-fixes' of git://git.kernel.org/.../swarren/linux-tegra into next/fixes-non-critical
      Merge tag 'omap-fixes-noncritical-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'v3.7-samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      Merge branch 'pxa/fixes' into next/fixes-non-critical
      Merge tag 'ep93xx-fixes-for-3.7' of git://github.com/RyanMallon/linux-ep93xx into next/fixes-non-critical

Paul Walmsley (1):
      ARM: OMAP4: wakeupgen: remove duplicate AUXCOREBOOT* read/write

Peter De Schrijver (2):
      ARM: tegra: fix return value for debugfs init
      ARM: tegra: fix debugfs entry for Tegra30

Peter Senna Tschudin (1):
      ARM: S3C24XX: removes unnecessary semicolon

Rohit Vaswani (2):
      ARM: msm: io: Remove 7x30 iomap region from 7x00
      ARM: msm: io: Change the default static iomappings to be shared

Ryan Mallon (1):
      ARM: ep93xx: Move ts72xx.h out of include/mach

Santosh Shilimkar (1):
      ARM: OMAP4: wakeupgen: Fix the typo in AUXCOREBOOT register save

Seung-Woo Kim (1):
      ARM: EXYNOS: fixed SYSMMU setup definition to mate parameter name

Stephen Boyd (1):
      ARM: msm: Fix early debug uart mapping on some memory configs

Stephen Warren (1):
      ARM: enable SUSPEND/ARCH_SUSPEND_POSSIBLE for ARCH_TEGRA

Sylwester Nawrocki (1):
      ARM: SAMSUNG: Add missing variable declaration in s3c64xx_spi1_set_platdata()

Uwe Kleine-König (17):
      spi/imx: make spi_imx_data.devtype_data member point to const data
      spi/spi-omap2-mcspi: add a const qualifier
      serial/imx: make imx_port.devdata member point to const data
      serial/mpc52xx_uart: add a const qualifier
      ARM: cache-l2x0: add a const qualifier
      misc/atmel_tc: make atmel_tc.tcb_config member point to const data
      gpio/gpio-omap.c: add a const qualifier
      gpio/mpc8xxx: add a const qualifier
      i2c/i2c-omap: add a const qualifier
      i2c/mpc: add a const qualifier
      mmc/omap_hsmmc: add a const qualifier
      macintosh/mediabay: add a const qualifier
      powerpc/83xx: add a const qualifier
      powerpc/fsl_msi: add a const qualifier
      powerpc/celleb_pci: add a const qualifier
      of: add const to struct *of_device_id.data
      gpio/gpio-omap: make platformdata used as *of_device_id.data const

Wei Yongjun (2):
      gpio/omap: fix possible memory leak in omap2_gpio_dev_init()
      ARM: pxa: fix return value check in pxa2xx_drv_pcmcia_probe()


 arch/arm/Kconfig                                |  2 +-
 arch/arm/mach-ep93xx/adssphere.c                |  1 +
 arch/arm/mach-ep93xx/gesbc9312.c                |  1 +
 arch/arm/mach-ep93xx/ts72xx.c                   | 12 +++---
 .../arm/mach-ep93xx/{include/mach => }/ts72xx.h | 10 ++---
 arch/arm/mach-exynos/include/mach/map.h         |  2 +-
 arch/arm/mach-exynos/include/mach/sysmmu.h      |  2 +-
 arch/arm/mach-msm/board-msm8x60.c               |  5 ---
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |  2 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |  2 +-
 arch/arm/mach-msm/io.c                          | 25 ++++++------
 arch/arm/mach-nomadik/board-nhk8815.c           |  3 +-
 arch/arm/mach-omap2/gpio.c                      |  2 +
 arch/arm/mach-omap2/omap-wakeupgen.c            |  8 +---
 arch/arm/mach-s3c24xx/mach-h1940.c              |  4 +-
 arch/arm/mach-tegra/powergate.c                 | 43 ++++++++++++++++----
 arch/arm/mach-ux500/Kconfig                     |  1 +
 arch/arm/mach-ux500/board-mop500-regulators.c   | 15 +++++++
 arch/arm/mach-ux500/board-mop500-regulators.h   |  1 +
 arch/arm/mach-ux500/board-mop500.c              | 19 +++++++++
 arch/arm/mach-ux500/cpu-db8500.c                |  1 +
 arch/arm/mach-ux500/cpu.c                       |  2 +
 arch/arm/mm/cache-l2x0.c                        |  2 +-
 arch/arm/plat-samsung/devs.c                    |  2 +
 arch/powerpc/platforms/83xx/suspend.c           |  2 +-
 arch/powerpc/platforms/cell/celleb_pci.c        |  2 +-
 arch/powerpc/sysdev/fsl_msi.c                   |  8 ++--
 drivers/dma/tegra20-apb-dma.c                   |  8 ++--
 drivers/gpio/gpio-mpc8xxx.c                     |  2 +-
 drivers/gpio/gpio-omap.c                        |  8 ++--
 drivers/i2c/busses/i2c-mpc.c                    | 12 +++---
 drivers/i2c/busses/i2c-omap.c                   |  3 +-
 drivers/macintosh/mediabay.c                    |  8 ++--
 drivers/mfd/da9052-i2c.c                        |  4 +-
 drivers/mmc/host/omap_hsmmc.c                   |  2 +-
 drivers/net/can/mscan/mpc5xxx_can.c             |  4 +-
 drivers/pcmcia/pxa2xx_base.c                    |  2 +-
 drivers/spi/spi-imx.c                           |  2 +-
 drivers/spi/spi-omap2-mcspi.c                   |  2 +-
 drivers/tty/serial/mpc52xx_uart.c               |  2 +-
 drivers/watchdog/mpc8xxx_wdt.c                  |  2 +-
 include/linux/atmel_tc.h                        |  2 +-
 include/linux/mod_devicetable.h                 |  2 +-
 43 files changed, 154 insertions(+), 90 deletions(-)
 rename arch/arm/mach-ep93xx/{include/mach => }/ts72xx.h (89%)
