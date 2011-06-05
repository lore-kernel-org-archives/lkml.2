Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FEHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:16:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1FEHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:16:25 -0400
Subject: [PATCH] gpio: reorganize drivers
To: linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 05 Jun 2011 01:16:23 -0600
Message-ID: <20110605071501.26454.24677.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort the gpio makefile and enforce the naming convention gpio-*.c for
gpio drivers.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/Kconfig           |   18 ++++-----
 drivers/gpio/Makefile          |   81 +++++++++++++++++++++-------------------
 drivers/gpio/gpio-74x164.c     |    0 
 drivers/gpio/gpio-ab8500.c     |    0 
 drivers/gpio/gpio-adp5520.c    |    0 
 drivers/gpio/gpio-adp5588.c    |    0 
 drivers/gpio/gpio-bt8xx.c      |    0 
 drivers/gpio/gpio-cs5535.c     |    0 
 drivers/gpio/gpio-generic.c    |    6 +--
 drivers/gpio/gpio-it8761e.c    |    0 
 drivers/gpio/gpio-janz-ttl.c   |    0 
 drivers/gpio/gpio-langwell.c   |    0 
 drivers/gpio/gpio-max7300.c    |    0 
 drivers/gpio/gpio-max7301.c    |    0 
 drivers/gpio/gpio-max730x.c    |    0 
 drivers/gpio/gpio-max732x.c    |    0 
 drivers/gpio/gpio-mc33880.c    |    0 
 drivers/gpio/gpio-mcp23s08.c   |    0 
 drivers/gpio/gpio-ml-ioh.c     |    0 
 drivers/gpio/gpio-pca953x.c    |    0 
 drivers/gpio/gpio-pcf857x.c    |    0 
 drivers/gpio/gpio-pch.c        |    0 
 drivers/gpio/gpio-pl061.c      |    0 
 drivers/gpio/gpio-rdc321x.c    |    0 
 drivers/gpio/gpio-sch.c        |    0 
 drivers/gpio/gpio-stmpe.c      |    0 
 drivers/gpio/gpio-sx150x.c     |    0 
 drivers/gpio/gpio-tc3589x.c    |    0 
 drivers/gpio/gpio-timberdale.c |    0 
 drivers/gpio/gpio-tps65910.c   |    0 
 drivers/gpio/gpio-twl4030.c    |    0 
 drivers/gpio/gpio-ucb1400.c    |    0 
 drivers/gpio/gpio-vr41xx.c     |    0 
 drivers/gpio/gpio-vx855.c      |    0 
 drivers/gpio/gpio-wm831x.c     |    0 
 drivers/gpio/gpio-wm8350.c     |    0 
 drivers/gpio/gpio-wm8994.c     |    0 
 drivers/gpio/gpio-xilinx.c     |    0 
 38 files changed, 53 insertions(+), 52 deletions(-)
 rename drivers/gpio/{74x164.c => gpio-74x164.c} (100%)
 rename drivers/gpio/{ab8500-gpio.c => gpio-ab8500.c} (100%)
 rename drivers/gpio/{adp5520-gpio.c => gpio-adp5520.c} (100%)
 rename drivers/gpio/{adp5588-gpio.c => gpio-adp5588.c} (100%)
 rename drivers/gpio/{bt8xxgpio.c => gpio-bt8xx.c} (100%)
 rename drivers/gpio/{cs5535-gpio.c => gpio-cs5535.c} (100%)
 rename drivers/gpio/{basic_mmio_gpio.c => gpio-generic.c} (99%)
 rename drivers/gpio/{it8761e_gpio.c => gpio-it8761e.c} (100%)
 rename drivers/gpio/{janz-ttl.c => gpio-janz-ttl.c} (100%)
 rename drivers/gpio/{langwell_gpio.c => gpio-langwell.c} (100%)
 rename drivers/gpio/{max7300.c => gpio-max7300.c} (100%)
 rename drivers/gpio/{max7301.c => gpio-max7301.c} (100%)
 rename drivers/gpio/{max730x.c => gpio-max730x.c} (100%)
 rename drivers/gpio/{max732x.c => gpio-max732x.c} (100%)
 rename drivers/gpio/{mc33880.c => gpio-mc33880.c} (100%)
 rename drivers/gpio/{mcp23s08.c => gpio-mcp23s08.c} (100%)
 rename drivers/gpio/{ml_ioh_gpio.c => gpio-ml-ioh.c} (100%)
 rename drivers/gpio/{pca953x.c => gpio-pca953x.c} (100%)
 rename drivers/gpio/{pcf857x.c => gpio-pcf857x.c} (100%)
 rename drivers/gpio/{pch_gpio.c => gpio-pch.c} (100%)
 rename drivers/gpio/{pl061.c => gpio-pl061.c} (100%)
 rename drivers/gpio/{rdc321x-gpio.c => gpio-rdc321x.c} (100%)
 rename drivers/gpio/{sch_gpio.c => gpio-sch.c} (100%)
 rename drivers/gpio/{stmpe-gpio.c => gpio-stmpe.c} (100%)
 rename drivers/gpio/{sx150x.c => gpio-sx150x.c} (100%)
 rename drivers/gpio/{tc3589x-gpio.c => gpio-tc3589x.c} (100%)
 rename drivers/gpio/{timbgpio.c => gpio-timberdale.c} (100%)
 rename drivers/gpio/{tps65910-gpio.c => gpio-tps65910.c} (100%)
 rename drivers/gpio/{twl4030-gpio.c => gpio-twl4030.c} (100%)
 rename drivers/gpio/{ucb1400_gpio.c => gpio-ucb1400.c} (100%)
 rename drivers/gpio/{vr41xx_giu.c => gpio-vr41xx.c} (100%)
 rename drivers/gpio/{vx855_gpio.c => gpio-vx855.c} (100%)
 rename drivers/gpio/{wm831x-gpio.c => gpio-wm831x.c} (100%)
 rename drivers/gpio/{wm8350-gpiolib.c => gpio-wm8350.c} (100%)
 rename drivers/gpio/{wm8994-gpio.c => gpio-wm8994.c} (100%)
 rename drivers/gpio/{xilinx_gpio.c => gpio-xilinx.c} (100%)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index afe44aa..b1a31b9 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -63,6 +63,9 @@ config GPIO_SYSFS
 	  Kernel drivers may also request that a particular GPIO be
 	  exported to userspace; this can be useful when debugging.
 
