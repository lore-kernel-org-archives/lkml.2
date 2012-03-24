Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2CXWEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab2CXWDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: =?UTF-8?q?=5BGIT=20PULL=2008/09=5D=20ARM=3A=20driver=20specific=20updates?=
Date: Sat, 24 Mar 2012 22:02:47 +0000
Message-Id: <1332626568-17812-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:1gXXKZmH5ujq9W1CWME3w/IMHIGExTFoz+Fqfc5uzG2
 UEMre310dCNaBh/zrMU0nKXLgGB0umjywUhbZ6TV7dOXZy8Hky
 /GVJQRJz6GVAMfy+UBFTuEGpe1H9R4Eedg18J6mbi2veLLTCX3
 78NSUFEdqtkuoQKfhUgoUBRdFzNJd16BjvaBlzvv0LRID+7vf8
 MWfOR6+mukUiTm/f2OzhQ/L7/Dk1QypjMcrun/UYqWTy5JxNXk
 MYM3p5cDQR9dEGEoHS2Tn1zP6eF1ZiTVLOmXhfZNSUlDA04VnX
 MLg1BP1o67gO+sEejk+efZ3uOuZu9zIA9wQtKNxXFHioEFcApg
 LxBWOO4aw3ySTc6vFdmrr5wEv+6icvlF9f0JNt8jV/jY70e1x2
 XBgfPllpiHsUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are all specific to some driver. They are typically the platform
side of a change in the drivers directory, such as adding a new driver
or extending the interface to the platform. In cases where there is no
maintainer for the driver, or the maintainer prefers to have the
platform changes in the same branch as the driver changes, the patches
to the drivers are included as well.

A much smaller set of driver updates that depend on other branches
getting merged first will be sent later.

The new export of tegra_chip_uid conflicts with other changes in fuse.c.
In rtc-sa1100.c, the global removal of IRQF_DISABLED conflicts with
the cleanup of the interrupt handling of that driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "b740514 Merge branch 'next/drivers'
into for-next", leading up to commit " 511f1cb Merge tag 'regulator-3.4'
of git://git.kernel.org/pu", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers

Arnd Bergmann (13):
      Merge branch 'v3.4-next/devel-samsung-rtc' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'lpc32xx/drivers' into next/drivers
      Merge branch 'features/cs89x0' of git://git.pengutronix.de/git/imx/linux-2.6 into next/drivers
      Merge branch 'imx-drivers' of git://git.pengutronix.de/git/imx/linux-2.6 into next/drivers
      Merge branch 'mxs/gpmi' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/drivers
      Merge branch 'imx/driver' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/drivers
      Merge branch 'rtc-sa1100' of git://github.com/hzhuang1/linux into next/drivers
      Merge tag 'tegra-soc-drivers' of git://git.kernel.org/.../olof/tegra into tegra/soc-drivers
      Merge branch 'depends/irqdomain' into next/drivers
      Merge branch 'imx/defconfig' into next/drivers
      Merge branch 'next/fixes-non-critical' into next/drivers
      Merge tag 'regulator-3.4' of git://git.kernel.org/.../broonie/regulator into next/drivers
      Merge branch 'next/drivers' into for-next

Boojin Kim (2):
      ARM: EXYNOS: Enable MDMA driver
      ARM: EXYNOS: add support DMA for EXYNOS4X12 SoC

Dirk Behme (1):
      ARM: imx6: Rename DEBUG_IMX6Q_UART to UART4

Doug Anderson (2):
      ARM: tegra: Introduce define DEBUG_UART_SHIFT
      ARM: tegra: uncompress.h: Store UART address in a variable

Fabio Estevam (3):
      ARM: imx_v6_v7_defconfig: Add support for framebuffer and camera on mx31
      ARM: mx27_3ds: Add camera support
      ARM: imx_v4_v5_defconfig: Update defconfig

Felipe Balbi (4):
      ARM: OMAP3+: SmartReflex: add missing platform_set_drvdata()
      ARM: OMAP3+: SmartReflex: move late_initcall() closer to its argument
      ARM: OMAP3+: SmartReflex: misc cleanups
      ARM: OMAP3+: SmartReflex: micro-optimization for sanity check

Haojian Zhuang (5):
      rtc: sa1100: declare irq in resource
      ARM: pxa: add rtc dummy clock
      rtc: sa1100: enable clk support
      ARM: mmp: enable rtc in pxa910
      rtc: sa1100: add OF support

Heiko Stuebner (4):
      ARM: SAMSUNG: cleanup of rtc register definitions
      rtc-s3c: make room for more variants in devicetree block
      rtc-s3c: add variants for S3C2443 and S3C2416
      ARM: S3C2443/S3C2416: add s3c_rtc_setname and rename rtc devices

