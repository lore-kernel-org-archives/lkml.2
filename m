Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2IKNda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:33:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab2IKNd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:33:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, J Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 13/16] ARM: omap: move platform_data definitions
Date: Tue, 11 Sep 2012 15:02:36 +0200
Message-Id: <1347368559-31329-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368350-31212-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:5AlK6Imzom3LEaXHOj253iUc8ZJqWM/+PKYfZo4BK1y
 0hyLL7V4ojx18QOI5QHgVlO1NK30XuwszChpDsNv/wIMKvfnOM
 2DlQoDdLxCK1Elh4UrRQzjg2y2is20DNARSGo8RtR1xmIM20IB
 v1XyNNd5k+kUabKzW1gFaqrZBfs7LVKvPj4GIszJryeu2pz5Nc
 ruukdH5YWQ7NrSg7cb0tLB+rvlFI29C+Xxr4bI0nPGAyHA4Xpw
 aBz+VtcJX/g15v1uOe5QXlrX5UWKCx32Gjln+tc0UvgTS73SYP
 16gbG2rbe2lIyIZmj3/dGYMSFlo6metci7wQ9Deo7/Q7Ie6PuP
 l7mFiBRQ4dnCy1yKrr0+el6f7Zy21XF4oI7652rk7veIXGHjRR
 W4zeZKz27yKVQHwvWulfIytNE7gaEu0YdI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the omap include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: "Benoît Cousson" <b-cousson@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Jean Pihet <j-pihet@ti.com>
