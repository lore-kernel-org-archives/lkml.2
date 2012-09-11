Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2IKNEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:04:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2IKNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:04:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jeff Garzik <jgarzik@pobox.com>, Guenter Roeck <linux@roeck-us.net>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 15/16] ARM: samsung: move platform_data definitions
Date: Tue, 11 Sep 2012 15:02:38 +0200
Message-Id: <1347368559-31329-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368559-31329-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368559-31329-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VjCYZs0AFDMItrM+Gw7EyEsWVaUsHxq1Fm2MfAjisFf
 ktbAnlphgX50WqK+dmpqF0o6iPMh07ecmTl8OI4v7uyxw+S4Jj
 weDDmFYDmNTzpT9Aij8vtJhNvlz4vBnIzIqPc10AqJoiXMe0k+
 LKtqmJh+l4tQHCDTIKZx3qyBhyOjTykdt/SBs1sz2WmDhT2buI
 zRVr+QYpLdxRaO7viftXAIL9I6N658RmM6PnzPFe/I33ufv/aC
 igpOpdzwt+QezXjdv8eYMDvKEetCfheZ19RWj5Z6Vg1MMckEki
 guuY4pLRi/fG6PAEGSMhQge9BQZia1F/NL3FUh3faXZSMjqD53
 eKxLljcF+RxCvU3epuybf27IgZ+NGcyXBUkGxnm4WDq/xQs70f
 DzTiYz9jCdP+uLHyL1Y8bXpixQwa9Y16BA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the samsung include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: linux-samsung-soc@vger.kernel.org
---
 arch/arm/mach-exynos/dev-audio.c                   |    2 +-
 arch/arm/mach-exynos/dev-ohci.c                    |    2 +-
 arch/arm/mach-exynos/mach-nuri.c                   |    6 +++---
 arch/arm/mach-exynos/mach-origen.c                 |    6 +++---
 arch/arm/mach-exynos/mach-smdk4x12.c               |    2 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |    6 +++---
 arch/arm/mach-exynos/mach-universal_c210.c         |    4 ++--
 arch/arm/mach-exynos/setup-i2c0.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c1.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c2.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c3.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c4.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c5.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c6.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c7.c                  |    2 +-
 arch/arm/mach-s3c24xx/common-smdk.c                |    4 ++--
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c                |    6 +++---
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |    6 +++---
 arch/arm/mach-s3c24xx/mach-bast.c                  |    8 ++++----
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   10 +++++-----
 arch/arm/mach-s3c24xx/mach-h1940.c                 |    8 ++++----
 arch/arm/mach-s3c24xx/mach-jive.c                  |    6 +++---
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   10 +++++-----
 arch/arm/mach-s3c24xx/mach-n30.c                   |    8 ++++----
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |    4 ++--
 arch/arm/mach-s3c24xx/mach-otom.c                  |    2 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c                |    8 ++++----
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   10 +++++-----
 arch/arm/mach-s3c24xx/mach-rx3715.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |    4 ++--
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |    8 ++++----
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |    6 +++---
 arch/arm/mach-s3c24xx/mach-vstms.c                 |    4 ++--
 arch/arm/mach-s3c24xx/setup-i2c.c                  |    2 +-
 arch/arm/mach-s3c24xx/simtec-audio.c               |    2 +-
 arch/arm/mach-s3c24xx/simtec-usb.c                 |    2 +-
 arch/arm/mach-s3c64xx/dev-audio.c                  |    2 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    4 ++--
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    4 ++--
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    4 ++--
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    4 ++--
 arch/arm/mach-s3c64xx/mach-smartq.c                |    8 ++++----
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    6 +++---
 arch/arm/mach-s3c64xx/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s3c64xx/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s3c64xx/setup-ide.c                  |    2 +-
 arch/arm/mach-s5p64x0/dev-audio.c                  |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    4 ++--
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    4 ++--
 arch/arm/mach-s5p64x0/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s5p64x0/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s5pc100/dev-audio.c                  |    2 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    8 ++++----
 arch/arm/mach-s5pc100/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s5pc100/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s5pv210/dev-audio.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |    4 ++--
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    6 +++---
 arch/arm/mach-s5pv210/mach-torbreck.c              |    2 +-
 arch/arm/mach-s5pv210/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s5pv210/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s5pv210/setup-i2c2.c                 |    2 +-
 arch/arm/plat-samsung/devs.c                       |   20 ++++++++++----------
 drivers/ata/pata_samsung_cf.c                      |    2 +-
 drivers/hwmon/s3c-hwmon.c                          |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |    2 +-
 drivers/input/touchscreen/s3c2410_ts.c             |    2 +-
 drivers/leds/leds-s3c24xx.c                        |    2 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |    2 +-
 drivers/mmc/host/s3cmci.c                          |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/spi/spi-s3c64xx.c                          |    2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |    2 +-
 drivers/usb/host/ehci-s5p.c                        |    2 +-
 drivers/usb/host/ohci-exynos.c                     |    2 +-
 drivers/usb/host/ohci-s3c2410.c                    |    2 +-
 .../linux/platform_data/asoc-s3c.h                 |    0
 .../linux/platform_data/asoc-s3c24xx_simtec.h      |    0
 .../linux/platform_data/ata-samsung_cf.h           |    0
 .../linux/platform_data/hwmon-s3c.h                |    0
 .../linux/platform_data/i2c-s3c2410.h              |    0
 .../linux/platform_data/leds-s3c24xx.h             |    0
 .../linux/platform_data/mipi-csis.h                |    0
 .../linux/platform_data/mmc-s3cmci.h               |    0
 .../linux/platform_data/mtd-nand-s3c2410.h         |    0
 .../linux/platform_data/spi-s3c64xx.h              |    0
 .../linux/platform_data/touchscreen-s3c2410.h      |    0
 .../linux/platform_data/usb-ehci-s5p.h             |    0
 .../linux/platform_data/usb-exynos.h               |    0
 .../linux/platform_data/usb-ohci-s3c2410.h         |    0
 .../linux/platform_data/usb-s3c2410_udc.h          |    0
 sound/soc/samsung/ac97.c                           |    2 +-
 sound/soc/samsung/i2s.c                            |    2 +-
 sound/soc/samsung/pcm.c                            |    2 +-
 sound/soc/samsung/s3c24xx_simtec.c                 |    2 +-
 sound/soc/samsung/spdif.c                          |    2 +-
 107 files changed, 164 insertions(+), 164 deletions(-)
 rename arch/arm/plat-samsung/include/plat/audio.h => include/linux/platform_data/asoc-s3c.h (100%)
 rename arch/arm/plat-samsung/include/plat/audio-simtec.h => include/linux/platform_data/asoc-s3c24xx_simtec.h (100%)
 rename arch/arm/plat-samsung/include/plat/ata.h => include/linux/platform_data/ata-samsung_cf.h (100%)
 rename arch/arm/plat-samsung/include/plat/hwmon.h => include/linux/platform_data/hwmon-s3c.h (100%)
 rename arch/arm/plat-samsung/include/plat/iic.h => include/linux/platform_data/i2c-s3c2410.h (100%)
 rename arch/arm/mach-s3c24xx/include/mach/leds-gpio.h => include/linux/platform_data/leds-s3c24xx.h (100%)
 rename arch/arm/plat-samsung/include/plat/mipi_csis.h => include/linux/platform_data/mipi-csis.h (100%)
 rename arch/arm/plat-samsung/include/plat/mci.h => include/linux/platform_data/mmc-s3cmci.h (100%)
 rename arch/arm/plat-samsung/include/plat/nand.h => include/linux/platform_data/mtd-nand-s3c2410.h (100%)
 rename arch/arm/plat-samsung/include/plat/s3c64xx-spi.h => include/linux/platform_data/spi-s3c64xx.h (100%)
 rename arch/arm/plat-samsung/include/plat/ts.h => include/linux/platform_data/touchscreen-s3c2410.h (100%)
 rename arch/arm/plat-samsung/include/plat/ehci.h => include/linux/platform_data/usb-ehci-s5p.h (100%)
 rename arch/arm/mach-exynos/include/mach/ohci.h => include/linux/platform_data/usb-exynos.h (100%)
 rename arch/arm/plat-samsung/include/plat/usb-control.h => include/linux/platform_data/usb-ohci-s3c2410.h (100%)
 rename arch/arm/plat-samsung/include/plat/udc.h => include/linux/platform_data/usb-s3c2410_udc.h (100%)