+config GPIO_GENERIC
+	tristate
+
 # put drivers in the right section, in alphabetical order
 
 config GPIO_MAX730X
@@ -70,16 +73,11 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO drivers:"
 
-config GPIO_BASIC_MMIO_CORE
-	tristate
-	help
-	  Provides core functionality for basic memory-mapped GPIO controllers.
-
-config GPIO_BASIC_MMIO
-	tristate "Basic memory-mapped GPIO controllers support"
-	select GPIO_BASIC_MMIO_CORE
+config GPIO_GENERIC_PLATFORM
+	tristate "Generic memory-mapped GPIO controller support (MMIO platform device)"
+	select GPIO_GENERIC
 	help
-	  Say yes here to support basic memory-mapped GPIO controllers.
+	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
 
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
@@ -449,7 +447,7 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
-config AB8500_GPIO
+config GPIO_AB8500
 	bool "ST-Ericsson AB8500 Mixed Signal Circuit gpio functions"
 	depends on AB8500_CORE && BROKEN
 	help
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 8733d02..8109ae6 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -4,49 +4,52 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
-obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
-obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
-obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
-obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
+# Device drivers. Generally keep list sorted alphabetically
+obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
+
+obj-$(CONFIG_GPIO_74X164)	+= gpio-74x164.o
+obj-$(CONFIG_GPIO_AB8500)	+= gpio-ab8500.o
+obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
+obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
+obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
+obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
+obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
+obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
+obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
+obj-$(CONFIG_GPIO_MAX730X)	+= gpio-max730x.o
+obj-$(CONFIG_GPIO_MAX7300)	+= gpio-max7300.o
+obj-$(CONFIG_GPIO_MAX7301)	+= gpio-max7301.o
+obj-$(CONFIG_GPIO_MAX732X)	+= gpio-max732x.o
+obj-$(CONFIG_GPIO_MC33880)	+= gpio-mc33880.o
+obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
+obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
 obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
+obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
+obj-$(CONFIG_ARCH_OMAP)		+= gpio-omap.o
+obj-$(CONFIG_GPIO_PCA953X)	+= gpio-pca953x.o
+obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
+obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
+obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
+obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
+
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
 obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
 obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
-obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
-obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
-obj-$(CONFIG_GPIO_MAX7300)	+= max7300.o
-obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
-obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
-obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
-obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
-obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
-obj-$(CONFIG_ARCH_OMAP)         += gpio-omap.o
-obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
-obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
-obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
-obj-$(CONFIG_GPIO_PL061)	+= pl061.o
-obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
-obj-$(CONFIG_GPIO_TC3589X)	+= tc3589x-gpio.o
-obj-$(CONFIG_GPIO_TIMBERDALE)	+= timbgpio.o
-obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
-obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
-obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
-obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
-obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
-obj-$(CONFIG_GPIO_IT8761E)	+= it8761e_gpio.o
-obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
-obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
-obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
-obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
-obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
+
+obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
+obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
+obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
+obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
+obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
+obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
+obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_MACH_U300)		+= gpio-u300.o
-obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
-obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
-obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
-obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
-obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
-obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
-obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
-obj-$(CONFIG_GPIO_TPS65910)	+= tps65910-gpio.o
+obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
+obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
+obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
+obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
+obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
+obj-$(CONFIG_GPIO_WM8994)	+= gpio-wm8994.o
+obj-$(CONFIG_GPIO_XILINX)	+= gpio-xilinx.o
diff --git a/drivers/gpio/74x164.c b/drivers/gpio/gpio-74x164.c
similarity index 100%
rename from drivers/gpio/74x164.c
rename to drivers/gpio/gpio-74x164.c
diff --git a/drivers/gpio/ab8500-gpio.c b/drivers/gpio/gpio-ab8500.c
similarity index 100%
rename from drivers/gpio/ab8500-gpio.c
rename to drivers/gpio/gpio-ab8500.c
diff --git a/drivers/gpio/adp5520-gpio.c b/drivers/gpio/gpio-adp5520.c
similarity index 100%
rename from drivers/gpio/adp5520-gpio.c
rename to drivers/gpio/gpio-adp5520.c
diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/gpio-adp5588.c
similarity index 100%
rename from drivers/gpio/adp5588-gpio.c
rename to drivers/gpio/gpio-adp5588.c
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/gpio-bt8xx.c
similarity index 100%
rename from drivers/gpio/bt8xxgpio.c
rename to drivers/gpio/gpio-bt8xx.c
diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/gpio-cs5535.c
similarity index 100%
rename from drivers/gpio/cs5535-gpio.c
rename to drivers/gpio/gpio-cs5535.c
diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/gpio-generic.c
similarity index 99%
rename from drivers/gpio/basic_mmio_gpio.c
rename to drivers/gpio/gpio-generic.c
index 8152e9f..231714d 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/gpio-generic.c
@@ -1,5 +1,5 @@
 /*
- * Driver for basic memory-mapped GPIO controllers.
+ * Generic driver for memory-mapped GPIO controllers.
  *
  * Copyright 2008 MontaVista Software, Inc.
  * Copyright 2008,2010 Anton Vorontsov <cbouatmailru@gmail.com>
@@ -404,7 +404,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
 }
 EXPORT_SYMBOL_GPL(bgpio_init);
 
-#ifdef CONFIG_GPIO_BASIC_MMIO
+#ifdef CONFIG_GPIO_GENERIC_PLATFORM
 
 static void __iomem *bgpio_map(struct platform_device *pdev,
 			       const char *name,
@@ -541,7 +541,7 @@ static void __exit bgpio_platform_exit(void)
 }
 module_exit(bgpio_platform_exit);
 
-#endif /* CONFIG_GPIO_BASIC_MMIO */
+#endif /* CONFIG_GPIO_GENERIC_PLATFORM */
 
 MODULE_DESCRIPTION("Driver for basic memory-mapped GPIO controllers");
 MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
