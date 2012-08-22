Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2HVNCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:02:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab2HVNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:02:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] [RFC] ARM: treewide: manually change more mach-*/*.h includes
Date: Wed, 22 Aug 2012 13:01:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
References: <201208221253.07278.arnd@arndb.de>
In-Reply-To: <201208221253.07278.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221301.19439.arnd@arndb.de>
X-Provags-ID: V02:K0:9oVJ04SS4mOAeQe3qIbrcNYhxv65a83XHpxqQOV3W8g
 6toZNMMfw5qdli4+DBZystTnyKVReHLLac9b22VnumfvPOANHA
 k33FJQ35YmO1Dz6wgTEgvIMpebx2EUZCs7YXSWZegOlL1Orvmz
 A0HRxGGWKkixCFxe+ghUQHwEhaHVOsEuD23AZCpDLsEstM60H5
 0VThsc5QuG+ptX1lAmpYFhS6QmPKjMhDv2dBA90VVxK3dfJluY
 D7vpJAvwVr9v9smRt9RX1pP27pqKw1896GhBKrBAq7JCfyeJi2
 sMHtaJ26VMxQMw5C3TW/8Fa2EjHb6TV8SYFHh4EdMLz7f4zHY+
 KWvpVJNvzL3Ri6Mpfr8Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are lots of device drivers that include machine
specific header files from ARM platforms and that are
not easily scriptable. The changes have been found through
manual inspection and should cause no visible changes
because of the build script that maps the old names to the
new ones.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/ds1620.c                                 |    2 +-
 drivers/char/hw_random/ixp4xx-rng.c                   |    2 +-
 drivers/cpufreq/db8500-cpufreq.c                      |    2 +-
 drivers/cpufreq/exynos-cpufreq.c                      |    2 +-
 drivers/cpufreq/exynos4210-cpufreq.c                  |    4 ++--
 drivers/cpufreq/exynos4x12-cpufreq.c                  |    4 ++--
 drivers/cpufreq/exynos5250-cpufreq.c                  |    6 +++---
 drivers/cpufreq/omap-cpufreq.c                        |    2 +-
 drivers/cpufreq/s5pv210-cpufreq.c                     |    2 +-
 drivers/crypto/omap-sham.c                            |    2 +-
 drivers/crypto/tegra-aes.c                            |    2 +-
 drivers/devfreq/exynos4_bus.c                         |    2 +-
 drivers/dma/ep93xx_dma.c                              |    2 +-
 drivers/dma/imx-dma.c                                 |    4 ++--
 drivers/gpio/gpio-omap.c                              |    4 ++--
 drivers/gpio/gpio-pxa.c                               |    8 +++++++-
 drivers/i2c/busses/i2c-acorn.c                        |    2 +-
 drivers/i2c/busses/i2c-davinci.c                      |    4 ++--
 drivers/i2c/busses/i2c-imx.c                          |    4 ++--
 drivers/i2c/busses/i2c-nuc900.c                       |    4 ++--
 drivers/i2c/busses/i2c-tegra.c                        |    2 +-
 drivers/input/misc/ixp4xx-beeper.c                    |    2 +-
 drivers/input/mouse/rpcmouse.c                        |    2 +-
 drivers/input/serio/rpckbd.c                          |    2 +-
 drivers/input/touchscreen/atmel_tsadcc.c              |    4 ++--
 drivers/input/touchscreen/h3600_ts_input.c            |    4 ++--
 drivers/input/touchscreen/mainstone-wm97xx.c          |    2 +-
 drivers/input/touchscreen/zylonite-wm97xx.c           |    6 +++---
 drivers/leds/leds-fsg.c                               |    2 +-
 drivers/media/video/pxa_camera.c                      |    4 ++--
 drivers/mfd/dbx500-prcmu-regs.h                       |    2 +-
 drivers/misc/ep93xx_pwm.c                             |    2 +-
 drivers/misc/spear13xx_pcie_gadget.c                  |    4 ++--
 drivers/mmc/host/at91_mci.c                           |    4 ++--
 drivers/mmc/host/mxcmmc.c                             |    6 +++---
 drivers/mmc/host/omap_hsmmc.c                         |    2 +-
 drivers/mmc/host/pxamci.c                             |    6 +++---
 drivers/mtd/maps/cdb89712.c                           |    2 +-
 drivers/mtd/maps/h720x-flash.c                        |    2 +-
 drivers/mtd/maps/pxa2xx-flash.c                       |    2 +-
 drivers/mtd/maps/sa1100-flash.c                       |    2 +-
 drivers/mtd/nand/ams-delta.c                          |    2 +-
 drivers/mtd/nand/sharpsl.c                            |    2 +-
 drivers/net/can/at91_can.c                            |    2 +-
 drivers/net/ethernet/amd/am79c961a.c                  |    2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c              |    2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                    |    6 +++---
 drivers/net/ethernet/smsc/smc911x.h                   |    2 +-
 drivers/net/ethernet/smsc/smc91x.h                    |    2 +-
 drivers/net/irda/ep7211-sir.c                         |    2 +-
 drivers/net/irda/pxaficp_ir.c                         |    8 ++++----
 drivers/net/irda/sa1100_ir.c                          |    2 +-
 drivers/pcmcia/omap_cf.c                              |    2 +-
 drivers/pcmcia/pxa2xx_cm_x2xx.c                       |    2 +-
 drivers/pcmcia/sa1111_jornada720.c                    |    2 +-
 drivers/pcmcia/sa11xx_base.c                          |    2 +-
 drivers/power/avs/smartreflex.c                       |    1 +
 drivers/pwm/pwm-imx.c                                 |    2 +-
 drivers/rtc/rtc-mxc.c                                 |    2 +-
 drivers/rtc/rtc-pxa.c                                 |    2 +-
 drivers/rtc/rtc-stmp3xxx.c                            |    2 +-
 drivers/scsi/arm/acornscsi-io.S                       |    2 +-
 drivers/spi/spi-imx.c                                 |    2 +-
 drivers/spi/spi-omap-uwire.c                          |    2 +-
 drivers/spi/spi-s3c24xx-fiq.S                         |    4 ++--
 drivers/spi/spi-tegra.c                               |    2 +-
 drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c |    4 ++--
 drivers/tty/serial/21285.c                            |    2 +-
 drivers/tty/serial/atmel_serial.c                     |    6 ++++--
 drivers/tty/serial/clps711x.c                         |    2 +-
 drivers/tty/serial/msm_serial_hs.c                    |    4 ++--
 drivers/tty/serial/sa1100.c                           |    4 ++--
 drivers/tty/serial/serial_ks8695.c                    |    4 ++--
 drivers/uio/uio_pruss.c                               |    2 +-
 drivers/usb/gadget/fsl_mxc_udc.c                      |    2 +-
 drivers/usb/gadget/imx_udc.c                          |    4 ++--
 drivers/usb/gadget/pxa27x_udc.c                       |    4 ++--
 drivers/usb/host/ohci-at91.c                          |    6 +++---
 drivers/usb/host/ohci-exynos.c                        |    2 +-
 drivers/usb/musb/davinci.c                            |    4 ++--
 drivers/usb/musb/ux500_dma.c                          |    2 +-
 drivers/usb/otg/msm_otg.c                             |    2 +-
 drivers/video/backlight/omap1_bl.c                    |    2 +-
 drivers/video/ep93xx-fb.c                             |    2 +-
 drivers/video/nuc900fb.h                              |    4 ++--
 drivers/video/pnx4008/dum.h                           |    2 +-
 drivers/w1/masters/omap_hdq.c                         |    2 +-
 drivers/watchdog/imx2_wdt.c                           |    2 +-
 drivers/watchdog/ixp4xx_wdt.c                         |    2 +-
 drivers/watchdog/ks8695_wdt.c                         |    4 ++--
 drivers/watchdog/wdt285.c                             |    2 +-
 91 files changed, 137 insertions(+), 128 deletions(-)

diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index aab9605..b4c21b1 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -10,7 +10,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 
-#include <mach/hardware.h>
+#include <mach-footbridge/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/uaccess.h>
 #include <asm/therm.h>
diff --git a/drivers/char/hw_random/ixp4xx-rng.c b/drivers/char/hw_random/ixp4xx-rng.c
index 263567f..42889bb 100644
--- a/drivers/char/hw_random/ixp4xx-rng.c
+++ b/drivers/char/hw_random/ixp4xx-rng.c
@@ -23,7 +23,7 @@
 #include <linux/hw_random.h>
 
 #include <asm/io.h>
-#include <mach/hardware.h>
+#include <mach-ixp4xx/hardware.h>
 
 
 static int ixp4xx_rng_data_read(struct hwrng *rng, u32 *buffer)
diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index 74b830b..c771360 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -13,7 +13,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/mfd/dbx500-prcmu.h>
-#include <mach/id.h>
+#include <mach-ux500/id.h>
 
 static struct cpufreq_frequency_table freq_table[] = {
        [0] = {
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 9382a6b..637782b 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -18,7 +18,7 @@
 #include <linux/cpufreq.h>
 #include <linux/suspend.h>
 
-#include <mach/cpufreq.h>
+#include <mach-exynos/cpufreq.h>
 
 #include <plat-samsung/cpu.h>
 
diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
index fb148fa..33d3d4c 100644
--- a/drivers/cpufreq/exynos4210-cpufreq.c
+++ b/drivers/cpufreq/exynos4210-cpufreq.c
@@ -17,8 +17,8 @@
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
 
-#include <mach/regs-clock.h>
-#include <mach/cpufreq.h>
+#include <mach-exynos/regs-clock.h>
+#include <mach-exynos/cpufreq.h>
 
 #define CPUFREQ_LEVEL_END      L5
 
diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 8c5a7af..e7aa354 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -17,8 +17,8 @@
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
 
-#include <mach/regs-clock.h>
-#include <mach/cpufreq.h>
+#include <mach-exynos/regs-clock.h>
+#include <mach-exynos/cpufreq.h>
 
 #define CPUFREQ_LEVEL_END      (L13 + 1)
 
diff --git a/drivers/cpufreq/exynos5250-cpufreq.c b/drivers/cpufreq/exynos5250-cpufreq.c
index e64c253..74950a3 100644
--- a/drivers/cpufreq/exynos5250-cpufreq.c
+++ b/drivers/cpufreq/exynos5250-cpufreq.c
@@ -17,9 +17,9 @@
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
 
-#include <mach/map.h>
-#include <mach/regs-clock.h>
-#include <mach/cpufreq.h>
+#include <mach-exynos/map.h>
+#include <mach-exynos/regs-clock.h>
+#include <mach-exynos/cpufreq.h>
 
 #define CPUFREQ_LEVEL_END      (L15 + 1)
 
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 4449907..45b2331 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -35,7 +35,7 @@
 #include <plat-omap/common.h>
 #include <plat-omap/omap_device.h>
 
-#include <mach/hardware.h>
+#include <mach-omap2/hardware.h>
 
 /* OPP tolerance in percentage */
 #define        OPP_TOLERANCE   4
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index a484aae..04dfc10 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -20,7 +20,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/suspend.h>
 