diff --git a/arch/arm/mach-exynos/dev-audio.c b/arch/arm/mach-exynos/dev-audio.c
index b33a5b6..ae321c7 100644
--- a/arch/arm/mach-exynos/dev-audio.c
+++ b/arch/arm/mach-exynos/dev-audio.c
@@ -16,7 +16,7 @@
 #include <linux/gpio.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 
 #include <mach/map.h>
 #include <mach/dma.h>
diff --git a/arch/arm/mach-exynos/dev-ohci.c b/arch/arm/mach-exynos/dev-ohci.c
index b8e7530..14ed795 100644
--- a/arch/arm/mach-exynos/dev-ohci.c
+++ b/arch/arm/mach-exynos/dev-ohci.c
@@ -15,7 +15,7 @@
 
 #include <mach/irqs.h>
 #include <mach/map.h>
-#include <mach/ohci.h>
+#include <linux/platform_data/usb-exynos.h>
 
 #include <plat/devs.h>
 #include <plat/usb-phy.h>
diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index ea785fc..393d2ce 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -45,14 +45,14 @@
 #include <plat/devs.h>
 #include <plat/fb.h>
 #include <plat/sdhci.h>
-#include <plat/ehci.h>
+#include <linux/platform_data/usb-ehci-s5p.h>
 #include <plat/clock.h>
 #include <plat/gpio-cfg.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/mfc.h>
 #include <plat/fimc-core.h>
 #include <plat/camport.h>
-#include <plat/mipi_csis.h>
+#include <linux/platform_data/mipi-csis.h>
 
 #include <mach/map.h>
 
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 5ca8030..4a531dc 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -35,15 +35,15 @@
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/sdhci.h>
-#include <plat/iic.h>
-#include <plat/ehci.h>
+#include <linux/platform_data/i2c-s3c2410.h>
+#include <linux/platform_data/usb-ehci-s5p.h>
 #include <plat/clock.h>
 #include <plat/gpio-cfg.h>
 #include <plat/backlight.h>
 #include <plat/fb.h>
 #include <plat/mfc.h>
 
-#include <mach/ohci.h>
+#include <linux/platform_data/usb-exynos.h>
 #include <mach/map.h>
 
 #include <drm/exynos_drm.h>
diff --git a/arch/arm/mach-exynos/mach-smdk4x12.c b/arch/arm/mach-exynos/mach-smdk4x12.c
index b26beb1..6a791fd 100644
--- a/arch/arm/mach-exynos/mach-smdk4x12.c
+++ b/arch/arm/mach-exynos/mach-smdk4x12.c
@@ -32,7 +32,7 @@
 #include <plat/devs.h>
 #include <plat/fb.h>
 #include <plat/gpio-cfg.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/keypad.h>
 #include <plat/mfc.h>
 #include <plat/regs-fb.h>
diff --git a/arch/arm/mach-exynos/mach-smdkv310.c b/arch/arm/mach-exynos/mach-smdkv310.c
index 3cfa688..fa2ada6 100644
--- a/arch/arm/mach-exynos/mach-smdkv310.c
+++ b/arch/arm/mach-exynos/mach-smdkv310.c
@@ -34,15 +34,15 @@
 #include <plat/fb.h>
 #include <plat/keypad.h>
 #include <plat/sdhci.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 #include <plat/backlight.h>
 #include <plat/mfc.h>
-#include <plat/ehci.h>
+#include <linux/platform_data/usb-ehci-s5p.h>
 #include <plat/clock.h>
 
 #include <mach/map.h>
-#include <mach/ohci.h>
+#include <linux/platform_data/usb-exynos.h>
 
 #include <drm/exynos_drm.h>
 #include "common.h"
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 4d1f40d..bc49e5a 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -34,7 +34,7 @@
 #include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 #include <plat/fb.h>
 #include <plat/mfc.h>
@@ -43,7 +43,7 @@
 #include <plat/fimc-core.h>
 #include <plat/s5p-time.h>
 #include <plat/camport.h>
-#include <plat/mipi_csis.h>
+#include <linux/platform_data/mipi-csis.h>
 
 #include <mach/map.h>
 
diff --git a/arch/arm/mach-exynos/setup-i2c0.c b/arch/arm/mach-exynos/setup-i2c0.c
index b90d94c..5700f23 100644
--- a/arch/arm/mach-exynos/setup-i2c0.c
+++ b/arch/arm/mach-exynos/setup-i2c0.c
@@ -14,7 +14,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 #include <plat/cpu.h>
 
