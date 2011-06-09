Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1FIXN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:13:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35280 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab1FIXNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u80v9ZkJfQ+0aC36irBHcYX2Z44JwvJunBZhtQGWzM+F7gTa3LatHxa3btn1fEFrzs
         w/0HVTq8DlJaHxr7KMYI583Wh7+rOlDd2+eeaXYfab6pA0W4mCeCN2e0gGr4+iHaSvyy
         vHrGf98RmSK+L3Q3nlSZitRCoBKcUQNAzMI80=
From: Ryan Mallon <rmallon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ryan Mallon <rmallon@gmail.com>, Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Paul Mundt <lethal@linux-sh.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
Subject: [PATCH trival/tree-wide] Change Ryan Mallon's email address across the kernel
Date: Fri, 10 Jun 2011 09:12:50 +1000
Message-Id: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I no longer work at Bluewater Systems. Update my email address accordingly.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Cc: Andre Renaud <andre@bluewatersys.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS                            |    2 +-
 arch/arm/mach-at91/board-snapper9260.c |    2 +-
 arch/arm/mach-ep93xx/dma-m2p.c         |    2 +-
 arch/arm/mach-ep93xx/gpio.c            |    2 +-
 arch/arm/mach-ep93xx/simone.c          |    4 ++--
 arch/arm/mach-ep93xx/snappercl15.c     |    4 ++--
 drivers/mtd/devices/sst25l.c           |    4 ++--
 drivers/power/ds2782_battery.c         |    4 ++--
 drivers/video/ep93xx-fb.c              |    2 +-
 sound/soc/ep93xx/ep93xx-i2s.c          |    4 ++--
 sound/soc/ep93xx/ep93xx-pcm.c          |    4 ++--
 sound/soc/ep93xx/snappercl15.c         |    4 ++--
 12 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29801f7..26aaf6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -683,7 +683,7 @@ T:	git git://git.infradead.org/users/cbou/linux-cns3xxx.git
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
-M:	Ryan Mallon <ryan@bluewatersys.com>
+M:	Ryan Mallon <rmallon@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ep93xx/
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 3eb0a11..e97d4a8 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2010 Bluewater System Ltd
  *
  * Author: Andre Renaud <andre@bluewatersys.com>
- * Author: Ryan Mallon  <ryan@bluewatersys.com>
+ * Author: Ryan Mallon  <rmallon@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/mach-ep93xx/dma-m2p.c b/arch/arm/mach-ep93xx/dma-m2p.c
index a696d35..965bb2a 100644
--- a/arch/arm/mach-ep93xx/dma-m2p.c
+++ b/arch/arm/mach-ep93xx/dma-m2p.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
  * Copyright (C) 2006 Applied Data Systems
  *
- * Copyright (C) 2009 Ryan Mallon <ryan@bluewatersys.com>
+ * Copyright (C) 2009 Ryan Mallon <rmallon@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/mach-ep93xx/gpio.c b/arch/arm/mach-ep93xx/gpio.c
index 415dce3..e479812 100644
--- a/arch/arm/mach-ep93xx/gpio.c
+++ b/arch/arm/mach-ep93xx/gpio.c
@@ -3,7 +3,7 @@
  *
  * Generic EP93xx GPIO handling
  *
- * Copyright (c) 2008 Ryan Mallon <ryan@bluewatersys.com>
+ * Copyright (c) 2008 Ryan Mallon <rmallon@gmail.com>
  *
  * Based on code originally from:
  *  linux/arch/arm/mach-ep93xx/core.c
diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
index d96dc1c..f94b7e9 100644
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/simone.c
  * Simplemachines Sim.One support.
  *
- * Copyright (C) 2010 Ryan Mallon <ryan@bluewatersys.com>
+ * Copyright (C) 2010 Ryan Mallon <rmallon@gmail.com>
  *
  * Based on the 2.6.24.7 support:
  *   Copyright (C) 2009 Simplemachines
@@ -65,7 +65,7 @@ static void __init simone_init_machine(void)
 }
 
 MACHINE_START(SIM_ONE, "Simplemachines Sim.One Board")
-/* Maintainer: Ryan Mallon <ryan@bluewatersys.com> */
+/* Maintainer: Ryan Mallon <rmallon@gmail.com> */
 	.boot_params	= EP93XX_SDCE0_PHYS_BASE + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
diff --git a/arch/arm/mach-ep93xx/snappercl15.c b/arch/arm/mach-ep93xx/snappercl15.c
index ac601fe..a06f349 100644
--- a/arch/arm/mach-ep93xx/snappercl15.c
+++ b/arch/arm/mach-ep93xx/snappercl15.c
@@ -3,7 +3,7 @@
  * Bluewater Systems Snapper CL15 system module
  *
  * Copyright (C) 2009 Bluewater Systems Ltd
- * Author: Ryan Mallon <ryan@bluewatersys.com>
+ * Author: Ryan Mallon <rmallon@gmail.com>
  *
  * NAND code adapted from driver by:
  *   Andre Renaud <andre@bluewatersys.com>