-#include <mach/map.h>
+#include <mach-s5pv210/map.h>
 #include <mach/regs-clock.h>
 
 static struct clk *cpu_clk;
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 737afed..98e877d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -39,7 +39,7 @@
 
 #include <plat-omap/cpu.h>
 #include <plat-omap/dma.h>
-#include <mach/irqs.h>
+#include <mach-omap2/irqs.h>
 
 #define SHA_REG_DIGEST(x)              (0x00 + ((x) * 0x04))
 #define SHA_REG_DIN(x)                 (0x1C + ((x) * 0x04))
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index ac236f6..971bd27 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -41,7 +41,7 @@
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 
-#include <mach/clk.h>
+#include <mach-tegra/clk.h>
 
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index c8af6d4..e8d7ce8 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -30,7 +30,7 @@
 extern unsigned int exynos_result_of_asv;
 #endif
 
-#include <mach/regs-clock.h>
+#include <mach-exynos/regs-clock.h>
 
 #include <plat-samsung/map-s5p.h>
 
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index c64917e..09d7112 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -26,7 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <mach/dma.h>
+#include <mach-ep93xx/dma.h>
 
 #include "dmaengine.h"
 
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index fcfeb3c..0597cbc 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -28,8 +28,8 @@
 #include <linux/module.h>
 
 #include <asm/irq.h>