diff --git a/arch/arm/mach-exynos/setup-i2c1.c b/arch/arm/mach-exynos/setup-i2c1.c
index fd7235a..8d2279c 100644
--- a/arch/arm/mach-exynos/setup-i2c1.c
+++ b/arch/arm/mach-exynos/setup-i2c1.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c1_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-exynos/setup-i2c2.c b/arch/arm/mach-exynos/setup-i2c2.c
index 2694b19..0ed62fc 100644
--- a/arch/arm/mach-exynos/setup-i2c2.c
+++ b/arch/arm/mach-exynos/setup-i2c2.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c2_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-exynos/setup-i2c3.c b/arch/arm/mach-exynos/setup-i2c3.c
index 379bd30..7787fd2 100644
--- a/arch/arm/mach-exynos/setup-i2c3.c
+++ b/arch/arm/mach-exynos/setup-i2c3.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c3_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-exynos/setup-i2c4.c b/arch/arm/mach-exynos/setup-i2c4.c
index 9f3c048..edc847f 100644
--- a/arch/arm/mach-exynos/setup-i2c4.c
+++ b/arch/arm/mach-exynos/setup-i2c4.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c4_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-exynos/setup-i2c5.c b/arch/arm/mach-exynos/setup-i2c5.c
index 77e1a1e..d88af7f 100644
--- a/arch/arm/mach-exynos/setup-i2c5.c
+++ b/arch/arm/mach-exynos/setup-i2c5.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c5_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-exynos/setup-i2c6.c b/arch/arm/mach-exynos/setup-i2c6.c
index 284d12b..c590286 100644
--- a/arch/arm/mach-exynos/setup-i2c6.c
+++ b/arch/arm/mach-exynos/setup-i2c6.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c6_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-exynos/setup-i2c7.c b/arch/arm/mach-exynos/setup-i2c7.c
index b7611ee..1bba755 100644
--- a/arch/arm/mach-exynos/setup-i2c7.c
+++ b/arch/arm/mach-exynos/setup-i2c7.c
@@ -13,7 +13,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c7_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s3c24xx/common-smdk.c b/arch/arm/mach-s3c24xx/common-smdk.c
index 87e75a2..3b2cf6d 100644
--- a/arch/arm/mach-s3c24xx/common-smdk.c
+++ b/arch/arm/mach-s3c24xx/common-smdk.c
@@ -37,9 +37,9 @@
 #include <asm/irq.h>
 
 #include <mach/regs-gpio.h>
-#include <mach/leds-gpio.h>
+#include <linux/platform_data/leds-s3c24xx.h>
 
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 
 #include <plat/common-smdk.h>
 #include <plat/gpio-cfg.h>
diff --git a/arch/arm/mach-s3c24xx/mach-amlm5900.c b/arch/arm/mach-s3c24xx/mach-amlm5900.c
index ea2c4b00..f4ad99c 100644
--- a/arch/arm/mach-s3c24xx/mach-amlm5900.c
+++ b/arch/arm/mach-s3c24xx/mach-amlm5900.c
@@ -53,7 +53,7 @@
 #include <mach/regs-lcd.h>
 #include <mach/regs-gpio.h>
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/gpio-cfg.h>
diff --git a/arch/arm/mach-s3c24xx/mach-anubis.c b/arch/arm/mach-s3c24xx/mach-anubis.c
index 5a7d0c0..df890fb 100644
--- a/arch/arm/mach-s3c24xx/mach-anubis.c
+++ b/arch/arm/mach-s3c24xx/mach-anubis.c
@@ -40,8 +40,8 @@
 #include <mach/regs-gpio.h>
 #include <mach/regs-mem.h>
 #include <mach/regs-lcd.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -53,7 +53,7 @@
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/audio-simtec.h>
+#include <linux/platform_data/asoc-s3c24xx_simtec.h>
 
 #include "simtec.h"
 #include "common.h"
diff --git a/arch/arm/mach-s3c24xx/mach-at2440evb.c b/arch/arm/mach-s3c24xx/mach-at2440evb.c
index 7a05abf..00381fe 100644
--- a/arch/arm/mach-s3c24xx/mach-at2440evb.c
+++ b/arch/arm/mach-s3c24xx/mach-at2440evb.c
@@ -36,8 +36,8 @@
 #include <mach/regs-gpio.h>
 #include <mach/regs-mem.h>
 #include <mach/regs-lcd.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
@@ -47,7 +47,7 @@
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/mci.h>
+#include <linux/platform_data/mmc-s3cmci.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-s3c24xx/mach-bast.c b/arch/arm/mach-s3c24xx/mach-bast.c
index 1cf1720..6a30ce7 100644
--- a/arch/arm/mach-s3c24xx/mach-bast.c
+++ b/arch/arm/mach-s3c24xx/mach-bast.c
@@ -45,9 +45,9 @@
 #include <mach/regs-mem.h>
 #include <mach/regs-lcd.h>
 
-#include <plat/hwmon.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
+#include <linux/platform_data/hwmon-s3c.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <mach/fb.h>
 
 #include <linux/mtd/mtd.h>
@@ -62,7 +62,7 @@
 #include <plat/cpu.h>
 #include <plat/cpu-freq.h>
 #include <plat/gpio-cfg.h>
-#include <plat/audio-simtec.h>
+#include <linux/platform_data/asoc-s3c24xx_simtec.h>
 
 #include "simtec.h"
 #include "common.h"
diff --git a/arch/arm/mach-s3c24xx/mach-gta02.c b/arch/arm/mach-s3c24xx/mach-gta02.c
index 92e1f93..4a96346 100644
--- a/arch/arm/mach-s3c24xx/mach-gta02.c
+++ b/arch/arm/mach-s3c24xx/mach-gta02.c
@@ -73,21 +73,21 @@
 #include <mach/regs-gpio.h>
 #include <mach/fb.h>
 
-#include <plat/usb-control.h>
+#include <linux/platform_data/usb-ohci-s3c2410.h>
 #include <mach/regs-mem.h>
 #include <mach/hardware.h>
 
 #include <mach/gta02.h>
 
 #include <plat/regs-serial.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/pm.h>
-#include <plat/udc.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
 #include <plat/gpio-cfg.h>
-#include <plat/iic.h>
-#include <plat/ts.h>
+#include <linux/platform_data/i2c-s3c2410.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index bb8d008..9638b33 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -56,8 +56,8 @@
 #include <mach/h1940.h>
 #include <mach/h1940-latch.h>
 #include <mach/fb.h>
-#include <plat/udc.h>
-#include <plat/iic.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/gpio-cfg.h>
 #include <plat/clock.h>
@@ -65,8 +65,8 @@
 #include <plat/cpu.h>
 #include <plat/pll.h>
 #include <plat/pm.h>
-#include <plat/mci.h>
-#include <plat/ts.h>
+#include <linux/platform_data/mmc-s3cmci.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 
 #include <sound/uda1380.h>
 
diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index ae73ba3..28ad25b 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -32,8 +32,8 @@
 #include <asm/mach/irq.h>
 
 #include <plat/regs-serial.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <mach/regs-power.h>
 #include <mach/regs-gpio.h>
@@ -54,7 +54,7 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/pm.h>
-#include <plat/udc.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
 
 static struct map_desc jive_iodesc[] __initdata = {
 };
diff --git a/arch/arm/mach-s3c24xx/mach-mini2440.c b/arch/arm/mach-s3c24xx/mach-mini2440.c
index bd6d252..c676b8e 100644
--- a/arch/arm/mach-s3c24xx/mach-mini2440.c
+++ b/arch/arm/mach-s3c24xx/mach-mini2440.c
@@ -39,14 +39,14 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <mach/leds-gpio.h>
+#include <linux/platform_data/leds-s3c24xx.h>
 #include <mach/regs-mem.h>
 #include <mach/regs-lcd.h>
 #include <mach/irqs.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