Heiko Stübner (2):
      pxa: magician/hx4700: Convert to gpio-regulator from bq24022
      regulator: Remove bq24022 regulator driver

Hong Xu (1):
      ARM: at91: Update struct atmel_nand_data to support PMECC

Huang Shijie (1):
      ARM: mxs: add GPMI-NAND support for imx23/imx28

Jaccon Bastiaansen (4):
      CS89x0 : add platform driver support
      CS89x0 : add CS89x0 platform device to the iMX21ADS board
      CS89x0 : remove QQ2440 board support from the CS89x0 driver
      CS89x0 : add CS89x0 platform device to the iMX31ADS board

Jaehoon Chung (3):
      ARM: SAMSUNG: support the second capability for samsung-soc
      mmc: sdhci-s3c: add platform data for the second capability
      ARM: SAMSUNG: change the name from s3c-sdhci to exynos4-sdhci

Jean Pihet (2):
      ARM: OMAP3+: SmartReflex: fix the use of debugfs_create_* API
      ARM: OMAP3+: SmartReflex: fix error handling

Jett.Zhou (1):
      ARM: sa1100: clean up clock support

Josh Wu (2):
      ARM: at91: add clock selection parameter for at91_add_device_isi()
      ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board

Laxman Dewangan (2):
      ARM: tegra: Pause DMA when reading transfer count
      ARM: tegra: dma: not required to move requestor when stopping.

Leon Romanovsky (2):
      ARM: dt: tegra: Enable device tree audio codec on PAZ00 board.
      ARM: dt: tegra: Enable headset autodetection on PAZ00 board.

Maxim Osipov (1):
      ARM: at91: Add external RTC for Flexibity board

Nicolas Ferre (2):
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support

Nishanth Menon (6):
      ARM: OMAP3+: SmartReflex: fix err interrupt disable sequence
      ARM: OMAP3+: SmartReflex Class3: disable errorgen before disable VP
      ARM: OMAP3+: SmartReflex: Add a shutdown hook
      ARM: OMAP3+: SmartReflex: Fix status masking in ERRCONFIG register
      ARM: OMAP3+: SmartReflex: clear ERRCONFIG_VPBOUNDINTST only on a need
      ARM: OMAP3+: hwmod: add SmartReflex IRQs

Olof Johansson (16):
      ARM: tegra: emc: device tree bindings
      ARM: tegra: seaboard: add EMC table to device tree
      ARM: tegra: Don't WARN_ON() for too early dma channel allocations
      ARM: tegra: use APB DMA for accessing APB devices
      ARM: tegra: fuse: use apbio dma for register access
      ARM: tegra: fuse: add functions to access chip revision
      ARM: tegra: fuse: add bct strapping reading
      ARM: tegra: emc: convert tegra2_emc to a platform driver
      ARM: tegra: emc: device tree support
      Merge branch 'at91-3.4-base+device_board' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge branch 'features/imx-clk-prepare' of git://git.pengutronix.de/git/imx/linux-2.6 into next/drivers
      Merge branch 'regulator' of git://github.com/hzhuang1/linux into next/drivers
      Merge branch 'rtc' of git://github.com/hzhuang1/linux into next/drivers
      Merge branch 'sr' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge branch 'next/devel-samsung-mmc' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/devel-samsung-dma' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers

Richard Zhao (13):
      ARM: mxc: time: add clk_prepare/clk_unprepare
      ARM: mxc: ahci: add clk_prepare/clk_unprepare
      ARM: mxc: pwm: add clk_prepare/clk_unprepare
      ARM: mxc: epit: add clk_prepare/clk_unprepare
      ARM: mxc: arch_reset: add clk_prepare/clk_unprepare
      ARM: mxc: audmux-v2: add clk_prepare/clk_unprepare
      ARM: pm-imx5: add clk_prepare/clk_unprepare
      ARM: mx31moboard: add clk_prepare/clk_unprepare
      serial: imx: add clk_prepare/clk_unprepare
      i2c: imx: add clk_prepare/clk_unprepare
      mmc: sdhci-esdhc-imx: add clk_prepare/clk_unprepare
      ARM: mxc: make imx_dma_is_general_purpose more generic for sdma
      ARM: imx6q: add cko1 clock

Roland Stigge (1):
      ARM: LPC32xx: ADC support for mach-lpc32xx

Shweta Gulati (1):
      ARM: OMAP3+: SmartReflex: use voltage domain name in device attributes