-#include <mach/dma.h>
-#include <mach/hardware.h>
+#include <mach-imx/dma.h>
+#include <mach-imx/hardware.h>
 
 #include "dmaengine.h"
 #define IMXDMA_MAX_CHAN_DESCRIPTORS    16
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index e6efd77..45592ca 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -26,9 +26,9 @@
 #include <linux/of_device.h>
 #include <linux/irqdomain.h>
 
-#include <mach/hardware.h>
+#include <plat-omap/hardware.h>
 #include <asm/irq.h>
-#include <mach/irqs.h>
+#include <plat-omap/irqs.h>
 #include <asm/gpio.h>
 #include <asm/mach/irq.h>
 
diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 58a6a63..c6440a5 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -26,7 +26,13 @@
 #include <linux/syscore_ops.h>
 #include <linux/slab.h>
 
-#include <mach/irqs.h>
+#ifdef CONFIG_ARCH_PXA
+#include <mach-pxa/irqs.h>
+#endif
+
+#ifdef CONFIG_ARCH_MMP
+#include <mach-mmp/irqs.h>
+#endif
 
 /*
  * We handle the GPIOs by banks, each bank covers up to 32 GPIOs with
diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.c
index ed9f48d..4d0f7797 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -17,7 +17,7 @@
 #include <linux/i2c-algo-bit.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-rpc/hardware.h>
 #include <asm/hardware/ioc.h>
 
 #define FORCE_ONES     0xdc
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 79b4bcb..d163b73 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -39,8 +39,8 @@
 #include <linux/cpufreq.h>
 #include <linux/gpio.h>
 
-#include <mach/hardware.h>
-#include <mach/i2c.h>
+#include <mach-davinci/hardware.h>
+#include <mach-davinci/i2c.h>
 
 /* ----- global defines ----------------------------------------------- */
 
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 0722f86..a8ffc39 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -53,8 +53,8 @@
 #include <linux/of_i2c.h>
 #include <linux/pinctrl/consumer.h>
 
-#include <mach/hardware.h>
-#include <mach/i2c.h>
+#include <mach-imx/hardware.h>
+#include <mach-imx/i2c.h>
 
 /** Defines ********************************************************************
 *******************************************************************************/
diff --git a/drivers/i2c/busses/i2c-nuc900.c b/drivers/i2c/busses/i2c-nuc900.c
index a26dfb8..cfe6803 100644
--- a/drivers/i2c/busses/i2c-nuc900.c
+++ b/drivers/i2c/busses/i2c-nuc900.c
@@ -28,8 +28,8 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 
-#include <mach/mfp.h>
-#include <mach/i2c.h>
+#include <mach-w90x900/mfp.h>
+#include <mach-w90x900/i2c.h>
 
 /* nuc900 i2c registers offset */
 
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 66eb53f..8712414 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -31,7 +31,7 @@
 
 #include <asm/unaligned.h>
 