-#include <plat/mci.h>
-#include <plat/udc.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
+#include <linux/platform_data/mmc-s3cmci.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
diff --git a/arch/arm/mach-s3c24xx/mach-n30.c b/arch/arm/mach-s3c24xx/mach-n30.c
index 383d00c..c53a9bf 100644
--- a/arch/arm/mach-s3c24xx/mach-n30.c
+++ b/arch/arm/mach-s3c24xx/mach-n30.c
@@ -33,7 +33,7 @@
 #include <asm/mach-types.h>
 
 #include <mach/fb.h>
-#include <mach/leds-gpio.h>
+#include <linux/platform_data/leds-s3c24xx.h>
 #include <mach/regs-gpio.h>
 #include <mach/regs-lcd.h>
 
@@ -41,15 +41,15 @@
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/regs-serial.h>
 
 #include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/mci.h>
+#include <linux/platform_data/mmc-s3cmci.h>
 #include <plat/s3c2410.h>
-#include <plat/udc.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-s3c24xx/mach-nexcoder.c b/arch/arm/mach-s3c24xx/mach-nexcoder.c
index 5c05ba1..7841321 100644
--- a/arch/arm/mach-s3c24xx/mach-nexcoder.c
+++ b/arch/arm/mach-s3c24xx/mach-nexcoder.c
@@ -38,7 +38,7 @@
 //#include <asm/debug-ll.h>
 #include <mach/regs-gpio.h>
 #include <plat/regs-serial.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/gpio-cfg.h>
 #include <plat/s3c2410.h>
diff --git a/arch/arm/mach-s3c24xx/mach-osiris.c b/arch/arm/mach-s3c24xx/mach-osiris.c
index 95d0772..63c20019 100644
--- a/arch/arm/mach-s3c24xx/mach-osiris.c
+++ b/arch/arm/mach-s3c24xx/mach-osiris.c
@@ -41,8 +41,8 @@
 #include <mach/regs-gpio.h>
 #include <mach/regs-mem.h>
 #include <mach/regs-lcd.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
diff --git a/arch/arm/mach-s3c24xx/mach-otom.c b/arch/arm/mach-s3c24xx/mach-otom.c
index bc4b6ef..bca39f0 100644
--- a/arch/arm/mach-s3c24xx/mach-otom.c
+++ b/arch/arm/mach-s3c24xx/mach-otom.c
@@ -35,7 +35,7 @@
 #include <plat/s3c2410.h>
 #include <plat/clock.h>
 #include <plat/devs.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/cpu.h>
 
 #include "common.h"
diff --git a/arch/arm/mach-s3c24xx/mach-qt2410.c b/arch/arm/mach-s3c24xx/mach-qt2410.c
index 678bbca..7b6ba13 100644
--- a/arch/arm/mach-s3c24xx/mach-qt2410.c
+++ b/arch/arm/mach-s3c24xx/mach-qt2410.c
@@ -47,13 +47,13 @@
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 
-#include <mach/leds-gpio.h>
+#include <linux/platform_data/leds-s3c24xx.h>
 #include <mach/regs-lcd.h>
 #include <plat/regs-serial.h>
 #include <mach/fb.h>
-#include <plat/nand.h>
-#include <plat/udc.h>
-#include <plat/iic.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/common-smdk.h>
 #include <plat/gpio-cfg.h>
diff --git a/arch/arm/mach-s3c24xx/mach-rx1950.c b/arch/arm/mach-s3c24xx/mach-rx1950.c
index 7ee73f2..379fde5 100644
--- a/arch/arm/mach-s3c24xx/mach-rx1950.c
+++ b/arch/arm/mach-s3c24xx/mach-rx1950.c
@@ -49,15 +49,15 @@
 #include <plat/clock.h>
 #include <plat/regs-serial.h>
 #include <plat/regs-iic.h>
-#include <plat/mci.h>
-#include <plat/udc.h>
-#include <plat/nand.h>
-#include <plat/iic.h>
+#include <linux/platform_data/mmc-s3cmci.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/pm.h>
 #include <plat/irq.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 
 #include <sound/uda1380.h>
 
diff --git a/arch/arm/mach-s3c24xx/mach-rx3715.c b/arch/arm/mach-s3c24xx/mach-rx3715.c
index 56af354..dacbb9a 100644
--- a/arch/arm/mach-s3c24xx/mach-rx3715.c
+++ b/arch/arm/mach-s3c24xx/mach-rx3715.c
@@ -43,7 +43,7 @@
 #include <mach/regs-lcd.h>
 
 #include <mach/h1940.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 #include <mach/fb.h>
 
 #include <plat/clock.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2410.c b/arch/arm/mach-s3c24xx/mach-smdk2410.c
index bdc27e7..82796b9 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2410.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2410.c
@@ -47,7 +47,7 @@
 #include <asm/mach-types.h>
 
 #include <plat/regs-serial.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/devs.h>
 #include <plat/cpu.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2413.c b/arch/arm/mach-s3c24xx/mach-smdk2413.c
index b11451b..ce99fd8 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2413.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2413.c
@@ -38,8 +38,8 @@
 #include <mach/regs-lcd.h>
 
 #include <mach/idle.h>
-#include <plat/udc.h>
-#include <plat/iic.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <mach/fb.h>
 
 #include <plat/s3c2410.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2416.c b/arch/arm/mach-s3c24xx/mach-smdk2416.c
index c3100a0..db2787a 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2416.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2416.c
@@ -39,17 +39,17 @@
 #include <mach/regs-s3c2443-clock.h>
 
 #include <mach/idle.h>
-#include <mach/leds-gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/leds-s3c24xx.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/s3c2416.h>
 #include <plat/gpio-cfg.h>
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 #include <plat/sdhci.h>
-#include <plat/udc.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
 #include <linux/platform_data/s3c-hsudc.h>
 
 #include <plat/regs-fb-v4.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2440.c b/arch/arm/mach-s3c24xx/mach-smdk2440.c
index 83a1036..b7ff882 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2440.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2440.c
@@ -37,7 +37,7 @@
 
 #include <mach/idle.h>
 #include <mach/fb.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/s3c2410.h>
 #include <plat/s3c244x.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2443.c b/arch/arm/mach-s3c24xx/mach-smdk2443.c
index 2092369..2568656 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2443.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2443.c
@@ -37,7 +37,7 @@
 
 #include <mach/idle.h>
 #include <mach/fb.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/s3c2410.h>
 #include <plat/s3c2443.h>
diff --git a/arch/arm/mach-s3c24xx/mach-tct_hammer.c b/arch/arm/mach-s3c24xx/mach-tct_hammer.c
index fe99028..495bf5c 100644
--- a/arch/arm/mach-s3c24xx/mach-tct_hammer.c
+++ b/arch/arm/mach-s3c24xx/mach-tct_hammer.c
@@ -45,7 +45,7 @@
 #include <asm/mach-types.h>
 
 #include <plat/regs-serial.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 