diff --git a/drivers/gpio/it8761e_gpio.c b/drivers/gpio/gpio-it8761e.c
similarity index 100%
rename from drivers/gpio/it8761e_gpio.c
rename to drivers/gpio/gpio-it8761e.c
diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/gpio-janz-ttl.c
similarity index 100%
rename from drivers/gpio/janz-ttl.c
rename to drivers/gpio/gpio-janz-ttl.c
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/gpio-langwell.c
similarity index 100%
rename from drivers/gpio/langwell_gpio.c
rename to drivers/gpio/gpio-langwell.c
diff --git a/drivers/gpio/max7300.c b/drivers/gpio/gpio-max7300.c
similarity index 100%
rename from drivers/gpio/max7300.c
rename to drivers/gpio/gpio-max7300.c
diff --git a/drivers/gpio/max7301.c b/drivers/gpio/gpio-max7301.c
similarity index 100%
rename from drivers/gpio/max7301.c
rename to drivers/gpio/gpio-max7301.c
diff --git a/drivers/gpio/max730x.c b/drivers/gpio/gpio-max730x.c
similarity index 100%
rename from drivers/gpio/max730x.c
rename to drivers/gpio/gpio-max730x.c
diff --git a/drivers/gpio/max732x.c b/drivers/gpio/gpio-max732x.c
similarity index 100%
rename from drivers/gpio/max732x.c
rename to drivers/gpio/gpio-max732x.c
diff --git a/drivers/gpio/mc33880.c b/drivers/gpio/gpio-mc33880.c
similarity index 100%
rename from drivers/gpio/mc33880.c
rename to drivers/gpio/gpio-mc33880.c
diff --git a/drivers/gpio/mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
similarity index 100%
rename from drivers/gpio/mcp23s08.c
rename to drivers/gpio/gpio-mcp23s08.c
diff --git a/drivers/gpio/ml_ioh_gpio.c b/drivers/gpio/gpio-ml-ioh.c
similarity index 100%
rename from drivers/gpio/ml_ioh_gpio.c
rename to drivers/gpio/gpio-ml-ioh.c
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/gpio-pca953x.c
similarity index 100%
rename from drivers/gpio/pca953x.c
rename to drivers/gpio/gpio-pca953x.c
diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/gpio-pcf857x.c
similarity index 100%
rename from drivers/gpio/pcf857x.c
rename to drivers/gpio/gpio-pcf857x.c
diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/gpio-pch.c
similarity index 100%
rename from drivers/gpio/pch_gpio.c
rename to drivers/gpio/gpio-pch.c
diff --git a/drivers/gpio/pl061.c b/drivers/gpio/gpio-pl061.c
similarity index 100%
rename from drivers/gpio/pl061.c
rename to drivers/gpio/gpio-pl061.c
diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/gpio-rdc321x.c
similarity index 100%
rename from drivers/gpio/rdc321x-gpio.c
rename to drivers/gpio/gpio-rdc321x.c
diff --git a/drivers/gpio/sch_gpio.c b/drivers/gpio/gpio-sch.c
similarity index 100%
rename from drivers/gpio/sch_gpio.c
rename to drivers/gpio/gpio-sch.c
diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/gpio-stmpe.c
similarity index 100%
rename from drivers/gpio/stmpe-gpio.c
rename to drivers/gpio/gpio-stmpe.c
diff --git a/drivers/gpio/sx150x.c b/drivers/gpio/gpio-sx150x.c
similarity index 100%
rename from drivers/gpio/sx150x.c
rename to drivers/gpio/gpio-sx150x.c
diff --git a/drivers/gpio/tc3589x-gpio.c b/drivers/gpio/gpio-tc3589x.c
similarity index 100%
rename from drivers/gpio/tc3589x-gpio.c
rename to drivers/gpio/gpio-tc3589x.c
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/gpio-timberdale.c
similarity index 100%
rename from drivers/gpio/timbgpio.c
rename to drivers/gpio/gpio-timberdale.c
diff --git a/drivers/gpio/tps65910-gpio.c b/drivers/gpio/gpio-tps65910.c
similarity index 100%
rename from drivers/gpio/tps65910-gpio.c
rename to drivers/gpio/gpio-tps65910.c
diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/gpio-twl4030.c
similarity index 100%
rename from drivers/gpio/twl4030-gpio.c
rename to drivers/gpio/gpio-twl4030.c
diff --git a/drivers/gpio/ucb1400_gpio.c b/drivers/gpio/gpio-ucb1400.c
similarity index 100%
rename from drivers/gpio/ucb1400_gpio.c
rename to drivers/gpio/gpio-ucb1400.c
diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/gpio-vr41xx.c
similarity index 100%
rename from drivers/gpio/vr41xx_giu.c
rename to drivers/gpio/gpio-vr41xx.c
diff --git a/drivers/gpio/vx855_gpio.c b/drivers/gpio/gpio-vx855.c
similarity index 100%
rename from drivers/gpio/vx855_gpio.c
rename to drivers/gpio/gpio-vx855.c
diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/gpio-wm831x.c
similarity index 100%
rename from drivers/gpio/wm831x-gpio.c
rename to drivers/gpio/gpio-wm831x.c
diff --git a/drivers/gpio/wm8350-gpiolib.c b/drivers/gpio/gpio-wm8350.c
similarity index 100%
rename from drivers/gpio/wm8350-gpiolib.c
rename to drivers/gpio/gpio-wm8350.c
diff --git a/drivers/gpio/wm8994-gpio.c b/drivers/gpio/gpio-wm8994.c
similarity index 100%
rename from drivers/gpio/wm8994-gpio.c
rename to drivers/gpio/gpio-wm8994.c
diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/gpio-xilinx.c
similarity index 100%
rename from drivers/gpio/xilinx_gpio.c
rename to drivers/gpio/gpio-xilinx.c