-#include <mach/clk.h>
+#include <mach-tegra/clk.h>
 
 #define TEGRA_I2C_TIMEOUT (msecs_to_jiffies(1000))
 #define BYTES_PER_FIFO_WORD 4
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 50e2830..9b644e1 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -20,7 +20,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <mach/hardware.h>
+#include <mach-ixp4xx/hardware.h>
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("ixp4xx beeper driver");
diff --git a/drivers/input/mouse/rpcmouse.c b/drivers/input/mouse/rpcmouse.c
index 272dedd..41c1fa4 100644
--- a/drivers/input/mouse/rpcmouse.c
+++ b/drivers/input/mouse/rpcmouse.c
@@ -24,7 +24,7 @@
 #include <linux/input.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-rpc/hardware.h>
 #include <asm/irq.h>
 #include <asm/hardware/iomd.h>
 
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 2af5df6..5bee7e0 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -36,7 +36,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
+#include <mach-rpc/hardware.h>
 #include <asm/hardware/iomd.h>
 
 MODULE_AUTHOR("Vojtech Pavlik, Russell King");
diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index 201b2d2..00f8aac 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -22,8 +22,8 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <mach/board.h>
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
 
 /* Register definitions based on AT91SAM9RL64 preliminary draft datasheet */
 
diff --git a/drivers/input/touchscreen/h3600_ts_input.c b/drivers/input/touchscreen/h3600_ts_input.c
index b9e8686..39a0ce5 100644
--- a/drivers/input/touchscreen/h3600_ts_input.c
+++ b/drivers/input/touchscreen/h3600_ts_input.c
@@ -39,8 +39,8 @@
 #include <linux/delay.h>
 
 /* SA1100 serial defines */
-#include <mach/hardware.h>
-#include <mach/irqs.h>
+#include <mach-sa1100/hardware.h>
+#include <mach-sa1100/irqs.h>
 
 #define DRIVER_DESC    "H3600 touchscreen driver"
 
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 7d2b213..997e627 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -33,7 +33,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 
-#include <mach/regs-ac97.h>
+#include <mach-pxa/regs-ac97.h>
 
 #include <asm/mach-types.h>
 
diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
index bf0869a7..be59125 100644
--- a/drivers/input/touchscreen/zylonite-wm97xx.c
+++ b/drivers/input/touchscreen/zylonite-wm97xx.c
@@ -28,9 +28,9 @@
 #include <linux/io.h>
 #include <linux/wm97xx.h>
 