Stephen Warren (19):
      dt: tegra gpio: Flesh out binding documentation
      ARM: dt: tegra30.dtsi: Reformat gpio's interrupts property
      ARM: dt: tegra30.dtsi: Add extra GPIO interrupt
      ARM: dt: tegra: Add Tegra APB DMA device tree binding
      ARM: dt: tegra: Modify I2S nodes to match binding
      ARM: dt: tegra: Add labels for I2S controllers
      ARM: dt: tegra: Enable audio on WM8903 boards, disable others
      ARM: dt: Add binding for Tegra PMC
      ARM: tegra: Support Tegra30 in decompressor UART setup
      ARM: tegra: uncompress.h: Choose a UART at runtime
      ARM: tegra: Pass uncompress.h UART selection to DEBUG_LL
      ARM: tegra: Remove use of TEGRA_GPIO_TO_IRQ
      gpio: tegra: Dynamically allocate IRQ base, and support DT
      gpio: tegra: Parameterize the number of banks
      ARM: tegra: Fix EMC pdata initialization from registers
      ARM: tegra: Add a simple PMC driver
      ARM: tegra: Remove duplicate PMU interrupt inversion code
      gpio: tegra: Fix build issue due to irq_domain rework.
      ARM: tegra: uncompress.h: Don't depend on kernel headers

Tony Lindgren (1):
      Merge branch 'for_3.4/cleanup/sr' of git://git.kernel.org/.../khilman/linux-omap-pm into sr