@@ -162,7 +162,7 @@ static void __init snappercl15_init_machine(void)
 }
 
 MACHINE_START(SNAPPER_CL15, "Bluewater Systems Snapper CL15")
-	/* Maintainer: Ryan Mallon <ryan@bluewatersys.com> */
+	/* Maintainer: Ryan Mallon  <rmallon@gmail.com> */
 	.boot_params	= EP93XX_SDCE0_PHYS_BASE + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index 1e2c430..73f6af0 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -5,7 +5,7 @@
  *
  * Copyright © 2009 Bluewater Systems Ltd
  * Author: Andre Renaud <andre@bluewatersys.com>
- * Author: Ryan Mallon <ryan@bluewatersys.com>
+ * Author: Ryan Mallon <rmallon@gmail.com>
  *
  * Based on m25p80.c
  *
@@ -498,5 +498,5 @@ module_exit(sst25l_exit);
 
 MODULE_DESCRIPTION("MTD SPI driver for SST25L Flash chips");
 MODULE_AUTHOR("Andre Renaud <andre@bluewatersys.com>, "
-	      "Ryan Mallon <ryan@bluewatersys.com>");
+	      "Ryan Mallon <rmallon@gmail.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 4d2dc4f..48f9c80 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2009 Bluewater Systems Ltd
  *
- * Author: Ryan Mallon <ryan@bluewatersys.com>
+ * Author: Ryan Mallon <rmallon@gmail.com>
  *
  * DS2786 added by Yulia Vilensky <vilensky@compulab.co.il>
  *
@@ -416,6 +416,6 @@ static void __exit ds278x_exit(void)
 }
 module_exit(ds278x_exit);
 
-MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
+MODULE_AUTHOR("Ryan Mallon <rmallon@gmail.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
index cbdb1bd..b326c2f 100644
--- a/drivers/video/ep93xx-fb.c
+++ b/drivers/video/ep93xx-fb.c
@@ -4,7 +4,7 @@
  * Framebuffer support for the EP93xx series.
  *
  * Copyright (C) 2007 Bluewater Systems Ltd
- * Author: Ryan Mallon <ryan@bluewatersys.com>
+ * Author: Ryan Mallon <rmallon@gmail.com>
  *
  * Copyright (c) 2009 H Hartley Sweeten <hsweeten@visionengravers.com>
  *
diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
index 042f4e9..56197d8 100644
--- a/sound/soc/ep93xx/ep93xx-i2s.c
+++ b/sound/soc/ep93xx/ep93xx-i2s.c
@@ -2,7 +2,7 @@
  * linux/sound/soc/ep93xx-i2s.c
  * EP93xx I2S driver
  *
- * Copyright (C) 2010 Ryan Mallon <ryan@bluewatersys.com>
+ * Copyright (C) 2010 Ryan Mallon <rmallon@gmail.com>
  *
  * Based on the original driver by:
  *   Copyright (C) 2007 Chase Douglas <chasedouglas@gmail>
@@ -477,6 +477,6 @@ module_init(ep93xx_i2s_init);
 module_exit(ep93xx_i2s_exit);
 
 MODULE_ALIAS("platform:ep93xx-i2s");
-MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
+MODULE_AUTHOR("Ryan Mallon <rmallon@gmail.com>");
 MODULE_DESCRIPTION("EP93XX I2S driver");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index a456e49..eba0dc8 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2006 Applied Data Systems
  *
  * Rewritten for the SoC audio subsystem (Based on PXA2xx code):
- *   Copyright (c) 2008 Ryan Mallon <ryan@bluewatersys.com>
+ *   Copyright (c) 2008 Ryan Mallon <rmallon@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -333,6 +333,6 @@ static void __exit ep93xx_soc_platform_exit(void)
 module_init(ep93xx_soc_platform_init);
 module_exit(ep93xx_soc_platform_exit);
 
-MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
+MODULE_AUTHOR("Ryan Mallon <rmallon@gmail.com>");
 MODULE_DESCRIPTION("EP93xx ALSA PCM interface");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/ep93xx/snappercl15.c b/sound/soc/ep93xx/snappercl15.c
index dfe1d7f..7608195 100644
--- a/sound/soc/ep93xx/snappercl15.c
+++ b/sound/soc/ep93xx/snappercl15.c
@@ -2,7 +2,7 @@
  * snappercl15.c -- SoC audio for Bluewater Systems Snapper CL15 module
  *
  * Copyright (C) 2008 Bluewater Systems Ltd
- * Author: Ryan Mallon <ryan@bluewatersys.com>
+ * Author: Ryan Mallon <rmallon@gmail.com>
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -140,7 +140,7 @@ static void __exit snappercl15_exit(void)
 module_init(snappercl15_init);
 module_exit(snappercl15_exit);
 
-MODULE_AUTHOR("Ryan Mallon <ryan@bluewatersys.com>");
+MODULE_AUTHOR("Ryan Mallon <rmallon@gmail.com>");
 MODULE_DESCRIPTION("ALSA SoC Snapper CL15");
 MODULE_LICENSE("GPL");
 
-- 
1.7.0.4