-#include <mach/hardware.h>
-#include <mach/mfp.h>
-#include <mach/regs-ac97.h>
+#include <mach-pxa/hardware.h>
+#include <mach-pxa/mfp.h>
+#include <mach-pxa/regs-ac97.h>
 
 struct continuous {
        u16 id;    /* codec id */
diff --git a/drivers/leds/leds-fsg.c b/drivers/leds/leds-fsg.c
index b9053fa..683b01d 100644
--- a/drivers/leds/leds-fsg.c
+++ b/drivers/leds/leds-fsg.c
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/module.h>
-#include <mach/hardware.h>
+#include <mach-ixp4xx/hardware.h>
 #include <asm/io.h>
 
 #define FSG_LED_WLAN_BIT       0
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 9c21e01..0d76655 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -36,8 +36,8 @@
 
 #include <linux/videodev2.h>
 
-#include <mach/dma.h>
-#include <mach/camera.h>
+#include <mach-pxa/dma.h>
+#include <mach-pxa/camera.h>
 
 #define PXA_CAM_VERSION "0.0.6"
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index 23108a6..7de55f8 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -13,7 +13,7 @@
 #ifndef __DB8500_PRCMU_REGS_H
 #define __DB8500_PRCMU_REGS_H
 
-#include <mach/hardware.h>
+#include <mach-ux500/hardware.h>
 
 #define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
 
diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 16d7179..a996270 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -24,7 +24,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 
-#include <mach/platform.h>
+#include <mach-ep93xx/platform.h>
 
 #define EP93XX_PWMx_TERM_COUNT 0x00
 #define EP93XX_PWMx_DUTY_CYCLE 0x04
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 123ed98..0a32042 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -20,8 +20,8 @@
 #include <linux/platform_device.h>
 #include <linux/pci_regs.h>
 #include <linux/configfs.h>
-#include <mach/pcie.h>
-#include <mach/misc_regs.h>
+#include <mach-spear13xx/pcie.h>
+#include <mach-spear13xx/misc_regs.h>
 
 #define IN0_MEM_SIZE   (200 * 1024 * 1024 - 1)
 /* In current implementation address translation is done using IN0 only.
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index efdb81d..ec7f665 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -75,8 +75,8 @@
 #include <asm/irq.h>
 #include <asm/gpio.h>
 
-#include <mach/board.h>
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
 
 #include "at91_mci.h"
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 28ed52d..dec1bb1 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -38,10 +38,10 @@
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/sizes.h>
-#include <mach/mmc.h>
+#include <mach-imx/mmc.h>
 
-#include <mach/dma.h>
-#include <mach/hardware.h>
+#include <mach-imx/dma.h>
+#include <mach-imx/hardware.h>
 
 #define DRIVER_NAME "mxc-mmc"
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 198066c..194bc04 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -39,7 +39,7 @@
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
-#include <mach/hardware.h>
+#include <plat-omap/hardware.h>
 #include <plat-omap/board.h>
 #include <plat-omap/mmc.h>
 #include <plat-omap/cpu.h>
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index cb2dc0e..8b01058 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -33,9 +33,9 @@
 
 #include <asm/sizes.h>
 
-#include <mach/hardware.h>
-#include <mach/dma.h>
-#include <mach/mmc.h>
+#include <mach-pxa/hardware.h>
+#include <mach-pxa/dma.h>
+#include <mach-pxa/mmc.h>
 
 #include "pxamci.h"
 
diff --git a/drivers/mtd/maps/cdb89712.c b/drivers/mtd/maps/cdb89712.c
index c29cbf8..c224dd4 100644
--- a/drivers/mtd/maps/cdb89712.c
+++ b/drivers/mtd/maps/cdb89712.c
@@ -9,7 +9,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
diff --git a/drivers/mtd/maps/h720x-flash.c b/drivers/mtd/maps/h720x-flash.c
index 8ed6cb4..3206fef 100644
--- a/drivers/mtd/maps/h720x-flash.c
+++ b/drivers/mtd/maps/h720x-flash.c
@@ -16,7 +16,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
-#include <mach/hardware.h>
+#include <mach-h720x/hardware.h>
 #include <asm/io.h>
 
 static struct mtd_info *mymtd;
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 81884c2..8a82445 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -20,7 +20,7 @@
 #include <linux/mtd/partitions.h>
 
 #include <asm/io.h>
-#include <mach/hardware.h>
+#include <mach-pxa/hardware.h>
 
 #include <asm/mach/flash.h>
 
diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
index a675bdb..2f234e6 100644
--- a/drivers/mtd/maps/sa1100-flash.c
+++ b/drivers/mtd/maps/sa1100-flash.c
@@ -19,7 +19,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/concat.h>
 
-#include <mach/hardware.h>
+#include <mach-sa1100/hardware.h>
 #include <asm/sizes.h>
 #include <asm/mach/flash.h>
 
diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 1386f6b..7a921a1 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -24,7 +24,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <asm/io.h>
-#include <mach/hardware.h>
+#include <mach-omap1/hardware.h>
 #include <asm/sizes.h>
 #include <linux/gpio.h>
 #include <plat-omap/board-ams-delta.h>
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index 3421e37..866aaac 100644
--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -25,7 +25,7 @@
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
-#include <mach/hardware.h>
+#include <mach-pxa/hardware.h>
 #include <asm/mach-types.h>
 
 struct sharpsl_nand {
diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index fcff73a..8f14511 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -37,7 +37,7 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 
-#include <mach/board.h>
+#include <mach-at91/board.h>
 
 #define AT91_MB_MASK(i)                ((1 << (i)) - 1)
 
diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/amd/am79c961a.c
index e10ffad..89746bf 100644
--- a/drivers/net/ethernet/amd/am79c961a.c
+++ b/drivers/net/ethernet/amd/am79c961a.c
@@ -29,7 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-ebsa110/hardware.h>
 
 #define TX_BUFFERS 15
 #define RX_BUFFERS 25
diff --git a/drivers/net/ethernet/cirrus/ep93xx_eth.c b/drivers/net/ethernet/cirrus/ep93xx_eth.c
index 78c5521..7ad8b0d 100644
--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -26,7 +26,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
+#include <mach-ep93xx/hardware.h>
 
 #define DRV_MODULE_NAME                "ep93xx-eth"
 #define DRV_MODULE_VERSION     "0.1"
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 4069eda..5be01c0 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -45,9 +45,9 @@
 #include <linux/types.h>
 
 #include <linux/io.h>
-#include <mach/board.h>
-#include <mach/platform.h>
-#include <mach/hardware.h>
+#include <mach-lpc32xx/board.h>
+#include <mach-lpc32xx/platform.h>
+#include <mach-lpc32xx/hardware.h>
 
 #define MODNAME "lpc-eth"
 #define DRV_VERSION "1.00"
diff --git a/drivers/net/ethernet/smsc/smc911x.h b/drivers/net/ethernet/smsc/smc911x.h
index 3269292..80eb9d0 100644
--- a/drivers/net/ethernet/smsc/smc911x.h
+++ b/drivers/net/ethernet/smsc/smc911x.h
@@ -211,7 +211,7 @@ static inline void SMC_outsl(struct smc911x_local *lp, int reg,
 
 #ifdef SMC_USE_PXA_DMA
 
-#include <mach/dma.h>
+#include <mach-pxa/dma.h>
 
 /*
  * Define the request and free functions
diff --git a/drivers/net/ethernet/smsc/smc91x.h b/drivers/net/ethernet/smsc/smc91x.h
index 7f4beeb..754af90 100644
--- a/drivers/net/ethernet/smsc/smc91x.h
+++ b/drivers/net/ethernet/smsc/smc91x.h
@@ -364,7 +364,7 @@ struct smc_local {
  * as RX which can overrun memory and lose packets.
  */
 #include <linux/dma-mapping.h>
-#include <mach-sa1100/dma.h>
+#include <mach-pxa/dma.h>
 
 #ifdef SMC_insl
 #undef SMC_insl
diff --git a/drivers/net/irda/ep7211-sir.c b/drivers/net/irda/ep7211-sir.c
index f83c5b8..8f8d91c 100644
--- a/drivers/net/irda/ep7211-sir.c
+++ b/drivers/net/irda/ep7211-sir.c
@@ -14,7 +14,7 @@
 #include <net/irda/irda_device.h>
 
 #include <asm/io.h>
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 
 #include "sir-dev.h"
 
diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 8d54767..86073eb 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -27,10 +27,10 @@
 #include <net/irda/wrapper.h>
 #include <net/irda/irda_device.h>
 
-#include <mach/dma.h>
-#include <mach/irda.h>
-#include <mach/regs-uart.h>
-#include <mach/regs-ost.h>
+#include <mach-pxa/dma.h>
+#include <mach-pxa/irda.h>
+#include <mach-pxa/regs-uart.h>
+#include <mach-pxa/regs-ost.h>
 
 #define FICP           __REG(0x40800000)  /* Start of FICP area */
 #define ICCR0          __REG(0x40800000)  /* ICP Control Register 0 */
diff --git a/drivers/net/irda/sa1100_ir.c b/drivers/net/irda/sa1100_ir.c
index e250675..3f88a39 100644
--- a/drivers/net/irda/sa1100_ir.c
+++ b/drivers/net/irda/sa1100_ir.c
@@ -37,7 +37,7 @@
 #include <net/irda/wrapper.h>
 #include <net/irda/irda_device.h>
 
-#include <mach/hardware.h>
+#include <mach-sa1100/hardware.h>
 #include <asm/mach/irda.h>
 
 static int power_level = 3;
diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index adb5b1e..070eaa6 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -20,7 +20,7 @@
 
 #include <pcmcia/ss.h>
 
-#include <mach/hardware.h>
+#include <mach-omap1/hardware.h>
 #include <asm/io.h>
 #include <asm/sizes.h>
 
diff --git a/drivers/pcmcia/pxa2xx_cm_x2xx.c b/drivers/pcmcia/pxa2xx_cm_x2xx.c
index 6e7dcfd..61097ba 100644
--- a/drivers/pcmcia/pxa2xx_cm_x2xx.c
+++ b/drivers/pcmcia/pxa2xx_cm_x2xx.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 
 #include <asm/mach-types.h>
-#include <mach/hardware.h>
+#include <mach-pxa/hardware.h>
 
 int cmx255_pcmcia_init(void);
 int cmx270_pcmcia_init(void);
diff --git a/drivers/pcmcia/sa1111_jornada720.c b/drivers/pcmcia/sa1111_jornada720.c
index 69428d1..86fc717 100644
--- a/drivers/pcmcia/sa1111_jornada720.c
+++ b/drivers/pcmcia/sa1111_jornada720.c
@@ -10,7 +10,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 
-#include <mach/hardware.h>
+#include <mach-sa1100/hardware.h>
 #include <asm/hardware/sa1111.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 6eecd7c..2d689b2 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -39,7 +39,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
+#include <mach-sa1100/hardware.h>
 #include <asm/irq.h>
 
 #include "soc_common.h"
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 44efc6e..af502d1 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/power/smartreflex.h>
+#include <plat-omap/cpu.h>
 
 #define SMARTREFLEX_NAME_LEN   16
 #define NVALUE_NAME_LEN                40
diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 2a0b353..68ff175 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -16,7 +16,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/pwm.h>
-#include <mach/hardware.h>
+#include <mach-imx/hardware.h>
 
 
 /* i.MX1 and i.MX21 share the same PWM function block: */
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index e3e50d6..eb4d40e 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -17,7 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 
-#include <mach/hardware.h>
+#include <mach-imx/hardware.h>
 
 #define RTC_INPUT_CLK_32768HZ  (0x00 << 5)
 #define RTC_INPUT_CLK_32000HZ  (0x01 << 5)
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 0075c8f..679ca79 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -28,7 +28,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
+#include <mach-pxa/hardware.h>
 
 #define TIMER_FREQ             CLOCK_TICK_RATE
 #define RTC_DEF_DIVIDER                (32768 - 1)
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 739ef556..9f7ff1d 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -27,7 +27,7 @@
 #include <linux/slab.h>
 #include <linux/of_device.h>
 
-#include <mach/common.h>
+#include <mach-mxs/common.h>
 
 #define STMP3XXX_RTC_CTRL                      0x0
 #define STMP3XXX_RTC_CTRL_SET                  0x4
diff --git a/drivers/scsi/arm/acornscsi-io.S b/drivers/scsi/arm/acornscsi-io.S
index 22171b2..6395330 100644
--- a/drivers/scsi/arm/acornscsi-io.S
+++ b/drivers/scsi/arm/acornscsi-io.S
@@ -8,7 +8,7 @@
 #include <linux/linkage.h>
 
 #include <asm/assembler.h>
-#include <mach/hardware.h>
+#include <mach-rpc/hardware.h>
 
 #if defined(__APCS_32__)
 #define LOADREGS(t,r,l...)     ldm##t  r, l
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index e834ff8..819ddf0 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -39,7 +39,7 @@
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
 
-#include <mach/spi.h>
+#include <mach-imx/spi.h>
 
 #define DRIVER_NAME "spi_imx"
 
diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 177b6cf..dc2ad86 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -48,7 +48,7 @@
 #include <linux/module.h>
 
 #include <asm/irq.h>
-#include <mach/hardware.h>
+#include <mach-omap1/hardware.h>
 #include <asm/io.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/spi/spi-s3c24xx-fiq.S b/drivers/spi/spi-s3c24xx-fiq.S
index 9718a11..44941ce 100644
--- a/drivers/spi/spi-s3c24xx-fiq.S
+++ b/drivers/spi/spi-s3c24xx-fiq.S
@@ -13,8 +13,8 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-#include <mach/map.h>
-#include <mach/regs-irq.h>
+#include <mach-s3c24xx/map.h>
+#include <mach-s3c24xx/regs-irq.h>
 #include <plat-samsung/regs-spi.h>
 
 #include "spi-s3c24xx-fiq.h"
diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index ef52c1c..77b2810 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -32,7 +32,7 @@
 #include <linux/spi/spi.h>
 #include <linux/dmaengine.h>
 
-#include <mach/dma.h>
+#include <mach-tegra/dma.h>
 
 #define SLINK_COMMAND          0x000
 #define   SLINK_BIT_LENGTH(x)          (((x) & 0x1f) << 0)
diff --git a/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c b/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
index a272e48..1e4f493 100644
--- a/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
+++ b/drivers/staging/ste_rmi4/board-mop500-u8500uib-rmi4.c
@@ -5,8 +5,8 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
-#include <mach/gpio.h>
-#include <mach/irqs.h>
+#include <mach-ux500/gpio.h>
+#include <mach-ux500/irqs.h>
 #include "synaptics_i2c_rmi4.h"
 
 /*
diff --git a/drivers/tty/serial/21285.c b/drivers/tty/serial/21285.c
index a44345a..8104b07 100644
--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -18,7 +18,7 @@
 #include <asm/mach-types.h>
 #include <asm/system_info.h>
 #include <asm/hardware/dec21285.h>
-#include <mach/hardware.h>
+#include <mach-footbridge/hardware.h>
 
 #define BAUD_BASE              (mem_fclk_21285/64)
 
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3d7e1ee..ff99a33 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -44,11 +44,13 @@
 #include <asm/ioctls.h>
 
 #include <asm/mach/serial_at91.h>
-#include <mach/board.h>
 
 #ifdef CONFIG_ARM
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
 #include <asm/gpio.h>
+#else
+#include <mach/board.h>
 #endif
 
 #define PDC_BUFFER_SIZE                512
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index d0f719f..e4dc87b 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -38,7 +38,7 @@
 #include <linux/serial.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-clps711x/hardware.h>
 #include <asm/irq.h>
 
 #define UART_NR                2
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index fca13dc..949c9e6 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -51,8 +51,8 @@
 #include <linux/atomic.h>
 #include <asm/irq.h>
 
-#include <mach/hardware.h>
-#include <mach/dma.h>
+#include <mach-msm/hardware.h>
+#include <mach-msm/dma.h>
 #include <linux/platform_data/msm_serial_hs.h>
 
 /* HSUART Registers */
diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index 2ca5959..d5c47f6 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -37,8 +37,8 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <mach/hardware.h>
-#include <mach/irqs.h>
+#include <mach-sa1100/hardware.h>
+#include <mach-sa1100/irqs.h>
 #include <asm/mach/serial_sa1100.h>
 
 /* We've been assigned a range on the "Low-density serial ports" major */
diff --git a/drivers/tty/serial/serial_ks8695.c b/drivers/tty/serial/serial_ks8695.c
index 7c13639..f5c672c 100644
--- a/drivers/tty/serial/serial_ks8695.c
+++ b/drivers/tty/serial/serial_ks8695.c
@@ -25,8 +25,8 @@
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
 
-#include <mach/regs-uart.h>
-#include <mach/regs-irq.h>
+#include <mach-ks8695/regs-uart.h>
+#include <mach-ks8695/regs-irq.h>
 
 #if defined(CONFIG_SERIAL_KS8695_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index 33a7a27..4bafe92 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -25,7 +25,7 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <mach/sram.h>
+#include <mach-davinci/sram.h>
 
 #define DRV_NAME "pruss_uio"
 #define DRV_VERSION "1.0"
diff --git a/drivers/usb/gadget/fsl_mxc_udc.c b/drivers/usb/gadget/fsl_mxc_udc.c
index 1b0f086..fce80b3 100644
--- a/drivers/usb/gadget/fsl_mxc_udc.c
+++ b/drivers/usb/gadget/fsl_mxc_udc.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
+#include <mach-imx/hardware.h>
 
 static struct clk *mxc_ahb_clk;
 static struct clk *mxc_per_clk;
diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index dc53348..476ac2b 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -35,8 +35,8 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 
-#include <mach/usb.h>
-#include <mach/hardware.h>
+#include <mach-imx/usb.h>
+#include <mach-imx/hardware.h>
 
 #include "imx_udc.h"
 
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 644b430..d4ef1fe 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -26,12 +26,12 @@
 #include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
-#include <mach/hardware.h>
+#include <mach-pxa/hardware.h>
 
 #include <linux/usb.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
-#include <mach/udc.h>
+#include <mach-pxa/udc.h>
 
 #include "pxa27x_udc.h"
 
diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index a665b3e..5add6ce 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -17,11 +17,11 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 
-#include <mach/hardware.h>
+#include <mach-at91/hardware.h>
 #include <asm/gpio.h>
 
-#include <mach/board.h>
-#include <mach/cpu.h>
+#include <mach-at91/board.h>
+#include <mach-at91/cpu.h>
 
 #ifndef CONFIG_ARCH_AT91
 #error "CONFIG_ARCH_AT91 must be defined."
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 2dce0df..561f56a 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -14,7 +14,7 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <mach/ohci.h>
+#include <mach-exynos/ohci.h>
 #include <plat-samsung/usb-phy.h>
 
 struct exynos_ohci_hcd {
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 472c8b4..2e8cfb8 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -34,8 +34,8 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 
-#include <mach/cputype.h>
-#include <mach/hardware.h>
+#include <mach-davinci/cputype.h>
+#include <mach-davinci/hardware.h>
 
 #include <asm/mach-types.h>
 
diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index d05c7fb..7c92d86 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -30,7 +30,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/pfn.h>
-#include <mach/usb.h>
+#include <mach-ux500/usb.h>
 #include "musb_core.h"
 
 struct ux500_dma_channel {
diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
index 9f5fc90..e41e6c5 100644
--- a/drivers/usb/otg/msm_otg.c
+++ b/drivers/usb/otg/msm_otg.c
@@ -40,7 +40,7 @@
 #include <linux/usb/msm_hsusb_hw.h>
 #include <linux/regulator/consumer.h>
 
-#include <mach/clk.h>
+#include <mach-msm/clk.h>
 
 #define MSM_USB_BASE   (motg->regs)
 #define DRIVER_NAME    "msm_otg"
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 1e39ae3..556b623 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -28,7 +28,7 @@
 #include <linux/backlight.h>
 #include <linux/slab.h>
 
-#include <mach/hardware.h>
+#include <mach-omap1/hardware.h>
 #include <plat-omap/board.h>
 #include <plat-omap/mux.h>
 
diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
index 345d962..b58f5c5 100644
--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -24,7 +24,7 @@
 #include <linux/clk.h>
 #include <linux/fb.h>
 
-#include <mach/fb.h>
+#include <mach-ep93xx/fb.h>
 
 /* Vertical Frame Timing Registers */
 #define EP93XXFB_VLINES_TOTAL                  0x0000  /* SW locked */
diff --git a/drivers/video/nuc900fb.h b/drivers/video/nuc900fb.h
index bc7c930..6f7f59a 100644
--- a/drivers/video/nuc900fb.h
+++ b/drivers/video/nuc900fb.h
@@ -15,8 +15,8 @@
 #ifndef __NUC900FB_H
 #define __NUC900FB_H
 
-#include <mach/map.h>
-#include <mach/fb.h>
+#include <mach-w90x900/map.h>
+#include <mach-w90x900/fb.h>
 
 enum nuc900_lcddrv_type {
        LCDDRV_NUC910,
diff --git a/drivers/video/pnx4008/dum.h b/drivers/video/pnx4008/dum.h
index 1234d43..ddae1c2 100644
--- a/drivers/video/pnx4008/dum.h
+++ b/drivers/video/pnx4008/dum.h
@@ -12,7 +12,7 @@
 #ifndef __PNX008_DUM_H__
 #define __PNX008_DUM_H__
 
-#include <mach/platform.h>
+#include <mach-pnx4008/platform.h>
 
 #define PNX4008_DUMCONF_VA_BASE                IO_ADDRESS(PNX4008_DUMCONF_BASE)
 #define PNX4008_DUM_MAIN_VA_BASE       IO_ADDRESS(PNX4008_DUM_MAINCFG_BASE)
diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 4b0fcf3..2d9cc12 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -19,7 +19,7 @@
 #include <linux/pm_runtime.h>
 
 #include <asm/irq.h>
-#include <mach/hardware.h>
+#include <mach-omap2/hardware.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index bcfab2b..f745c9b 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -33,7 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
-#include <mach/hardware.h>
+#include <mach-imx/hardware.h>
 
 #define DRIVER_NAME "imx2-wdt"
 
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 5580b4f..913d480 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
-#include <mach/hardware.h>
+#include <mach-ixp4xx/hardware.h>
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = 60;     /* (secs) Default is 1 minute */
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 59e75d9..19c1dc1 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -23,8 +23,8 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <mach/hardware.h>
-#include <mach/regs-timer.h>
+#include <mach-ks8695/hardware.h>
+#include <mach-ks8695/regs-timer.h>
 
 #define WDT_DEFAULT_TIME       5       /* seconds */
 #define WDT_MAX_TIME           171     /* seconds */
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index 5eec740..1e1c743 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -31,7 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <linux/irq.h>
-#include <mach/hardware.h>
+#include <mach-footbridge/hardware.h>
 
 #include <asm/mach-types.h>
 #include <asm/system_info.h>
-- 