Tushar Behera (1):
      ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1


 .../devicetree/bindings/arm/tegra/emc.txt          |  100 +++++++++
 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |   19 ++
 .../devicetree/bindings/dma/tegra20-apbdma.txt     |   30 +++
 .../devicetree/bindings/gpio/gpio_nvidia.txt       |   36 +++-
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/Kconfig.debug                             |    6 +-
 arch/arm/boot/dts/tegra-harmony.dts                |   45 +++-
 arch/arm/boot/dts/tegra-paz00.dts                  |   30 +++
 arch/arm/boot/dts/tegra-seaboard.dts               |   78 +++++++
 arch/arm/boot/dts/tegra-trimslice.dts              |   12 +
 arch/arm/boot/dts/tegra-ventana.dts                |   42 ++++
 arch/arm/boot/dts/tegra20.dtsi                     |   43 ++++-
 arch/arm/boot/dts/tegra30.dtsi                     |   53 +++++-
 arch/arm/configs/imx_v4_v5_defconfig               |   18 ++
 arch/arm/configs/imx_v6_v7_defconfig               |   34 +++
 arch/arm/configs/magician_defconfig                |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   13 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   94 ++++++++
 arch/arm/mach-at91/board-flexibity.c               |   12 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   80 +++++++-
 arch/arm/mach-at91/include/mach/board.h            |    6 +-
 arch/arm/mach-exynos/Kconfig                       |    3 +
 arch/arm/mach-exynos/clock-exynos4.c               |    9 +
 arch/arm/mach-exynos/dma.c                         |  117 ++++++++++-
 arch/arm/mach-exynos/include/mach/irqs.h           |    2 +
 arch/arm/mach-exynos/include/mach/map.h            |    3 +-
 arch/arm/mach-exynos/mach-nuri.c                   |    4 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    2 +-
 arch/arm/mach-imx/Kconfig                          |    1 +
 arch/arm/mach-imx/clock-imx6q.c                    |   74 +++++++-
 arch/arm/mach-imx/lluart.c                         |    2 +-
 arch/arm/mach-imx/mach-mx21ads.c                   |   16 ++-
 arch/arm/mach-imx/mach-mx27_3ds.c                  |  108 +++++++++
 arch/arm/mach-imx/mach-mx31ads.c                   |   35 +++-
 arch/arm/mach-imx/mach-mx31moboard.c               |    2 +-
 arch/arm/mach-imx/pm-imx5.c                        |    4 +-
 arch/arm/mach-lpc32xx/clock.c                      |   36 +++
 arch/arm/mach-lpc32xx/common.c                     |   22 ++
 arch/arm/mach-lpc32xx/common.h                     |    1 +
 arch/arm/mach-lpc32xx/phy3250.c                    |    1 +
 arch/arm/mach-mmp/include/mach/pxa910.h            |    1 +
 arch/arm/mach-mmp/include/mach/regs-apbc.h         |    1 +
 arch/arm/mach-mmp/include/mach/regs-rtc.h          |   23 ++
 arch/arm/mach-mmp/pxa910.c                         |   27 +++
 arch/arm/mach-mmp/ttc_dkb.c                        |    1 +
 arch/arm/mach-mxs/clock-mx23.c                     |    1 +
 arch/arm/mach-mxs/clock-mx28.c                     |    1 +
 arch/arm/mach-mxs/devices-mx23.h                   |    4 +
 arch/arm/mach-mxs/devices-mx28.h                   |    4 +
 arch/arm/mach-mxs/devices/Kconfig                  |    3 +
 arch/arm/mach-mxs/devices/Makefile                 |    1 +
 arch/arm/mach-mxs/devices/platform-gpmi-nand.c     |   81 +++++++
 arch/arm/mach-mxs/include/mach/devices-common.h    |   10 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   31 +++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   19 ++-
 arch/arm/mach-omap2/smartreflex-class3.c           |    1 +
 arch/arm/mach-omap2/smartreflex.c                  |  227 +++++++++++++++-----
 arch/arm/mach-omap2/smartreflex.h                  |   10 +
 arch/arm/mach-omap2/sr_device.c                    |   11 +-
 arch/arm/mach-pxa/devices.c                        |   28 ++-
 arch/arm/mach-pxa/hx4700.c                         |   33 +++-
 arch/arm/mach-pxa/magician.c                       |   33 +++-
 arch/arm/mach-pxa/pxa3xx.c                         |    1 +
 arch/arm/mach-pxa/pxa95x.c                         |    1 +
 arch/arm/mach-s3c24xx/s3c2416.c                    |    2 +
 arch/arm/mach-s3c24xx/s3c2443.c                    |    2 +
 arch/arm/mach-sa1100/clock.c                       |   82 ++++---
 arch/arm/mach-sa1100/generic.c                     |    8 +
 arch/arm/mach-tegra/Makefile                       |    3 +-
 arch/arm/mach-tegra/apbio.c                        |  145 +++++++++++++
 arch/arm/mach-tegra/apbio.h                        |   39 ++++
 arch/arm/mach-tegra/board-harmony-power.c          |   15 --
 arch/arm/mach-tegra/board-harmony.c                |    2 +-
 arch/arm/mach-tegra/board-seaboard.c               |    5 +-
 arch/arm/mach-tegra/common.c                       |   20 ++
 arch/arm/mach-tegra/dma.c                          |  128 +++++++-----
 arch/arm/mach-tegra/fuse.c                         |  107 +++++++---
 arch/arm/mach-tegra/fuse.h                         |   34 +++-
 arch/arm/mach-tegra/include/mach/debug-macro.S     |   88 +++++++-
 arch/arm/mach-tegra/include/mach/gpio-tegra.h      |    2 -
 arch/arm/mach-tegra/include/mach/irammap.h         |   35 +++
 arch/arm/mach-tegra/include/mach/uncompress.h      |  120 ++++++++++-
 arch/arm/mach-tegra/pmc.c                          |   76 +++++++
 arch/arm/mach-tegra/pmc.h                          |   23 ++
 arch/arm/mach-tegra/tegra2_clocks.c                |    2 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |  224 +++++++++++++++++--
 arch/arm/mach-tegra/tegra2_emc.h                   |   11 +-
 arch/arm/plat-mxc/devices/platform-ahci-imx.c      |   16 +-
 arch/arm/plat-mxc/epit.c                           |    2 +-
 arch/arm/plat-mxc/include/mach/board-mx31ads.h     |   33 ---
 arch/arm/plat-mxc/include/mach/debug-macro.S       |    2 +-
 arch/arm/plat-mxc/include/mach/dma.h               |    3 +-
 arch/arm/plat-mxc/pwm.c                            |    4 +-
 arch/arm/plat-mxc/system.c                         |    2 +-
 arch/arm/plat-mxc/time.c                           |    2 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    2 -
 arch/arm/plat-samsung/include/plat/dma-pl330.h     |   16 ++
 arch/arm/plat-samsung/include/plat/regs-rtc.h      |   81 ++++----
 arch/arm/plat-samsung/include/plat/rtc-core.h      |   27 +++
 arch/arm/plat-samsung/include/plat/sdhci.h         |    2 +
 arch/arm/plat-samsung/platformdata.c               |    2 +
 drivers/gpio/gpio-tegra.c                          |   59 ++++--
 drivers/i2c/busses/i2c-imx.c                       |    4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    6 +-
 drivers/mmc/host/sdhci-s3c.c                       |    6 +-
 drivers/net/Space.c                                |    2 +
 drivers/net/ethernet/cirrus/Kconfig                |   19 +-
 drivers/net/ethernet/cirrus/cs89x0.c               |  148 +++++++++++---
 drivers/regulator/Kconfig                          |    8 -
 drivers/regulator/Makefile                         |    1 -
 drivers/regulator/bq24022.c                        |  162 --------------
 drivers/rtc/Kconfig                                |    4 +-
 drivers/rtc/rtc-s3c.c                              |   71 +++++--
 drivers/rtc/rtc-sa1100.c                           |  128 ++++++++---
 drivers/tty/serial/imx.c                           |    7 +-
 include/linux/platform_data/tegra_emc.h            |   34 +++
 include/linux/regulator/bq24022.h                  |   24 --
 sound/soc/imx/imx-audmux.c                         |    8 +-
 118 files changed, 3077 insertions(+), 731 deletions(-)