diff --git a/arch/arm/mach-s3c24xx/mach-vr1000.c b/arch/arm/mach-s3c24xx/mach-vr1000.c
index bd5f189..14d5b12 100644
--- a/arch/arm/mach-s3c24xx/mach-vr1000.c
+++ b/arch/arm/mach-s3c24xx/mach-vr1000.c
@@ -43,13 +43,13 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <mach/leds-gpio.h>
+#include <linux/platform_data/leds-s3c24xx.h>
 
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/iic.h>
-#include <plat/audio-simtec.h>
+#include <linux/platform_data/i2c-s3c2410.h>
+#include <linux/platform_data/asoc-s3c24xx_simtec.h>
 
 #include "simtec.h"
 #include "common.h"
diff --git a/arch/arm/mach-s3c24xx/mach-vstms.c b/arch/arm/mach-s3c24xx/mach-vstms.c
index 94bfaa1..f1d44ae 100644
--- a/arch/arm/mach-s3c24xx/mach-vstms.c
+++ b/arch/arm/mach-s3c24xx/mach-vstms.c
@@ -39,8 +39,8 @@
 #include <mach/idle.h>
 #include <mach/fb.h>
 
-#include <plat/iic.h>
-#include <plat/nand.h>
+#include <linux/platform_data/i2c-s3c2410.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 
 #include <plat/s3c2410.h>
 #include <plat/s3c2412.h>
diff --git a/arch/arm/mach-s3c24xx/setup-i2c.c b/arch/arm/mach-s3c24xx/setup-i2c.c
index 9e90a7c..7b4f333 100644
--- a/arch/arm/mach-s3c24xx/setup-i2c.c
+++ b/arch/arm/mach-s3c24xx/setup-i2c.c
@@ -16,7 +16,7 @@
 struct platform_device;
 
 #include <plat/gpio-cfg.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <mach/hardware.h>
 #include <mach/regs-gpio.h>
 
diff --git a/arch/arm/mach-s3c24xx/simtec-audio.c b/arch/arm/mach-s3c24xx/simtec-audio.c
index 11881c9..fd0ef05 100644
--- a/arch/arm/mach-s3c24xx/simtec-audio.c
+++ b/arch/arm/mach-s3c24xx/simtec-audio.c
@@ -24,7 +24,7 @@
 #include <mach/hardware.h>
 #include <mach/regs-gpio.h>
 
-#include <plat/audio-simtec.h>
+#include <linux/platform_data/asoc-s3c24xx_simtec.h>
 #include <plat/devs.h>
 
 #include "simtec.h"
diff --git a/arch/arm/mach-s3c24xx/simtec-usb.c b/arch/arm/mach-s3c24xx/simtec-usb.c
index d91c1a7..17f8356 100644
--- a/arch/arm/mach-s3c24xx/simtec-usb.c
+++ b/arch/arm/mach-s3c24xx/simtec-usb.c
@@ -34,7 +34,7 @@
 #include <mach/hardware.h>
 #include <asm/irq.h>
 
-#include <plat/usb-control.h>
+#include <linux/platform_data/usb-ohci-s3c2410.h>
 #include <plat/devs.h>
 
 #include "simtec.h"