Cc: J Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org
---
 arch/arm/mach-omap1/board-ams-delta.c                              |    2 +-
 arch/arm/mach-omap1/board-fsample.c                                |    2 +-
 arch/arm/mach-omap1/board-h2.c                                     |    2 +-
 arch/arm/mach-omap1/board-h3.c                                     |    2 +-
 arch/arm/mach-omap1/board-htcherald.c                              |    2 +-
 arch/arm/mach-omap1/board-innovator.c                              |    2 +-
 arch/arm/mach-omap1/board-nokia770.c                               |    4 ++--
 arch/arm/mach-omap1/board-osk.c                                    |    2 +-
 arch/arm/mach-omap1/board-palmte.c                                 |    2 +-
 arch/arm/mach-omap1/board-palmtt.c                                 |    2 +-
 arch/arm/mach-omap1/board-palmz71.c                                |    2 +-
 arch/arm/mach-omap1/board-perseus2.c                               |    2 +-
 arch/arm/mach-omap1/board-sx1.c                                    |    2 +-
 arch/arm/mach-omap1/mcbsp.c                                        |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                                |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c                                 |    4 ++--
 arch/arm/mach-omap2/board-cm-t3517.c                               |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c                             |    4 ++--
 arch/arm/mach-omap2/board-flash.c                                  |    4 ++--
 arch/arm/mach-omap2/board-igep0020.c                               |    2 +-
 arch/arm/mach-omap2/board-ldp.c                                    |    2 +-
 arch/arm/mach-omap2/board-n8x0.c                                   |    4 ++--
 arch/arm/mach-omap2/board-omap3beagle.c                            |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c                               |    4 ++--
 arch/arm/mach-omap2/board-omap3pandora.c                           |    4 ++--
 arch/arm/mach-omap2/board-omap3stalker.c                           |    4 ++--
 arch/arm/mach-omap2/board-omap3touchbook.c                         |    4 ++--
 arch/arm/mach-omap2/board-overo.c                                  |    4 ++--
 arch/arm/mach-omap2/board-rm680.c                                  |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c                       |    4 ++--
 arch/arm/mach-omap2/board-rx51-video.c                             |    2 +-
 arch/arm/mach-omap2/board-rx51.c                                   |    2 +-
 arch/arm/mach-omap2/board-zoom-display.c                           |    2 +-
 arch/arm/mach-omap2/common-board-devices.c                         |    4 ++--
 arch/arm/mach-omap2/devices.c                                      |    2 +-
 arch/arm/mach-omap2/dsp.c                                          |    2 +-
 arch/arm/mach-omap2/gpmc-nand.c                                    |    2 +-
 arch/arm/mach-omap2/gpmc-onenand.c                                 |    2 +-
 arch/arm/mach-omap2/mcbsp.c                                        |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c                         |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c                         |    4 ++--
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c                 |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c                         |    4 ++--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c                         |    4 ++--
 arch/arm/mach-omap2/voltage.h                                      |    2 +-
 arch/arm/plat-omap/common.c                                        |    2 +-
 drivers/input/keyboard/omap-keypad.c                               |    2 +-
 drivers/mtd/nand/omap2.c                                           |    2 +-
 drivers/mtd/onenand/omap2.c                                        |    2 +-
 drivers/remoteproc/omap_remoteproc.c                               |    2 +-
 drivers/spi/spi-omap2-mcspi.c                                      |    2 +-
 drivers/staging/tidspbridge/core/dsp-clock.c                       |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c                      |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c                  |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.c                       |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c                   |    2 +-
 drivers/video/omap/lcd_mipid.c                                     |    2 +-
 .../plat/mcbsp.h => include/linux/platform_data/dsp-mcbsp.h        |    0
 .../include/plat/dsp.h => include/linux/platform_data/dsp-omap.h   |    0
 .../plat/keypad.h => include/linux/platform_data/keypad-omap.h     |    0
 .../plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h    |    0
 .../plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h    |    0
 .../onenand.h => include/linux/platform_data/mtd-onenand-omap2.h   |    0
 .../remoteproc.h => include/linux/platform_data/remoteproc-omap.h  |    0
 .../voltage.h => include/linux/platform_data/smartreflex-omap.h    |    0
 .../plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h  |    0
 include/linux/power/smartreflex.h                                  |    2 +-
 sound/soc/omap/am3517evm.c                                         |    2 +-
 sound/soc/omap/ams-delta.c                                         |    2 +-
 sound/soc/omap/igep0020.c                                          |    2 +-
 sound/soc/omap/mcbsp.c                                             |    2 +-
 sound/soc/omap/n810.c                                              |    2 +-
 sound/soc/omap/omap-mcbsp.c                                        |    2 +-
 sound/soc/omap/omap3beagle.c                                       |    2 +-
 sound/soc/omap/omap3evm.c                                          |    2 +-
 sound/soc/omap/omap3pandora.c                                      |    2 +-
 sound/soc/omap/osk5912.c                                           |    2 +-
 sound/soc/omap/overo.c                                             |    2 +-
 sound/soc/omap/rx51.c                                              |    2 +-
 sound/soc/omap/sdp3430.c                                           |    2 +-
 sound/soc/omap/zoom2.c                                             |    2 +-
 81 files changed, 87 insertions(+), 87 deletions(-)
 rename arch/arm/plat-omap/include/plat/mcbsp.h => include/linux/platform_data/dsp-mcbsp.h (100%)
 rename arch/arm/plat-omap/include/plat/dsp.h => include/linux/platform_data/dsp-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/keypad.h => include/linux/platform_data/keypad-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h (100%)
 rename arch/arm/plat-omap/include/plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h (100%)
 rename arch/arm/plat-omap/include/plat/onenand.h => include/linux/platform_data/mtd-onenand-omap2.h (100%)
 rename arch/arm/plat-omap/include/plat/remoteproc.h => include/linux/platform_data/remoteproc-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/voltage.h => include/linux/platform_data/smartreflex-omap.h (100%)
 rename arch/arm/plat-omap/include/plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h (100%)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index c534698..b9df845 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -35,7 +35,7 @@
 #include <asm/mach/map.h>
 
 #include <plat/board-ams-delta.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/mux.h>
 #include <plat/board.h>
 
