Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab2AIWPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:15:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab2AIWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 08/11] Driver specific changes
Date: Mon,  9 Jan 2012 22:12:48 +0000
Message-Id: <1326147171-13752-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zG9LoC7SriBvcg7+g7ppPfGn+smQaOoTC2A6vIbXZGx
 T2qJYfukmIdbuzw86ovK1Y5Lpwliw9+3VHx9ZbLOd1ZHisYLpX
 nqnzEXZnTvafujwVeQ4zCvQeFEAMT+zqSMqvK99Qry/kXCqUgp
 PO9UjBazzSaI/GIEEH0qRFJRWKCVG0fkbd9YOLosxSipGNRsL4
 mVUGBKJknXaSWYBHaG6j//aCy43VCLcac+zUNyNQe1J+IFVb20
 Zhrh4NatkWUeaVeJnyMOwRru94MtuIHF0YjugEl+hxU0z3kVYU
 pU1+hkmbJkIZJhgtyvwNUJUvVM8Jjl0WxFLQ7w0vqhULttkQ/O
 wI0DZPc3LcSe5Li90kydcKv91eqpsu6xSUA4lxB4U98OT+ZL4u
 CrseCtzr70ktQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, a lot of platforms have changes in here: pxa, samsung, omap,
at91, imx, ...