diff --git a/arch/arm/mach-s3c64xx/dev-audio.c b/arch/arm/mach-s3c64xx/dev-audio.c
index 124fd5d..35f3e07 100644
--- a/arch/arm/mach-s3c64xx/dev-audio.c
+++ b/arch/arm/mach-s3c64xx/dev-audio.c
@@ -20,7 +20,7 @@
 #include <mach/dma.h>
 
 #include <plat/devs.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 #include <plat/gpio-cfg.h>
 
 static const char *rclksrc[] = {
diff --git a/arch/arm/mach-s3c64xx/mach-anw6410.c b/arch/arm/mach-s3c64xx/mach-anw6410.c
index ffa29dd..15c58df 100644
--- a/arch/arm/mach-s3c64xx/mach-anw6410.c
+++ b/arch/arm/mach-s3c64xx/mach-anw6410.c
@@ -42,7 +42,7 @@
 #include <asm/mach-types.h>
 
 #include <plat/regs-serial.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/fb.h>
 #include <plat/regs-fb-v4.h>
 
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410-module.c b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
index 9e382e7..181aa994 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410-module.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410-module.c
@@ -24,7 +24,7 @@
 #include <sound/wm8962.h>
 #include <sound/wm9081.h>
 
-#include <plat/s3c64xx-spi.h>
+#include <linux/platform_data/spi-s3c64xx.h>
 
 #include <mach/crag6410.h>
 
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410.c b/arch/arm/mach-s3c64xx/mach-crag6410.c
index 09cd812..717d675 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@ -61,14 +61,14 @@
 #include <plat/fb.h>
 #include <plat/sdhci.h>
 #include <plat/gpio-cfg.h>
-#include <plat/s3c64xx-spi.h>
+#include <linux/platform_data/spi-s3c64xx.h>
 
 #include <plat/keypad.h>
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/adc.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/pm.h>
 
 #include "common.h"
diff --git a/arch/arm/mach-s3c64xx/mach-hmt.c b/arch/arm/mach-s3c64xx/mach-hmt.c
index 6890881..02222b3 100644
--- a/arch/arm/mach-s3c64xx/mach-hmt.c
+++ b/arch/arm/mach-s3c64xx/mach-hmt.c
@@ -34,9 +34,9 @@
 #include <asm/mach-types.h>
 
 #include <plat/regs-serial.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/fb.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 
 #include <plat/clock.h>
 #include <plat/devs.h>
diff --git a/arch/arm/mach-s3c64xx/mach-mini6410.c b/arch/arm/mach-s3c64xx/mach-mini6410.c
index 5539a255..09311cc 100644
--- a/arch/arm/mach-s3c64xx/mach-mini6410.c
+++ b/arch/arm/mach-s3c64xx/mach-mini6410.c
@@ -38,9 +38,9 @@
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/fb.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 #include <plat/regs-serial.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 #include <plat/regs-fb-v4.h>
 
 #include <video/platform_lcd.h>
diff --git a/arch/arm/mach-s3c64xx/mach-ncp.c b/arch/arm/mach-s3c64xx/mach-ncp.c
index cad2e05..46ee88d 100644
--- a/arch/arm/mach-s3c64xx/mach-ncp.c
+++ b/arch/arm/mach-s3c64xx/mach-ncp.c
@@ -37,7 +37,7 @@
 #include <asm/mach-types.h>
 
 #include <plat/regs-serial.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/fb.h>
 
 #include <plat/clock.h>
diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-s3c64xx/mach-real6410.c
index 326b216..6daca20 100644
--- a/arch/arm/mach-s3c64xx/mach-real6410.c
+++ b/arch/arm/mach-s3c64xx/mach-real6410.c
@@ -39,9 +39,9 @@
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/fb.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 #include <plat/regs-serial.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 #include <plat/regs-fb-v4.h>
 
 #include <video/platform_lcd.h>
diff --git a/arch/arm/mach-s3c64xx/mach-smartq.c b/arch/arm/mach-s3c64xx/mach-smartq.c
index ceeb1de..c6d7390 100644
--- a/arch/arm/mach-s3c64xx/mach-smartq.c
+++ b/arch/arm/mach-s3c64xx/mach-smartq.c
@@ -30,13 +30,13 @@
 #include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
-#include <plat/hwmon.h>
+#include <linux/platform_data/hwmon-s3c.h>
 #include <plat/regs-serial.h>
-#include <plat/usb-control.h>
+#include <linux/platform_data/usb-ohci-s3c2410.h>
 #include <plat/sdhci.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 
 #include <video/platform_lcd.h>
 
diff --git a/arch/arm/mach-s3c64xx/mach-smdk6400.c b/arch/arm/mach-s3c64xx/mach-smdk6400.c
index b0f4525..a928fae 100644
--- a/arch/arm/mach-s3c64xx/mach-smdk6400.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6400.c
@@ -35,7 +35,7 @@
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-s3c64xx/mach-smdk6410.c b/arch/arm/mach-s3c64xx/mach-smdk6410.c
index 0fe4f15..2547a88 100644
--- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@ -60,8 +60,8 @@
 #include <mach/regs-gpio.h>
 #include <mach/regs-sys.h>
 #include <mach/regs-srom.h>
-#include <plat/ata.h>
-#include <plat/iic.h>
+#include <linux/platform_data/ata-samsung_cf.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/fb.h>
 #include <plat/gpio-cfg.h>
 
@@ -69,7 +69,7 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/adc.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 #include <plat/keypad.h>
 #include <plat/backlight.h>
 #include <plat/regs-fb-v4.h>
diff --git a/arch/arm/mach-s3c64xx/setup-i2c0.c b/arch/arm/mach-s3c64xx/setup-i2c0.c
index 241af94..40666ba 100644
--- a/arch/arm/mach-s3c64xx/setup-i2c0.c
+++ b/arch/arm/mach-s3c64xx/setup-i2c0.c
@@ -18,7 +18,7 @@
 
 struct platform_device; /* don't need the contents */
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c0_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s3c64xx/setup-i2c1.c b/arch/arm/mach-s3c64xx/setup-i2c1.c
index 3d13a96..3fdb24c 100644
--- a/arch/arm/mach-s3c64xx/setup-i2c1.c
+++ b/arch/arm/mach-s3c64xx/setup-i2c1.c
@@ -18,7 +18,7 @@
 
 struct platform_device; /* don't need the contents */
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c1_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s3c64xx/setup-ide.c b/arch/arm/mach-s3c64xx/setup-ide.c
index 41b4256..648d8b8 100644
--- a/arch/arm/mach-s3c64xx/setup-ide.c
+++ b/arch/arm/mach-s3c64xx/setup-ide.c
@@ -17,7 +17,7 @@
 #include <mach/map.h>
 #include <mach/regs-clock.h>
 #include <plat/gpio-cfg.h>
-#include <plat/ata.h>
+#include <linux/platform_data/ata-samsung_cf.h>
 
 void s3c64xx_ide_setup_gpio(void)
 {
diff --git a/arch/arm/mach-s5p64x0/dev-audio.c b/arch/arm/mach-s5p64x0/dev-audio.c
index 91113dd..a0d6edf 100644
--- a/arch/arm/mach-s5p64x0/dev-audio.c
+++ b/arch/arm/mach-s5p64x0/dev-audio.c
@@ -13,7 +13,7 @@
 #include <linux/gpio.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 
 #include <mach/map.h>
 #include <mach/dma.h>
diff --git a/arch/arm/mach-s5p64x0/mach-smdk6440.c b/arch/arm/mach-s5p64x0/mach-smdk6440.c
index 92fefad..dea78a8 100644
--- a/arch/arm/mach-s5p64x0/mach-smdk6440.c
+++ b/arch/arm/mach-s5p64x0/mach-smdk6440.c
@@ -45,10 +45,10 @@
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/pll.h>
 #include <plat/adc.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 #include <plat/s5p-time.h>
 #include <plat/backlight.h>
 #include <plat/fb.h>
diff --git a/arch/arm/mach-s5p64x0/mach-smdk6450.c b/arch/arm/mach-s5p64x0/mach-smdk6450.c
index e2335ec..6f14fc7 100644
--- a/arch/arm/mach-s5p64x0/mach-smdk6450.c
+++ b/arch/arm/mach-s5p64x0/mach-smdk6450.c
@@ -45,10 +45,10 @@
 #include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/pll.h>
 #include <plat/adc.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 #include <plat/s5p-time.h>
 #include <plat/backlight.h>
 #include <plat/fb.h>
diff --git a/arch/arm/mach-s5p64x0/setup-i2c0.c b/arch/arm/mach-s5p64x0/setup-i2c0.c
index 46b4639..a32edc5 100644
--- a/arch/arm/mach-s5p64x0/setup-i2c0.c
+++ b/arch/arm/mach-s5p64x0/setup-i2c0.c
@@ -19,7 +19,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <plat/gpio-cfg.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <mach/i2c.h>
 
diff --git a/arch/arm/mach-s5p64x0/setup-i2c1.c b/arch/arm/mach-s5p64x0/setup-i2c1.c
index 6ad3b98..ca2c5c7 100644
--- a/arch/arm/mach-s5p64x0/setup-i2c1.c
+++ b/arch/arm/mach-s5p64x0/setup-i2c1.c
@@ -19,7 +19,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <plat/gpio-cfg.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 #include <mach/i2c.h>
 
diff --git a/arch/arm/mach-s5pc100/dev-audio.c b/arch/arm/mach-s5pc100/dev-audio.c
index 9d4bde3..1cc252c 100644
--- a/arch/arm/mach-s5pc100/dev-audio.c
+++ b/arch/arm/mach-s5pc100/dev-audio.c
@@ -13,7 +13,7 @@
 #include <linux/gpio.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 
 #include <mach/map.h>
 #include <mach/dma.h>
diff --git a/arch/arm/mach-s5pc100/mach-smdkc100.c b/arch/arm/mach-s5pc100/mach-smdkc100.c
index 0c3ae38..5d2c093 100644
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c
+++ b/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -44,12 +44,12 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/fb.h>
-#include <plat/iic.h>
-#include <plat/ata.h>
+#include <linux/platform_data/i2c-s3c2410.h>
+#include <linux/platform_data/ata-samsung_cf.h>
 #include <plat/adc.h>
 #include <plat/keypad.h>
-#include <plat/ts.h>
-#include <plat/audio.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
+#include <linux/platform_data/asoc-s3c.h>
 #include <plat/backlight.h>
 #include <plat/regs-fb-v4.h>
 
diff --git a/arch/arm/mach-s5pc100/setup-i2c0.c b/arch/arm/mach-s5pc100/setup-i2c0.c
index eaef7a3..89a6a76 100644
--- a/arch/arm/mach-s5pc100/setup-i2c0.c
+++ b/arch/arm/mach-s5pc100/setup-i2c0.c
@@ -18,7 +18,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c0_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s5pc100/setup-i2c1.c b/arch/arm/mach-s5pc100/setup-i2c1.c
index aaff74a..faa667e 100644
--- a/arch/arm/mach-s5pc100/setup-i2c1.c
+++ b/arch/arm/mach-s5pc100/setup-i2c1.c
@@ -18,7 +18,7 @@
 struct platform_device; /* don't need the contents */
 
 #include <linux/gpio.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c1_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s5pv210/dev-audio.c b/arch/arm/mach-s5pv210/dev-audio.c
index 8367749..0a5480b 100644
--- a/arch/arm/mach-s5pv210/dev-audio.c
+++ b/arch/arm/mach-s5pv210/dev-audio.c
@@ -13,7 +13,7 @@
 #include <linux/gpio.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 
 #include <mach/map.h>
 #include <mach/dma.h>
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 822a559..00f1e47 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -43,7 +43,7 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/fb.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/keypad.h>
 #include <plat/sdhci.h>
 #include <plat/clock.h>
diff --git a/arch/arm/mach-s5pv210/mach-smdkc110.c b/arch/arm/mach-s5pv210/mach-smdkc110.c
index dfc2923..d9c99fc 100644
--- a/arch/arm/mach-s5pv210/mach-smdkc110.c
+++ b/arch/arm/mach-s5pv210/mach-smdkc110.c
@@ -27,8 +27,8 @@
 #include <plat/regs-serial.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/ata.h>
-#include <plat/iic.h>
+#include <linux/platform_data/ata-samsung_cf.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/pm.h>
 #include <plat/s5p-time.h>
 #include <plat/mfc.h>
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
index 918b23d..7d6fab4 100644
--- a/arch/arm/mach-s5pv210/mach-smdkv210.c
+++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
@@ -38,9 +38,9 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/adc.h>
-#include <plat/ts.h>
-#include <plat/ata.h>
-#include <plat/iic.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
+#include <linux/platform_data/ata-samsung_cf.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/keypad.h>
 #include <plat/pm.h>
 #include <plat/fb.h>
diff --git a/arch/arm/mach-s5pv210/mach-torbreck.c b/arch/arm/mach-s5pv210/mach-torbreck.c
index 74e99bc..18785cb 100644
--- a/arch/arm/mach-s5pv210/mach-torbreck.c
+++ b/arch/arm/mach-s5pv210/mach-torbreck.c
@@ -26,7 +26,7 @@
 #include <plat/regs-serial.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/s5p-time.h>
 
 #include "common.h"
diff --git a/arch/arm/mach-s5pv210/setup-i2c0.c b/arch/arm/mach-s5pv210/setup-i2c0.c
index 0f1cc3a..4a15849 100644
--- a/arch/arm/mach-s5pv210/setup-i2c0.c
+++ b/arch/arm/mach-s5pv210/setup-i2c0.c
@@ -18,7 +18,7 @@
 
 struct platform_device; /* don't need the contents */
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c0_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s5pv210/setup-i2c1.c b/arch/arm/mach-s5pv210/setup-i2c1.c
index f61365a..4777f6b 100644
--- a/arch/arm/mach-s5pv210/setup-i2c1.c
+++ b/arch/arm/mach-s5pv210/setup-i2c1.c
@@ -18,7 +18,7 @@
 
 struct platform_device; /* don't need the contents */
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c1_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/mach-s5pv210/setup-i2c2.c b/arch/arm/mach-s5pv210/setup-i2c2.c
index 2f91b5c..bbce6c7 100644
--- a/arch/arm/mach-s5pv210/setup-i2c2.c
+++ b/arch/arm/mach-s5pv210/setup-i2c2.c
@@ -18,7 +18,7 @@
 
 struct platform_device; /* don't need the contents */
 
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/gpio-cfg.h>
 
 void s3c_i2c2_cfg_gpio(struct platform_device *dev)
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 74e31ce..07913ac 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -46,24 +46,24 @@
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/adc.h>
-#include <plat/ata.h>
-#include <plat/ehci.h>
+#include <linux/platform_data/ata-samsung_cf.h>
+#include <linux/platform_data/usb-ehci-s5p.h>
 #include <plat/fb.h>
 #include <plat/fb-s3c2410.h>
-#include <plat/hwmon.h>
-#include <plat/iic.h>
+#include <linux/platform_data/hwmon-s3c.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/keypad.h>
-#include <plat/mci.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mmc-s3cmci.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 #include <plat/sdhci.h>
-#include <plat/ts.h>
-#include <plat/udc.h>
-#include <plat/usb-control.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
+#include <linux/platform_data/usb-ohci-s3c2410.h>
 #include <plat/usb-phy.h>
 #include <plat/regs-iic.h>
 #include <plat/regs-serial.h>
 #include <plat/regs-spi.h>
-#include <plat/s3c64xx-spi.h>
+#include <linux/platform_data/spi-s3c64xx.h>
 
 static u64 samsung_device_dma_mask = DMA_BIT_MASK(32);
 
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 1b372c2..63ffb00 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -23,7 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include <plat/ata.h>
+#include <linux/platform_data/ata-samsung_cf.h>
 #include <plat/regs-ata.h>
 
 #define DRV_NAME "pata_samsung_cf"
diff --git a/drivers/hwmon/s3c-hwmon.c b/drivers/hwmon/s3c-hwmon.c
index b7975f8..fe11b95 100644
--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -34,7 +34,7 @@
 #include <linux/hwmon-sysfs.h>
 
 #include <plat/adc.h>
-#include <plat/hwmon.h>
+#include <linux/platform_data/hwmon-s3c.h>
 
 struct s3c_hwmon_attr {
 	struct sensor_device_attribute	in;
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 5ae3b02..4d07dea 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -42,7 +42,7 @@
 #include <asm/irq.h>
 
 #include <plat/regs-iic.h>
-#include <plat/iic.h>
+#include <linux/platform_data/i2c-s3c2410.h>
 
 /* Treat S3C2410 as baseline hardware, anything else is supported via quirks */
 #define QUIRK_S3C2440		(1 << 0)
diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index bf1a064..df9e816 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -37,7 +37,7 @@
 
 #include <plat/adc.h>
 #include <plat/regs-adc.h>
-#include <plat/ts.h>
+#include <linux/platform_data/touchscreen-s3c2410.h>
 
 #define TSC_SLEEP  (S3C2410_ADCTSC_PULL_UP_DISABLE | S3C2410_ADCTSC_XY_PST(0))
 
diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index 942f0ea..e1a0df6 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -21,7 +21,7 @@
 
 #include <mach/hardware.h>
 #include <mach/regs-gpio.h>
-#include <mach/leds-gpio.h>
+#include <linux/platform_data/leds-s3c24xx.h>
 
 /* our context */
 
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index 2f73d9e..5e89843 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -26,7 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-subdev.h>
-#include <plat/mipi_csis.h>
+#include <linux/platform_data/mipi-csis.h>
 #include "mipi-csis.h"
 
 static int debug;
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index bd5a5cc..4638dda 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -27,7 +27,7 @@
 
 #include <mach/regs-sdi.h>
 
-#include <plat/mci.h>
+#include <linux/platform_data/mmc-s3cmci.h>
 
 #include "s3cmci.h"
 
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 91121f3..d804061 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -46,7 +46,7 @@
 #include <asm/io.h>
 
 #include <plat/regs-nand.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-s3c2410.h>
 
 #ifdef CONFIG_MTD_NAND_S3C2410_HWECC
 static int hardware_ecc = 1;
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index d1c8441f..0e2a022 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -32,7 +32,7 @@
 #include <linux/of_gpio.h>
 
 #include <mach/dma.h>
-#include <plat/s3c64xx-spi.h>
+#include <linux/platform_data/spi-s3c64xx.h>
 
 #define MAX_SPI_PORTS		3
 
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index f2e51f5..f006045 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -43,7 +43,7 @@
 #include <mach/hardware.h>
 
 #include <plat/regs-udc.h>
-#include <plat/udc.h>
+#include <linux/platform_data/usb-s3c2410_udc.h>
 
 
 #include "s3c2410_udc.h"
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 9d8f1dd..dfb14c7 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -16,7 +16,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
-#include <plat/ehci.h>
+#include <linux/platform_data/usb-ehci-s5p.h>
 #include <plat/usb-phy.h>
 
 #define EHCI_INSNREG00(base)			(base + 0x90)
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index fc3091b..20a5008 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -14,7 +14,7 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <mach/ohci.h>
+#include <linux/platform_data/usb-exynos.h>
 #include <plat/usb-phy.h>
 
 struct exynos_ohci_hcd {
diff --git a/drivers/usb/host/ohci-s3c2410.c b/drivers/usb/host/ohci-s3c2410.c
index 664c869..0d2309c 100644
--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -21,7 +21,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-#include <plat/usb-control.h>
+#include <linux/platform_data/usb-ohci-s3c2410.h>
 
 #define valid_port(idx) ((idx) == 1 || (idx) == 2)
 
diff --git a/arch/arm/plat-samsung/include/plat/audio.h b/include/linux/platform_data/asoc-s3c.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/audio.h
rename to include/linux/platform_data/asoc-s3c.h
diff --git a/arch/arm/plat-samsung/include/plat/audio-simtec.h b/include/linux/platform_data/asoc-s3c24xx_simtec.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/audio-simtec.h
rename to include/linux/platform_data/asoc-s3c24xx_simtec.h
diff --git a/arch/arm/plat-samsung/include/plat/ata.h b/include/linux/platform_data/ata-samsung_cf.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/ata.h
rename to include/linux/platform_data/ata-samsung_cf.h
diff --git a/arch/arm/plat-samsung/include/plat/hwmon.h b/include/linux/platform_data/hwmon-s3c.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/hwmon.h
rename to include/linux/platform_data/hwmon-s3c.h
diff --git a/arch/arm/plat-samsung/include/plat/iic.h b/include/linux/platform_data/i2c-s3c2410.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/iic.h
rename to include/linux/platform_data/i2c-s3c2410.h
diff --git a/arch/arm/mach-s3c24xx/include/mach/leds-gpio.h b/include/linux/platform_data/leds-s3c24xx.h
similarity index 100%
rename from arch/arm/mach-s3c24xx/include/mach/leds-gpio.h
rename to include/linux/platform_data/leds-s3c24xx.h
diff --git a/arch/arm/plat-samsung/include/plat/mipi_csis.h b/include/linux/platform_data/mipi-csis.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/mipi_csis.h
rename to include/linux/platform_data/mipi-csis.h
diff --git a/arch/arm/plat-samsung/include/plat/mci.h b/include/linux/platform_data/mmc-s3cmci.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/mci.h
rename to include/linux/platform_data/mmc-s3cmci.h
diff --git a/arch/arm/plat-samsung/include/plat/nand.h b/include/linux/platform_data/mtd-nand-s3c2410.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/nand.h
rename to include/linux/platform_data/mtd-nand-s3c2410.h
diff --git a/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h b/include/linux/platform_data/spi-s3c64xx.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
rename to include/linux/platform_data/spi-s3c64xx.h
diff --git a/arch/arm/plat-samsung/include/plat/ts.h b/include/linux/platform_data/touchscreen-s3c2410.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/ts.h
rename to include/linux/platform_data/touchscreen-s3c2410.h
diff --git a/arch/arm/plat-samsung/include/plat/ehci.h b/include/linux/platform_data/usb-ehci-s5p.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/ehci.h
rename to include/linux/platform_data/usb-ehci-s5p.h
diff --git a/arch/arm/mach-exynos/include/mach/ohci.h b/include/linux/platform_data/usb-exynos.h
similarity index 100%
rename from arch/arm/mach-exynos/include/mach/ohci.h
rename to include/linux/platform_data/usb-exynos.h
diff --git a/arch/arm/plat-samsung/include/plat/usb-control.h b/include/linux/platform_data/usb-ohci-s3c2410.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/usb-control.h
rename to include/linux/platform_data/usb-ohci-s3c2410.h
diff --git a/arch/arm/plat-samsung/include/plat/udc.h b/include/linux/platform_data/usb-s3c2410_udc.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/udc.h
rename to include/linux/platform_data/usb-s3c2410_udc.h
diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index 3d04c1f..14fbcd3 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -21,7 +21,7 @@
 
 #include <mach/dma.h>
 #include <plat/regs-ac97.h>
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 
 #include "dma.h"
 
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 6ac7b82..40b00a1 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -20,7 +20,7 @@
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 
 #include "dma.h"
 #include "idma.h"
diff --git a/sound/soc/samsung/pcm.c b/sound/soc/samsung/pcm.c
index 89b0646..c860819 100644
--- a/sound/soc/samsung/pcm.c
+++ b/sound/soc/samsung/pcm.c
@@ -19,7 +19,7 @@
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 #include <mach/dma.h>
 
 #include "dma.h"
diff --git a/sound/soc/samsung/s3c24xx_simtec.c b/sound/soc/samsung/s3c24xx_simtec.c
index 656d5af..335a7d8 100644
--- a/sound/soc/samsung/s3c24xx_simtec.c
+++ b/sound/soc/samsung/s3c24xx_simtec.c
@@ -13,7 +13,7 @@
 
 #include <sound/soc.h>
 
-#include <plat/audio-simtec.h>
+#include <linux/platform_data/asoc-s3c24xx_simtec.h>
 
 #include "s3c24xx-i2s.h"
 #include "s3c24xx_simtec.h"
diff --git a/sound/soc/samsung/spdif.c b/sound/soc/samsung/spdif.c
index a5a56a1..bc24c7a 100644
--- a/sound/soc/samsung/spdif.c
+++ b/sound/soc/samsung/spdif.c
@@ -17,7 +17,7 @@
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 
-#include <plat/audio.h>
+#include <linux/platform_data/asoc-s3c.h>
 #include <mach/dma.h>
 
 #include "dma.h"
-- 
1.7.10