diff --git a/arch/arm/mach-omap1/board-fsample.c b/arch/arm/mach-omap1/board-fsample.c
index 6872f3f..e8f772b 100644
--- a/arch/arm/mach-omap1/board-fsample.c
+++ b/arch/arm/mach-omap1/board-fsample.c
@@ -31,7 +31,7 @@
 #include <plat/mux.h>
 #include <plat/flash.h>
 #include <plat/fpga.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/board.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 44a4ab1..f59aa80 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -40,7 +40,7 @@
 #include <plat/dma.h>
 #include <plat/tc.h>
 #include <plat/irda.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/flash.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 86cb5a0..e20af3f 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -40,7 +40,7 @@
 
 #include <plat/mux.h>
 #include <plat/tc.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/dma.h>
 #include <plat/flash.h>
 
diff --git a/arch/arm/mach-omap1/board-htcherald.c b/arch/arm/mach-omap1/board-htcherald.c
index b3f6e94..20ec5a8 100644
--- a/arch/arm/mach-omap1/board-htcherald.c
+++ b/arch/arm/mach-omap1/board-htcherald.c
@@ -43,7 +43,7 @@
 
 #include <plat/omap7xx.h>
 #include <plat/board.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/mmc.h>
 
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index f21c296..083afa7 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -35,7 +35,7 @@
 #include <plat/flash.h>
 #include <plat/fpga.h>
 #include <plat/tc.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/mmc.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 2c0ca8f..657bf7c 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -27,8 +27,8 @@
 
 #include <plat/mux.h>
 #include <plat/board.h>