The following changes since commit ac16ea4997f45afb824a177f1968e0d1208b49fd:

  Merge branch 'next/devel' into for-next3 (2012-01-09 17:08:17 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/drivers

Abhilash K V (1):
      ARM: OMAP: hsmmc: Support for AM3517 MMC1 voltages

Arnd Bergmann (19):
      Merge branches 'drivers/macb-gem' and 'drivers/pxa-gpio' into next/drivers
      Merge branch 'mxs/saif' into next/drivers
      Merge branch 'drivers/pxa-gpio' into next/drivers
      Merge branch 'at91/macb' into next/drivers
      Merge branch 'ehci' of git://git.kernel.org/.../tmlind/linux-omap into omap/ehci
      Merge branch 'omap/hwmod' into next/drivers
      Merge branch 'omap/ehci' into next/drivers
      Merge branch 'for-3.3/drivers' of git://git.kernel.org/.../olof/tegra into tegra/drivers
      Merge branch 'tegra/drivers' into next/drivers
      Merge branch 'next-samsung-devel-ohci' of git://git.kernel.org/.../kgene/linux-samsung into samsung/ohci
      Merge branch 'v3.2-rc6' into next/drivers
      Merge branch 'samsung/ohci' into next/drivers
      Merge branch 'next-samsung-devel-mmc-spi5' of git://git.kernel.org/.../kgene/linux-samsung into samsung/driver
      Merge branch 'samsung/cleanup' into next/drivers
      Merge branch 'samsung/driver' into next/drivers
      Merge branch 'drivers/pxa-gpio' into next/drivers
      Merge branch 'drivers/rtc-sa1100' into next/drivers
      Merge branch 'samsung/cleanup' into samsung/driver
      Merge branch 'samsung/driver' into next/drivers

Axel Lin (2):
      pcmcia: pxa: replace IRQ_GPIO() with gpio_to_irq()
      Input: zylonite-wm97xx - replace IRQ_GPIO() with gpio_to_irq()

Dong Aisheng (4):
      ASoC: mxs-saif: remove function in platform_data
      ARM: mxs: add saif clkmux functions
      ARM: mx28evk: add platform data for saif
      ARM: mx28evk: set a initial clock rate for saif

Eliad Peller (3):
      omap_hsmmc: consider MMC_PM_KEEP_POWER on suspend/resume
      ARM: OMAP: hsmmc: add pm_caps field
      ARM: OMAP: hsmmc: board-sdp4430: declare support for MMC_PM_KEEP_POWER

Haojian Zhuang (13):
      ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ
      ARM: pxa: use chained interrupt for GPIO0 and GPIO1
      ARM: pxa: rename gpio_to_irq and irq_to_gpio
      ARM: pxa: recognize gpio number and type
      ARM: pxa: rename NR_BUILTIN_GPIO
      ARM: pxa: use little endian read write in gpio driver
      ARM: pxa: use generic gpio operation instead of gpio register
      ARM: pxa: change gpio to platform device
      ARM: mmp: clear gpio edge detect
      ARM: pxa: add clk support in gpio driver
      driver: pcmcia: replace IRQ_GPIO() with gpio_to_irq()
      ARM: pxa: fix the build error because of missing gpio-pxa.h
      ARM: pxa: fix build error for GPIO_bit()

Igor Grinberg (1):
      ARM: OMAP: hsmmc: Add support for MMC 2 setup for AM35x

Jamie Iles (5):
      macb: initial support for Cadence GEM
      macb: support higher rate GEM MDIO clock divisors
      macb: support statistics for GEM devices
      macb: support DMA bus widths > 32 bits
      macb: allow GEM to have configurable receive buffer size

Jean-Christophe PLAGNIOL-VILLARD (1):
      net/macb: add DT support for Cadence macb/gem driver

Jett.Zhou (5):
      RTC: sa1100: Clean out ost register
      RTC: sa1100: remove redundant code of setting alarm
      RTC: sa1100: support sa1100, pxa and mmp soc families
      ARM: pxa: add dummy clock for sa1100-rtc
      ARM: sa1100: clean up of the clock support

Jingoo Han (3):
      ARM: EXYNOS: Add USB OHCI device
      ARM: EXYNOS: Add USB OHCI support to SMDKV310 board
      USB: Add Samsung Exynos OHCI diver

Keshava Munegowda (4):
      ARM: OMAP: USB: register hwmods of usbhs
      ARM: OMAP: USB: device name change for the clk names of usbhs
      ARM: OMAP: USBHOST: Replace usbhs core driver APIs by Runtime pm APIs
      MFD: OMAP: USB: Runtime PM support

Nicolas Ferre (2):
      ARM: at91/net: add macb ethernet controller in 9g45/9g20 DT
      net/at91_ether: use gpio_is_valid for phy IRQ line

Olof Johansson (3):
      Merge branch 'hsmmc' of git://git.kernel.org/.../tmlind/linux-omap into omap/hsmmc
      Merge branch 'omap/hsmmc' into next/drivers
      net: macb: fix build break with !CONFIG_OF

Padmavathi Venna (1):
      ARM: EXYNOS: Modified files for SPI consolidation work

Rajeshwari Shinde (3):
      ARM: S5P64X0: Add HSMMC setup for host Controller
      ARM: S5P64X0: Add lookup of sdhci-s3c clocks using generic names
      ARM: S5P64X0: Enable SDHCI support

Stephen Warren (2):
      i2c: tegra: Add __devinit/exit to probe/remove
      i2c: tegra: Support DVC controller in device tree

Thomas Weber (1):
      ARM: OMAP: hsmmc: Add support for non-OMAP pins

Tony Lindgren (1):
      Merge branch 'usbhost_runtime_pm_14_devel_3.3' of git://git.pwsan.com/linux-2.6 into ehci

Tushar Behera (1):
      ARM: EXYNOS: Add USB OHCI support to ORIGEN board

Vaibhav Hiremath (1):
      ARM: OMAP: hsmmc: Add support for AM3517EVM base-board MMC slot

 Documentation/devicetree/bindings/net/macb.txt    |   25 +
 arch/arm/Kconfig                                  |    4 +-
 arch/arm/boot/dts/at91sam9g20.dtsi                |    7 +
 arch/arm/boot/dts/at91sam9g45.dtsi                |    7 +
 arch/arm/boot/dts/at91sam9m10g45ek.dts            |    5 +
 arch/arm/boot/dts/usb_a9g20.dts                   |    5 +
 arch/arm/mach-exynos/Kconfig                      |   12 +
 arch/arm/mach-exynos/Makefile                     |    2 +
 arch/arm/mach-exynos/clock.c                      |   73 ++-
 arch/arm/mach-exynos/dev-ohci.c                   |   52 ++
 arch/arm/mach-exynos/include/mach/irqs.h          |    3 +
 arch/arm/mach-exynos/include/mach/map.h           |    8 +
 arch/arm/mach-exynos/include/mach/ohci.h          |   21 +
 arch/arm/mach-exynos/include/mach/spi-clocks.h    |   16 +
 arch/arm/mach-exynos/mach-origen.c                |   13 +
 arch/arm/mach-exynos/mach-smdkv310.c              |   13 +
 arch/arm/mach-exynos/setup-spi.c                  |   72 ++
 arch/arm/mach-exynos/setup-usb-phy.c              |   15 +
 arch/arm/mach-mmp/aspenite.c                      |    5 +-
 arch/arm/mach-mmp/avengers_lite.c                 |    1 +
 arch/arm/mach-mmp/brownstone.c                    |    1 +
 arch/arm/mach-mmp/flint.c                         |    5 +-
 arch/arm/mach-mmp/gplugd.c                        |    1 +
 arch/arm/mach-mmp/include/mach/gpio-pxa.h         |    3 +-
 arch/arm/mach-mmp/include/mach/gpio.h             |    7 +-
 arch/arm/mach-mmp/include/mach/irqs.h             |    6 +-
 arch/arm/mach-mmp/include/mach/mmp2.h             |    2 +
 arch/arm/mach-mmp/include/mach/pxa168.h           |    2 +
 arch/arm/mach-mmp/include/mach/pxa910.h           |    2 +
 arch/arm/mach-mmp/mmp2.c                          |   39 +-
 arch/arm/mach-mmp/pxa168.c                        |   40 +-
 arch/arm/mach-mmp/pxa910.c                        |   40 +-
 arch/arm/mach-mmp/tavorevb.c                      |    6 +-
 arch/arm/mach-mmp/teton_bga.c                     |    3 +-
 arch/arm/mach-mmp/ttc_dkb.c                       |    8 +-
 arch/arm/mach-mxs/clock-mx28.c                    |   38 +
 arch/arm/mach-mxs/devices-mx28.h                  |    3 +-
 arch/arm/mach-mxs/devices/platform-mxs-saif.c     |    5 +-
 arch/arm/mach-mxs/include/mach/common.h           |    1 +
 arch/arm/mach-mxs/include/mach/devices-common.h   |    4 +-
 arch/arm/mach-mxs/include/mach/digctl.h           |   21 +
 arch/arm/mach-mxs/mach-mx28evk.c                  |   18 +-
 arch/arm/mach-omap2/board-4430sdp.c               |    1 +
 arch/arm/mach-omap2/board-am3517evm.c             |   22 +
 arch/arm/mach-omap2/clock3xxx_data.c              |   26 +-
 arch/arm/mach-omap2/clock44xx_data.c              |   10 +-
 arch/arm/mach-omap2/hsmmc.c                       |   59 ++-
 arch/arm/mach-omap2/hsmmc.h                       |    1 +
 arch/arm/mach-omap2/usb-host.c                    |  100 +--
 arch/arm/mach-pxa/am200epd.c                      |    4 +-
 arch/arm/mach-pxa/am300epd.c                      |    4 +-
 arch/arm/mach-pxa/balloon3.c                      |    2 +-
 arch/arm/mach-pxa/capc7117.c                      |   12 +-
 arch/arm/mach-pxa/cm-x270.c                       |    4 +-
 arch/arm/mach-pxa/cm-x2xx.c                       |    4 +-
 arch/arm/mach-pxa/cm-x300.c                       |    6 +-
 arch/arm/mach-pxa/colibri-pxa270.c                |    6 +-
 arch/arm/mach-pxa/colibri-pxa300.c                |    4 +-
 arch/arm/mach-pxa/colibri-pxa320.c                |    4 +-
 arch/arm/mach-pxa/corgi.c                         |    2 +-
 arch/arm/mach-pxa/corgi_pm.c                      |   21 +-
 arch/arm/mach-pxa/devices.c                       |   50 ++
 arch/arm/mach-pxa/devices.h                       |    1 +
 arch/arm/mach-pxa/em-x270.c                       |    6 +-
 arch/arm/mach-pxa/eseries.c                       |    4 +-
 arch/arm/mach-pxa/hx4700.c                        |   18 +-
 arch/arm/mach-pxa/icontrol.c                      |    8 +-
 arch/arm/mach-pxa/idp.c                           |    4 +-
 arch/arm/mach-pxa/include/mach/balloon3.h         |    6 +-
 arch/arm/mach-pxa/include/mach/corgi.h            |   26 +-
 arch/arm/mach-pxa/include/mach/csb726.h           |    4 +-
 arch/arm/mach-pxa/include/mach/gpio-pxa.h         |  133 ----
 arch/arm/mach-pxa/include/mach/gpio.h             |   20 +-
 arch/arm/mach-pxa/include/mach/gumstix.h          |   20 +-
 arch/arm/mach-pxa/include/mach/hx4700.h           |    2 +-
 arch/arm/mach-pxa/include/mach/idp.h              |   16 +-
 arch/arm/mach-pxa/include/mach/irqs.h             |    8 +-
 arch/arm/mach-pxa/include/mach/littleton.h        |    4 +-
 arch/arm/mach-pxa/include/mach/magician.h         |    2 +-
 arch/arm/mach-pxa/include/mach/palmld.h           |    8 +-
 arch/arm/mach-pxa/include/mach/palmt5.h           |    8 +-
 arch/arm/mach-pxa/include/mach/palmtc.h           |    4 +-
 arch/arm/mach-pxa/include/mach/palmtx.h           |    8 +-
 arch/arm/mach-pxa/include/mach/pcm027.h           |    8 +-
 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h |   14 +-
 arch/arm/mach-pxa/include/mach/poodle.h           |   26 +-
 arch/arm/mach-pxa/include/mach/spitz.h            |   40 +-
 arch/arm/mach-pxa/include/mach/tosa.h             |   52 +-
 arch/arm/mach-pxa/include/mach/trizeps4.h         |   16 +-
 arch/arm/mach-pxa/irq.c                           |   61 +--
 arch/arm/mach-pxa/littleton.c                     |    6 +-
 arch/arm/mach-pxa/lpd270.c                        |    4 +-
 arch/arm/mach-pxa/lubbock.c                       |    4 +-
 arch/arm/mach-pxa/magician.c                      |    8 +-
 arch/arm/mach-pxa/mainstone.c                     |    4 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                    |    6 +-
 arch/arm/mach-pxa/mioa701.c                       |    8 +-
 arch/arm/mach-pxa/mxm8x10.c                       |    4 +-
 arch/arm/mach-pxa/pcm990-baseboard.c              |    6 +-
 arch/arm/mach-pxa/poodle.c                        |    6 +-
 arch/arm/mach-pxa/pxa25x.c                        |    7 +-
 arch/arm/mach-pxa/pxa27x.c                        |    7 +-
 arch/arm/mach-pxa/pxa300.c                        |    1 +
 arch/arm/mach-pxa/pxa320.c                        |    1 +
 arch/arm/mach-pxa/pxa3xx.c                        |    9 +-
 arch/arm/mach-pxa/pxa95x.c                        |    6 +-
 arch/arm/mach-pxa/raumfeld.c                      |    8 +-
 arch/arm/mach-pxa/saar.c                          |    6 +-
 arch/arm/mach-pxa/saarb.c                         |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c                    |   24 +-
 arch/arm/mach-pxa/spitz.c                         |    2 +-
 arch/arm/mach-pxa/spitz_pm.c                      |   11 +-
 arch/arm/mach-pxa/stargate2.c                     |   26 +-
 arch/arm/mach-pxa/tavorevb.c                      |    4 +-
 arch/arm/mach-pxa/tavorevb3.c                     |    2 +-
 arch/arm/mach-pxa/tosa.c                          |    4 +-
 arch/arm/mach-pxa/viper.c                         |   12 +-
 arch/arm/mach-pxa/vpac270.c                       |   10 +-
 arch/arm/mach-pxa/z2.c                            |    2 +-
 arch/arm/mach-pxa/zeus.c                          |   20 +-
 arch/arm/mach-pxa/zylonite.c                      |    4 +-
 arch/arm/mach-pxa/zylonite_pxa300.c               |    4 +-
 arch/arm/mach-s5p64x0/Kconfig                     |   24 +
 arch/arm/mach-s5p64x0/Makefile                    |    1 +
 arch/arm/mach-s5p64x0/clock-s5p6440.c             |   72 ++-
 arch/arm/mach-s5p64x0/clock-s5p6450.c             |   72 ++-
 arch/arm/mach-s5p64x0/common.c                    |    9 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c             |   25 +
 arch/arm/mach-s5p64x0/mach-smdk6450.c             |   26 +-
 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c          |  104 +++
 arch/arm/mach-sa1100/clock.c                      |   91 ++-
 arch/arm/mach-sa1100/generic.c                    |   20 +
 arch/arm/plat-omap/include/plat/mmc.h             |    1 +
 arch/arm/plat-omap/include/plat/usb.h             |    3 -
 arch/arm/plat-pxa/include/plat/gpio-pxa.h         |   44 --
 arch/arm/plat-pxa/include/plat/gpio.h             |   30 -
 arch/arm/plat-samsung/include/plat/devs.h         |    1 +
 arch/arm/plat-samsung/include/plat/sdhci.h        |   44 ++
 drivers/gpio/Kconfig                              |    6 +
 drivers/gpio/Makefile                             |    2 +-
 drivers/gpio/gpio-pxa.c                           |  377 +++++++++--
 drivers/i2c/busses/i2c-tegra.c                    |   10 +-
 drivers/input/touchscreen/zylonite-wm97xx.c       |    5 +-
 drivers/mfd/omap-usb-host.c                       |  755 +++++++++------------
 drivers/mmc/host/omap_hsmmc.c                     |   26 +-
 drivers/net/ethernet/Makefile                     |    2 +-
 drivers/net/ethernet/cadence/Kconfig              |   16 +-
 drivers/net/ethernet/cadence/at91_ether.c         |   23 +-
 drivers/net/ethernet/cadence/macb.c               |  269 +++++++--
 drivers/net/ethernet/cadence/macb.h               |  152 ++++-
 drivers/pcmcia/pxa2xx_cm_x255.c                   |   16 +-
 drivers/pcmcia/pxa2xx_cm_x270.c                   |    9 +-
 drivers/pcmcia/pxa2xx_e740.c                      |   11 +-
 drivers/pcmcia/pxa2xx_palmld.c                    |    2 +-
 drivers/pcmcia/pxa2xx_palmtc.c                    |    2 +-
 drivers/pcmcia/pxa2xx_stargate2.c                 |    6 +-
 drivers/pcmcia/pxa2xx_trizeps4.c                  |    5 +-
 drivers/pcmcia/pxa2xx_vpac270.c                   |    4 +-
 drivers/rtc/Kconfig                               |    2 +-
 drivers/rtc/rtc-sa1100.c                          |  300 +++++----
 drivers/usb/Kconfig                               |    1 +
 drivers/usb/host/Kconfig                          |    6 +
 drivers/usb/host/ehci-omap.c                      |   17 +-
 drivers/usb/host/ohci-exynos.c                    |  274 ++++++++
 drivers/usb/host/ohci-hcd.c                       |    5 +
 drivers/usb/host/ohci-omap3.c                     |   18 +-
 include/linux/gpio-pxa.h                          |   16 +
 include/sound/saif.h                              |    4 +-
 sound/soc/mxs/mxs-saif.c                          |   20 +-
 169 files changed, 3009 insertions(+), 1630 deletions(-)