-#include <plat/keypad.h>
-#include <plat/lcd_mipid.h>
+#include <linux/platform_data/keypad-omap.h>
+#include <linux/platform_data/lcd-mipid.h>
 #include <plat/mmc.h>
 #include <plat/clock.h>
 
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 8784705..1c42a96 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -302,7 +302,7 @@ static struct omap_lcd_config osk_lcd_config __initdata = {
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 
 static struct at24_platform_data at24c04 = {
 	.byte_len	= SZ_4K / 8,
diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 26bcb9d..ed1cd69 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -39,7 +39,7 @@
 #include <plat/dma.h>
 #include <plat/board.h>
 #include <plat/irda.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 
 #include <mach/hardware.h>
 #include <mach/usb.h>
diff --git a/arch/arm/mach-omap1/board-palmtt.c b/arch/arm/mach-omap1/board-palmtt.c
index 4d09944..f4b9458 100644
--- a/arch/arm/mach-omap1/board-palmtt.c
+++ b/arch/arm/mach-omap1/board-palmtt.c
@@ -39,7 +39,7 @@
 #include <plat/tc.h>
 #include <plat/board.h>
 #include <plat/irda.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 
 #include <mach/hardware.h>
 #include <mach/usb.h>
diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 3559803..fb08004 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -41,7 +41,7 @@
 #include <plat/tc.h>
 #include <plat/board.h>
 #include <plat/irda.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 
 #include <mach/hardware.h>
 #include <mach/usb.h>
diff --git a/arch/arm/mach-omap1/board-perseus2.c b/arch/arm/mach-omap1/board-perseus2.c
index 703d55e..f5e2c00 100644
--- a/arch/arm/mach-omap1/board-perseus2.c
+++ b/arch/arm/mach-omap1/board-perseus2.c
@@ -31,7 +31,7 @@
 #include <plat/mux.h>
 #include <plat/fpga.h>
 #include <plat/flash.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/board.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 8c665bd..51325a9 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -39,7 +39,7 @@
 #include <plat/irda.h>
 #include <plat/tc.h>
 #include <plat/board.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/board-sx1.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-omap1/mcbsp.c b/arch/arm/mach-omap1/mcbsp.c
index adf0097..b1a5b47 100644
--- a/arch/arm/mach-omap1/mcbsp.c
+++ b/arch/arm/mach-omap1/mcbsp.c
@@ -22,7 +22,7 @@
 #include <plat/dma.h>
 #include <plat/mux.h>
 #include <plat/cpu.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index a98c688..76d03d3 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -30,7 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/board.h>
 #include <plat/usb.h>
 #include "common.h"
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index 97d7190..3f844f4 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -39,13 +39,13 @@
 
 #include <plat/board.h>
 #include "common.h"
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/gpmc.h>
 #include <plat/usb.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-generic-dpi.h>
 #include <video/omap-panel-tfp410.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-omap2/board-cm-t3517.c b/arch/arm/mach-omap2/board-cm-t3517.c
index a33ad46..e1811ba 100644
--- a/arch/arm/mach-omap2/board-cm-t3517.c
+++ b/arch/arm/mach-omap2/board-cm-t3517.c
@@ -41,7 +41,7 @@
 #include <plat/board.h>
 #include "common.h"
 #include <plat/usb.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/gpmc.h>
 
 #include <mach/am35xx.h>
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 6567c1c..e4456c2 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -43,13 +43,13 @@
 #include <plat/board.h>
 #include "common.h"
 #include <plat/gpmc.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/usb.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-generic-dpi.h>
 #include <video/omap-panel-tfp410.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
 #include <linux/dm9000.h>
diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index 53c39d2..a1ef5f0 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -19,8 +19,8 @@
 #include <plat/irqs.h>
 
 #include <plat/gpmc.h>
-#include <plat/nand.h>
-#include <plat/onenand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 #include <plat/tc.h>
 
 #include "board-flash.h"
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index 7491529..4e5de5a 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -35,7 +35,7 @@
 #include <plat/usb.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-tfp410.h>
-#include <plat/onenand.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 
 #include "mux.h"
 #include "hsmmc.h"
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index ef9e829..b5ba08b 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -34,7 +34,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/board.h>
 #include "common.h"
 #include <plat/gpmc.h>
diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 677357f..a60c575 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -29,8 +29,8 @@
 #include "common.h"
 #include <plat/menelaus.h>
 #include <mach/irqs.h>
-#include <plat/mcspi.h>
-#include <plat/onenand.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 #include <plat/mmc.h>
 #include <plat/serial.h>
 
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 6202fc7..b483d49 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -44,7 +44,7 @@
 #include <video/omapdss.h>
 #include <video/omap-panel-tfp410.h>
 #include <plat/gpmc.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/usb.h>
 #include <plat/omap_device.h>
 
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index ef230a0..89db942 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -47,9 +47,9 @@
 
 #include <plat/board.h>
 #include <plat/usb.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include "common.h"
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-tfp410.h>
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 57aebee..44ca395 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -43,10 +43,10 @@
 #include <plat/board.h>
 #include "common.h"
 #include <mach/hardware.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/usb.h>
 #include <video/omapdss.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 
 #include "mux.h"
 #include "sdram-micron-mt46h32m32lf-6.h"
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index b318f56..e967363 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -38,13 +38,13 @@
 #include <plat/board.h>
 #include "common.h"
 #include <plat/gpmc.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/usb.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-generic-dpi.h>
 #include <video/omap-panel-tfp410.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 485d14d..7b4a604 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -29,7 +29,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mmc/host.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/spi/spi.h>
 
 #include <linux/spi/ads7846.h>
@@ -47,7 +47,7 @@
 #include <plat/board.h>
 #include "common.h"
 #include <plat/gpmc.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/usb.h>
 
 #include "mux.h"
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 779734d..db964e6 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -49,8 +49,8 @@
 #include <video/omap-panel-tfp410.h>
 #include <plat/gpmc.h>
 #include <mach/hardware.h>
-#include <plat/nand.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/mux.h>
 #include <plat/usb.h>
 
diff --git a/arch/arm/mach-omap2/board-rm680.c b/arch/arm/mach-omap2/board-rm680.c
index 0ad1bb3b..bbfbe56 100644
--- a/arch/arm/mach-omap2/board-rm680.c
+++ b/arch/arm/mach-omap2/board-rm680.c
@@ -26,7 +26,7 @@
 #include <plat/usb.h>
 #include <plat/gpmc.h>
 #include "common.h"
-#include <plat/onenand.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 
 #include "mux.h"
 #include "hsmmc.h"
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index df2534d..9bfbb61 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -27,12 +27,12 @@
 #include <linux/power/isp1704_charger.h>
 #include <asm/system_info.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/board.h>
 #include "common.h"
 #include <plat/dma.h>
 #include <plat/gpmc.h>
-#include <plat/onenand.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 #include <plat/gpmc-smc91x.h>
 
 #include <mach/board-rx51.h>
diff --git a/arch/arm/mach-omap2/board-rx51-video.c b/arch/arm/mach-omap2/board-rx51-video.c
index 2c1289b..7ef0994 100644
--- a/arch/arm/mach-omap2/board-rx51-video.c
+++ b/arch/arm/mach-omap2/board-rx51-video.c
@@ -17,7 +17,7 @@
 #include <asm/mach-types.h>
 #include <video/omapdss.h>
 #include <plat/vram.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 
 #include <mach/board-rx51.h>
 
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 345dd93..779c67e 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -23,7 +23,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/board.h>
 #include "common.h"
 #include <plat/dma.h>
diff --git a/arch/arm/mach-omap2/board-zoom-display.c b/arch/arm/mach-omap2/board-zoom-display.c
index 28187f1..660a2932 100644
--- a/arch/arm/mach-omap2/board-zoom-display.c
+++ b/arch/arm/mach-omap2/board-zoom-display.c
@@ -14,7 +14,7 @@
 #include <linux/gpio.h>
 #include <linux/i2c/twl.h>
 #include <linux/spi/spi.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <video/omapdss.h>
 #include <mach/board-zoom.h>
 
diff --git a/arch/arm/mach-omap2/common-board-devices.c b/arch/arm/mach-omap2/common-board-devices.c
index 1473474..eedb6d0 100644
--- a/arch/arm/mach-omap2/common-board-devices.c
+++ b/arch/arm/mach-omap2/common-board-devices.c
@@ -24,8 +24,8 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
-#include <plat/mcspi.h>
-#include <plat/nand.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 
 #include "common-board-devices.h"
 
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index c00c689..bd1b907 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -385,7 +385,7 @@ static inline void omap_init_hdmi_audio(void) {}
 
 #if defined(CONFIG_SPI_OMAP24XX) || defined(CONFIG_SPI_OMAP24XX_MODULE)
 
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 
 static int __init omap_mcspi_init(struct omap_hwmod *oh, void *unused)
 {
diff --git a/arch/arm/mach-omap2/dsp.c b/arch/arm/mach-omap2/dsp.c
index a636ebc..9838810 100644
--- a/arch/arm/mach-omap2/dsp.c
+++ b/arch/arm/mach-omap2/dsp.c
@@ -30,7 +30,7 @@
 #include <plat/omap-pm.h>
 #endif
 
-#include <plat/dsp.h>
+#include <linux/platform_data/dsp-omap.h>
 
 static struct platform_device *omap_dsp_pdev;
 
diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 386dec8..af6f177 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -17,7 +17,7 @@
 #include <asm/mach/flash.h>
 
 #include <plat/cpu.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 #include <plat/board.h>
 #include <plat/gpmc.h>
 
diff --git a/arch/arm/mach-omap2/gpmc-onenand.c b/arch/arm/mach-omap2/gpmc-onenand.c
index a0fa9bb..d27b02d 100644
--- a/arch/arm/mach-omap2/gpmc-onenand.c
+++ b/arch/arm/mach-omap2/gpmc-onenand.c
@@ -19,7 +19,7 @@
 #include <asm/mach/flash.h>
 
 #include <plat/cpu.h>
-#include <plat/onenand.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 #include <plat/board.h>
 #include <plat/gpmc.h>
 
diff --git a/arch/arm/mach-omap2/mcbsp.c b/arch/arm/mach-omap2/mcbsp.c
index 577cb77..4ee08c6 100644
--- a/arch/arm/mach-omap2/mcbsp.c
+++ b/arch/arm/mach-omap2/mcbsp.c
@@ -21,7 +21,7 @@
 #include <mach/irqs.h>
 #include <plat/dma.h>
 #include <plat/cpu.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 #include <plat/omap_device.h>
 #include <linux/pm_runtime.h>
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_2420_data.c b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
index 50cfab6..558c300 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2420_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2420_data.c
@@ -19,7 +19,7 @@
 #include <plat/serial.h>
 #include <plat/i2c.h>
 #include <plat/gpio.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/dmtimer.h>
 #include <plat/l3_2xxx.h>
 #include <plat/l4_2xxx.h>
diff --git a/arch/arm/mach-omap2/omap_hwmod_2430_data.c b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
index 58b5bc1..d662766 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2430_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2430_data.c
@@ -19,8 +19,8 @@
 #include <plat/serial.h>
 #include <plat/i2c.h>
 #include <plat/gpio.h>
-#include <plat/mcbsp.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/dsp-mcbsp.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/dmtimer.h>
 #include <plat/mmc.h>
 #include <plat/l3_2xxx.h>
diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
index afad69c..161ae0a 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
@@ -13,7 +13,7 @@
 #include <plat/gpio.h>
 #include <plat/dma.h>
 #include <plat/dmtimer.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index c9e3820..656bb7f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -26,8 +26,8 @@
 #include <plat/i2c.h>
 #include <plat/gpio.h>
 #include <plat/mmc.h>
-#include <plat/mcbsp.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/dsp-mcbsp.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 #include <plat/dmtimer.h>
 
 #include "omap_hwmod_common_data.h"
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 242aee4..3a06e7d 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -26,8 +26,8 @@
 #include <plat/i2c.h>
 #include <plat/gpio.h>
 #include <plat/dma.h>
-#include <plat/mcspi.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 #include <plat/mmc.h>
 #include <plat/dmtimer.h>
 #include <plat/common.h>
diff --git a/arch/arm/mach-omap2/voltage.h b/arch/arm/mach-omap2/voltage.h
index 0ac2caf..7abf1c0 100644
--- a/arch/arm/mach-omap2/voltage.h
+++ b/arch/arm/mach-omap2/voltage.h
@@ -16,7 +16,7 @@
 
 #include <linux/err.h>
 
-#include <plat/voltage.h>
+#include <linux/platform_data/smartreflex-omap.h>
 
 #include "vc.h"
 #include "vp.h"
diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index 89a3723..f18b73b 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -19,7 +19,7 @@
 #include <plat/common.h>
 #include <plat/board.h>
 #include <plat/vram.h>
-#include <plat/dsp.h>
+#include <linux/platform_data/dsp-omap.h>
 #include <plat/dma.h>
 
 #include <plat/omap-secure.h>
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index a0222db..8aaa326 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -36,7 +36,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <asm/gpio.h>
-#include <plat/keypad.h>
+#include <linux/platform_data/keypad-omap.h>
 #include <plat/menelaus.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index ac4fd75..5efaac6 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -29,7 +29,7 @@
 
 #include <plat/dma.h>
 #include <plat/gpmc.h>
-#include <plat/nand.h>
+#include <linux/platform_data/mtd-nand-omap2.h>
 
 #define	DRIVER_NAME	"omap2-nand"
 #define	OMAP_NAND_TIMEOUT_MS	5000
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index 398a827..f9017b3 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -39,7 +39,7 @@
 
 #include <asm/mach/flash.h>
 #include <plat/gpmc.h>
-#include <plat/onenand.h>
+#include <linux/platform_data/mtd-onenand-omap2.h>
 #include <asm/gpio.h>
 
 #include <plat/dma.h>
diff --git a/drivers/remoteproc/omap_remoteproc.c b/drivers/remoteproc/omap_remoteproc.c
index a1f7ac1..b54504e 100644
--- a/drivers/remoteproc/omap_remoteproc.c
+++ b/drivers/remoteproc/omap_remoteproc.c
@@ -29,7 +29,7 @@
 #include <linux/remoteproc.h>
 
 #include <plat/mailbox.h>
-#include <plat/remoteproc.h>
+#include <linux/platform_data/remoteproc-omap.h>
 
 #include "omap_remoteproc.h"
 #include "remoteproc_internal.h"
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index b2fb141..b9b7ad0 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -42,7 +42,7 @@
 #include <linux/spi/spi.h>
 
 #include <plat/clock.h>
-#include <plat/mcspi.h>
+#include <linux/platform_data/spi-omap2-mcspi.h>
 
 #define OMAP2_MCSPI_MAX_FREQ		48000000
 #define SPI_AUTOSUSPEND_TIMEOUT		2000
diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index c7df34e..346fa559 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -21,7 +21,7 @@
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 #include <plat/dmtimer.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index f9609ce..7bf55c4 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -16,7 +16,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#include <plat/dsp.h>
+#include <linux/platform_data/dsp-omap.h>
 
 #include <linux/types.h>
 /*  ----------------------------------- Host OS */
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index 16a4aaf..55675b7 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -19,7 +19,7 @@
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
 
-#include <plat/dsp.h>
+#include <linux/platform_data/dsp-omap.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index 7fda10c..f53ed98 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -16,7 +16,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#include <plat/dsp.h>
+#include <linux/platform_data/dsp-omap.h>
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 3cac014..49c9b66 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -16,7 +16,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#include <plat/dsp.h>
+#include <linux/platform_data/dsp-omap.h>
 
 #include <linux/types.h>
 #include <linux/platform_device.h>
diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/omap/lcd_mipid.c
index e3880c4..b739600 100644
--- a/drivers/video/omap/lcd_mipid.c
+++ b/drivers/video/omap/lcd_mipid.c
@@ -25,7 +25,7 @@
 #include <linux/spi/spi.h>
 #include <linux/module.h>
 
-#include <plat/lcd_mipid.h>
+#include <linux/platform_data/lcd-mipid.h>
 
 #include "omapfb.h"
 
diff --git a/arch/arm/plat-omap/include/plat/mcbsp.h b/include/linux/platform_data/dsp-mcbsp.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/mcbsp.h
rename to include/linux/platform_data/dsp-mcbsp.h
diff --git a/arch/arm/plat-omap/include/plat/dsp.h b/include/linux/platform_data/dsp-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/dsp.h
rename to include/linux/platform_data/dsp-omap.h
diff --git a/arch/arm/plat-omap/include/plat/keypad.h b/include/linux/platform_data/keypad-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/keypad.h
rename to include/linux/platform_data/keypad-omap.h
diff --git a/arch/arm/plat-omap/include/plat/lcd_mipid.h b/include/linux/platform_data/lcd-mipid.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/lcd_mipid.h
rename to include/linux/platform_data/lcd-mipid.h
diff --git a/arch/arm/plat-omap/include/plat/nand.h b/include/linux/platform_data/mtd-nand-omap2.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/nand.h
rename to include/linux/platform_data/mtd-nand-omap2.h
diff --git a/arch/arm/plat-omap/include/plat/onenand.h b/include/linux/platform_data/mtd-onenand-omap2.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/onenand.h
rename to include/linux/platform_data/mtd-onenand-omap2.h
diff --git a/arch/arm/plat-omap/include/plat/remoteproc.h b/include/linux/platform_data/remoteproc-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/remoteproc.h
rename to include/linux/platform_data/remoteproc-omap.h
diff --git a/arch/arm/plat-omap/include/plat/voltage.h b/include/linux/platform_data/smartreflex-omap.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/voltage.h
rename to include/linux/platform_data/smartreflex-omap.h
diff --git a/arch/arm/plat-omap/include/plat/mcspi.h b/include/linux/platform_data/spi-omap2-mcspi.h
similarity index 100%
rename from arch/arm/plat-omap/include/plat/mcspi.h
rename to include/linux/platform_data/spi-omap2-mcspi.h
diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
index 3101e62..e376f94 100644
--- a/include/linux/power/smartreflex.h
+++ b/include/linux/power/smartreflex.h
@@ -23,7 +23,7 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
-#include <plat/voltage.h>
+#include <linux/platform_data/smartreflex-omap.h>
 
 /*
  * Different Smartreflex IPs version. The v1 is the 65nm version used in
diff --git a/sound/soc/omap/am3517evm.c b/sound/soc/omap/am3517evm.c
index 009533a..e815c4a 100644
--- a/sound/soc/omap/am3517evm.c
+++ b/sound/soc/omap/am3517evm.c
@@ -27,7 +27,7 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 7d4fa8e..293e61a 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -33,7 +33,7 @@
 #include <asm/mach-types.h>
 
 #include <plat/board-ams-delta.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/igep0020.c b/sound/soc/omap/igep0020.c
index e835781..e6393b0 100644
--- a/sound/soc/omap/igep0020.c
+++ b/sound/soc/omap/igep0020.c
@@ -29,7 +29,7 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/mcbsp.c b/sound/soc/omap/mcbsp.c
index d33c48b..4bc029d 100644
--- a/sound/soc/omap/mcbsp.c
+++ b/sound/soc/omap/mcbsp.c
@@ -25,7 +25,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "mcbsp.h"
 
diff --git a/sound/soc/omap/n810.c b/sound/soc/omap/n810.c
index abac4b6..232357b 100644
--- a/sound/soc/omap/n810.c
+++ b/sound/soc/omap/n810.c
@@ -32,7 +32,7 @@
 #include <mach/hardware.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index acdd3ef..deeda47 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -33,7 +33,7 @@
 #include <sound/soc.h>
 
 #include <plat/dma.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 #include "mcbsp.h"
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/omap3beagle.c b/sound/soc/omap/omap3beagle.c
index 2830dfd..89d115c 100644
--- a/sound/soc/omap/omap3beagle.c
+++ b/sound/soc/omap/omap3beagle.c
@@ -29,7 +29,7 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/omap3evm.c b/sound/soc/omap/omap3evm.c
index 3d468c9..50d0b70 100644
--- a/sound/soc/omap/omap3evm.c
+++ b/sound/soc/omap/omap3evm.c
@@ -27,7 +27,7 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/omap3pandora.c b/sound/soc/omap/omap3pandora.c
index 4c3a097..68c4e16 100644
--- a/sound/soc/omap/omap3pandora.c
+++ b/sound/soc/omap/omap3pandora.c
@@ -31,7 +31,7 @@
 #include <sound/soc.h>
 
 #include <asm/mach-types.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/osk5912.c b/sound/soc/omap/osk5912.c
index b1a9d64..27b9a05 100644
--- a/sound/soc/omap/osk5912.c
+++ b/sound/soc/omap/osk5912.c
@@ -31,7 +31,7 @@
 #include <mach/hardware.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/overo.c b/sound/soc/omap/overo.c
index 6ac3e0c..080c984 100644
--- a/sound/soc/omap/overo.c
+++ b/sound/soc/omap/overo.c
@@ -29,7 +29,7 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 #include "omap-mcbsp.h"
 #include "omap-pcm.h"
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 2712dd2..5b21bc4 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -31,7 +31,7 @@
 #include <sound/jack.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 #include "../codecs/tpa6130a2.h"
 
 #include <asm/mach-types.h>
diff --git a/sound/soc/omap/sdp3430.c b/sound/soc/omap/sdp3430.c
index 0e28322..33f4ac2 100644
--- a/sound/soc/omap/sdp3430.c
+++ b/sound/soc/omap/sdp3430.c
@@ -33,7 +33,7 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/gpio.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 /* Register descriptions for twl4030 codec part */
 #include <linux/mfd/twl4030-audio.h>
diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
index 920e0d9..558364f 100644
--- a/sound/soc/omap/zoom2.c
+++ b/sound/soc/omap/zoom2.c
@@ -29,7 +29,7 @@
 #include <mach/hardware.h>
 #include <mach/gpio.h>
 #include <mach/board-zoom.h>
-#include <plat/mcbsp.h>
+#include <linux/platform_data/dsp-mcbsp.h>
 
 /* Register descriptions for twl4030 codec part */
 #include <linux/mfd/twl4030-audio.h>
-- 
1.7.10

