Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1DJNmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 09:42:15 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:51523 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab1DJNmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 09:42:13 -0400
Date: Sun, 10 Apr 2011 15:45:04 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove non-MAINTAINERS email address references for Lennert
 Buytenhek.
Message-ID: <20110410134504.GG22881@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of all (obsolete as well as still valid) email addresses
for Lennert Buytenhek across the tree -- MAINTAINERS should be used for
obtaining a valid email address.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>

diff --git a/arch/arm/common/uengine.c b/arch/arm/common/uengine.c
index bef408f..a3b9fc8 100644
--- a/arch/arm/common/uengine.c
+++ b/arch/arm/common/uengine.c
@@ -2,7 +2,7 @@
  * Generic library functions for the microengines found on the Intel
  * IXP2000 series of network processors.
  *
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/arch/arm/include/asm/hardware/uengine.h b/arch/arm/include/asm/hardware/uengine.h
index b442d65..400d790 100644
--- a/arch/arm/include/asm/hardware/uengine.h
+++ b/arch/arm/include/asm/hardware/uengine.h
@@ -2,7 +2,7 @@
  * Generic library functions for the microengines found on the Intel
  * IXP2000 series of network processors.
  *
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/arch/arm/kernel/crunch-bits.S b/arch/arm/kernel/crunch-bits.S
index 0ec9bb4..ae2836f 100644
--- a/arch/arm/kernel/crunch-bits.S
+++ b/arch/arm/kernel/crunch-bits.S
@@ -2,7 +2,7 @@
  * arch/arm/kernel/crunch-bits.S
  * Cirrus MaverickCrunch context switching and handling
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * Shamelessly stolen from the iWMMXt code by Nicolas Pitre, which is
  * Copyright (c) 2003-2004, MontaVista Software, Inc.
diff --git a/arch/arm/kernel/crunch.c b/arch/arm/kernel/crunch.c
index 25ef223..1ff5471 100644
--- a/arch/arm/kernel/crunch.c
+++ b/arch/arm/kernel/crunch.c
@@ -2,7 +2,7 @@
  * arch/arm/kernel/crunch.c
  * Cirrus MaverickCrunch context switching and handling
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 8a3fc84..bcbfe73 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -91,7 +91,7 @@ static void __init onearm_board_init(void)
 }
 
 MACHINE_START(ONEARM, "Ajeco 1ARM single board computer")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= AT91_SDRAM_BASE + 0x100,
 	.timer		= &at91rm9200_timer,
 	.map_io		= onearm_map_io,
diff --git a/arch/arm/mach-ep93xx/adssphere.c b/arch/arm/mach-ep93xx/adssphere.c
index 61b98ce..5d77436 100644
--- a/arch/arm/mach-ep93xx/adssphere.c
+++ b/arch/arm/mach-ep93xx/adssphere.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/adssphere.c
  * ADS Sphere support.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -32,7 +32,7 @@ static void __init adssphere_init_machine(void)
 }
 
 MACHINE_START(ADSSPHERE, "ADS Sphere board")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= EP93XX_SDCE3_PHYS_BASE_SYNC + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index ca4de71..a08a3bf 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/clock.c
  * Clock control for Cirrus EP93xx chips.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 8207954..0611803 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/core.c
  * Core routines for Cirrus EP93xx chips.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  * Copyright (C) 2007 Herbert Valerio Riedel <hvr@gnu.org>
  *
  * Thanks go to Michael Burian and Ray Lehtiniemi for their key
diff --git a/arch/arm/mach-ep93xx/dma-m2p.c b/arch/arm/mach-ep93xx/dma-m2p.c
index a696d35..4c4fb3b 100644
--- a/arch/arm/mach-ep93xx/dma-m2p.c
+++ b/arch/arm/mach-ep93xx/dma-m2p.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/dma-m2p.c
  * M2P DMA handling for Cirrus EP93xx chips.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  * Copyright (C) 2006 Applied Data Systems
  *
  * Copyright (C) 2009 Ryan Mallon <ryan@bluewatersys.com>
diff --git a/arch/arm/mach-ep93xx/edb93xx.c b/arch/arm/mach-ep93xx/edb93xx.c
index 9969bb1..5ef26d2 100644
--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -9,7 +9,7 @@
  * Copyright (C) 2006 George Kashperko <george@chas.com.ua>
  *
  * EDB9302A, EDB9315, EDB9315A
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * EDB9307
  * Copyright (C) 2007 Herbert Valerio Riedel <hvr@gnu.org>
@@ -261,7 +261,7 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_EDB9302A
 MACHINE_START(EDB9302A, "Cirrus Logic EDB9302A Evaluation Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= EP93XX_SDCE0_PHYS_BASE + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
@@ -305,7 +305,7 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_EDB9315
 MACHINE_START(EDB9315, "Cirrus Logic EDB9315 Evaluation Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= EP93XX_SDCE3_PHYS_BASE_SYNC + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
@@ -316,7 +316,7 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_EDB9315A
 MACHINE_START(EDB9315A, "Cirrus Logic EDB9315A Evaluation Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= EP93XX_SDCE0_PHYS_BASE + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
diff --git a/arch/arm/mach-ep93xx/gesbc9312.c b/arch/arm/mach-ep93xx/gesbc9312.c
index 9bd3152..64f1bb6 100644
--- a/arch/arm/mach-ep93xx/gesbc9312.c
+++ b/arch/arm/mach-ep93xx/gesbc9312.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/gesbc9312.c
  * Glomation GESBC-9312-sx support.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -32,7 +32,7 @@ static void __init gesbc9312_init_machine(void)
 }
 
 MACHINE_START(GESBC9312, "Glomation GESBC-9312-sx")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= EP93XX_SDCE3_PHYS_BASE_SYNC + 0x100,
 	.map_io		= ep93xx_map_io,
 	.init_irq	= ep93xx_init_irq,
diff --git a/arch/arm/mach-ep93xx/include/mach/debug-macro.S b/arch/arm/mach-ep93xx/include/mach/debug-macro.S
index b25bc907..4fc9c7b 100644
--- a/arch/arm/mach-ep93xx/include/mach/debug-macro.S
+++ b/arch/arm/mach-ep93xx/include/mach/debug-macro.S
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/include/mach/debug-macro.S
  * Debugging macro include header
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/mach-ep93xx/include/mach/entry-macro.S b/arch/arm/mach-ep93xx/include/mach/entry-macro.S
index 96b85e2..ae25cb3 100644
--- a/arch/arm/mach-ep93xx/include/mach/entry-macro.S
+++ b/arch/arm/mach-ep93xx/include/mach/entry-macro.S
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/include/mach/entry-macro.S
  * IRQ demultiplexing for EP93xx
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/mach-ep93xx/include/mach/uncompress.h b/arch/arm/mach-ep93xx/include/mach/uncompress.h
index 16026c2..84fc0ea 100644
--- a/arch/arm/mach-ep93xx/include/mach/uncompress.h
+++ b/arch/arm/mach-ep93xx/include/mach/uncompress.h
@@ -1,7 +1,7 @@
 /*
  * arch/arm/mach-ep93xx/include/mach/uncompress.h
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index c2d2cf4..3db2f86 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -2,7 +2,7 @@
  * arch/arm/mach-ep93xx/ts72xx.c
  * Technologic Systems TS72xx SBC support.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -256,7 +256,7 @@ static void __init ts72xx_init_machine(void)
 }
 
 MACHINE_START(TS72XX, "Technologic Systems TS-72xx SBC")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= EP93XX_SDCE3_PHYS_BASE_SYNC + 0x100,
 	.map_io		= ts72xx_map_io,
 	.init_irq	= ep93xx_init_irq,
diff --git a/arch/arm/mach-iop32x/glantank.c b/arch/arm/mach-iop32x/glantank.c
index c6b6f9c..0541d00 100644
--- a/arch/arm/mach-iop32x/glantank.c
+++ b/arch/arm/mach-iop32x/glantank.c
@@ -4,7 +4,7 @@
  * Board support code for the GLAN Tank.
  *
  * Copyright (C) 2006, 2007 Martin Michlmayr <tbm@cyrius.com>
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -206,7 +206,7 @@ static void __init glantank_init_machine(void)
 }
 
 MACHINE_START(GLANTANK, "GLAN Tank")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0xa0000100,
 	.map_io		= glantank_map_io,
 	.init_irq	= iop32x_init_irq,
diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index 626aa37..827dcff 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -326,7 +326,7 @@ static void __init n2100_init_machine(void)
 }
 
 MACHINE_START(N2100, "Thecus N2100")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0xa0000100,
 	.map_io		= n2100_map_io,
 	.init_irq	= iop32x_init_irq,
diff --git a/arch/arm/mach-ixp2000/enp2611.c b/arch/arm/mach-ixp2000/enp2611.c
index 88663ab..978b6dd 100644
--- a/arch/arm/mach-ixp2000/enp2611.c
+++ b/arch/arm/mach-ixp2000/enp2611.c
@@ -252,7 +252,7 @@ static void __init enp2611_init_machine(void)
 
 
 MACHINE_START(ENP2611, "Radisys ENP-2611 PCI network processor board")
-	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.map_io		= enp2611_map_io,
 	.init_irq	= ixp2000_init_irq,
diff --git a/arch/arm/mach-ixp23xx/espresso.c b/arch/arm/mach-ixp23xx/espresso.c
index e25e5fe..e3a2b7e 100644
--- a/arch/arm/mach-ixp23xx/espresso.c
+++ b/arch/arm/mach-ixp23xx/espresso.c
@@ -3,7 +3,7 @@
  *
  * Double Espresso-specific routines
  *
- * Author: Lennert Buytenhek <buytenh@wantstofly.org>
+ * Author: Lennert Buytenhek
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c b/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
index 00cca22..23d1d0b 100644
--- a/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
+++ b/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
@@ -162,7 +162,7 @@ static int __init mv88f6281gtw_ge_pci_init(void)
 subsys_initcall(mv88f6281gtw_ge_pci_init);
 
 MACHINE_START(MV88F6281GTW_GE, "Marvell 88F6281 GTW GE Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.init_machine	= mv88f6281gtw_ge_init,
 	.map_io		= kirkwood_map_io,
diff --git a/arch/arm/mach-mv78xx0/db78x00-bp-setup.c b/arch/arm/mach-mv78xx0/db78x00-bp-setup.c
index df5aebe..8938b72 100644
--- a/arch/arm/mach-mv78xx0/db78x00-bp-setup.c
+++ b/arch/arm/mach-mv78xx0/db78x00-bp-setup.c
@@ -92,7 +92,7 @@ static int __init db78x00_pci_init(void)
 subsys_initcall(db78x00_pci_init);
 
 MACHINE_START(DB78X00_BP, "Marvell DB-78x00-BP Development Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.init_machine	= db78x00_init,
 	.map_io		= mv78xx0_map_io,
diff --git a/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c b/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c
index d927f14..1099027 100644
--- a/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c
+++ b/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c
@@ -77,7 +77,7 @@ static int __init rd78x00_pci_init(void)
 subsys_initcall(rd78x00_pci_init);
 
 MACHINE_START(RD78X00_MASA, "Marvell RD-78x00-MASA Development Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.init_machine	= rd78x00_masa_init,
 	.map_io		= mv78xx0_map_io,
diff --git a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
index c1f79fa..ba9e7e9 100644
--- a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
@@ -180,7 +180,7 @@ static int __init rd88f5181l_ge_pci_init(void)
 subsys_initcall(rd88f5181l_ge_pci_init);
 
 MACHINE_START(RD88F5181L_GE, "Marvell Orion-VoIP GE Reference Design")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.init_machine	= rd88f5181l_ge_init,
 	.map_io		= orion5x_map_io,
diff --git a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
index b080c69..9c4a898 100644
--- a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
@@ -122,7 +122,7 @@ static int __init rd88f6183ap_ge_pci_init(void)
 subsys_initcall(rd88f6183ap_ge_pci_init);
 
 MACHINE_START(RD88F6183AP_GE, "Marvell Orion-1-90 AP GE Reference Design")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.init_machine	= rd88f6183ap_ge_init,
 	.map_io		= orion5x_map_io,
diff --git a/arch/arm/mach-orion5x/tsx09-common.c b/arch/arm/mach-orion5x/tsx09-common.c
index c9abb8f..a751264 100644
--- a/arch/arm/mach-orion5x/tsx09-common.c
+++ b/arch/arm/mach-orion5x/tsx09-common.c
@@ -1,7 +1,7 @@
 /*
  * QNAP TS-x09 Boards common functions
  *
- * Maintainers: Lennert Buytenhek <buytenh@marvell.com>
+ * Maintainers: Lennert Buytenhek
  *		Byron Bradley <byron.bbradley@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/arch/arm/mach-orion5x/wrt350n-v2-setup.c b/arch/arm/mach-orion5x/wrt350n-v2-setup.c
index fab79d0..f706729 100644
--- a/arch/arm/mach-orion5x/wrt350n-v2-setup.c
+++ b/arch/arm/mach-orion5x/wrt350n-v2-setup.c
@@ -259,7 +259,7 @@ static int __init wrt350n_v2_pci_init(void)
 subsys_initcall(wrt350n_v2_pci_init);
 
 MACHINE_START(WRT350N_V2, "Linksys WRT350N v2")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek */
 	.boot_params	= 0x00000100,
 	.init_machine	= wrt350n_v2_init,
 	.map_io		= orion5x_map_io,
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index 63d8b20..cf229b9 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -2,7 +2,7 @@
  * linux/arch/arm/mm/proc-xsc3.S
  *
  * Original Author: Matthew Gilbert
- * Current Maintainer: Lennert Buytenhek <buytenh@wantstofly.org>
+ * Current Maintainer: Lennert Buytenhek
  *
  * Copyright 2004 (C) Intel Corp.
  * Copyright 2005 (C) MontaVista Software, Inc.
diff --git a/arch/arm/plat-iop/gpio.c b/arch/arm/plat-iop/gpio.c
index 640e498..dccd69a 100644
--- a/arch/arm/plat-iop/gpio.c
+++ b/arch/arm/plat-iop/gpio.c
@@ -2,7 +2,7 @@
  * arch/arm/plat-iop/gpio.c
  * GPIO handling for Intel IOP3xx processors.
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/arm/plat-mxc/include/mach/entry-macro.S b/arch/arm/plat-mxc/include/mach/entry-macro.S
index bd9bb97..ac8099b 100644
--- a/arch/arm/plat-mxc/include/mach/entry-macro.S
+++ b/arch/arm/plat-mxc/include/mach/entry-macro.S
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
+ *  Copyright (C) 2007 Lennert Buytenhek
  *  Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
  */
 
diff --git a/arch/um/drivers/daemon_kern.c b/arch/um/drivers/daemon_kern.c
index b4a1522..106b5d3 100644
--- a/arch/um/drivers/daemon_kern.c
+++ b/arch/um/drivers/daemon_kern.c
@@ -1,6 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index f8e85e0..0e9b69d 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -1,7 +1,6 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
diff --git a/arch/um/drivers/mcast_kern.c b/arch/um/drivers/mcast_kern.c
index ffc6416..c6f3191 100644
--- a/arch/um/drivers/mcast_kern.c
+++ b/arch/um/drivers/mcast_kern.c
@@ -4,8 +4,7 @@
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  *
  * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  *
  * Licensed under the GPL.
diff --git a/arch/um/drivers/mcast_user.c b/arch/um/drivers/mcast_user.c
index ee19e91..7e7578a 100644
--- a/arch/um/drivers/mcast_user.c
+++ b/arch/um/drivers/mcast_user.c
@@ -4,8 +4,7 @@
  * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
  *
  * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  *
  * Licensed under the GPL.
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index c70e047..0294603 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
+ * Copyright (C) 2001 Lennert Buytenhek
  * Copyright (C) 2001 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index f8cf4c8..b72635d 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
+ * Copyright (C) 2001 Lennert Buytenhek
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 47d0c37..1ccf61e 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -1,7 +1,6 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
diff --git a/arch/um/include/shared/mconsole.h b/arch/um/include/shared/mconsole.h
index c139ae1..598b8df 100644
--- a/arch/um/include/shared/mconsole.h
+++ b/arch/um/include/shared/mconsole.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
+ * Copyright (C) 2001 Lennert Buytenhek
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
diff --git a/arch/um/os-Linux/drivers/ethertap_kern.c b/arch/um/os-Linux/drivers/ethertap_kern.c
index 7f6f9a7..1a13083 100644
--- a/arch/um/os-Linux/drivers/ethertap_kern.c
+++ b/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -1,6 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index cc72cb2..19d0a11 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -1,7 +1,6 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
- * James Leu (jleu@mindspring.net).
+ * Copyright (C) 2001 Lennert Buytenhek and James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
  */
diff --git a/drivers/net/arm/ep93xx_eth.c b/drivers/net/arm/ep93xx_eth.c
index 5a77001..a7dbb0b 100644
--- a/drivers/net/arm/ep93xx_eth.c
+++ b/drivers/net/arm/ep93xx_eth.c
@@ -1,6 +1,6 @@
 /*
  * EP93xx ethernet network device driver
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/caleb.c b/drivers/net/ixp2000/caleb.c
index 7dea5b9..718fc03 100644
--- a/drivers/net/ixp2000/caleb.c
+++ b/drivers/net/ixp2000/caleb.c
@@ -1,6 +1,6 @@
 /*
  * Helper functions for the SPI-3 bridge FPGA on the Radisys ENP2611
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/caleb.h b/drivers/net/ixp2000/caleb.h
index e93a1ef..3027e1e 100644
--- a/drivers/net/ixp2000/caleb.h
+++ b/drivers/net/ixp2000/caleb.h
@@ -1,6 +1,6 @@
 /*
  * Helper functions for the SPI-3 bridge FPGA on the Radisys ENP2611
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/enp2611.c b/drivers/net/ixp2000/enp2611.c
index 34a6cfd..bb6ee6b 100644
--- a/drivers/net/ixp2000/enp2611.c
+++ b/drivers/net/ixp2000/enp2611.c
@@ -1,6 +1,6 @@
 /*
  * IXP2400 MSF network device driver for the Radisys ENP2611
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/ixp2400-msf.c b/drivers/net/ixp2000/ixp2400-msf.c
index f5ffd7e..3f0ab8c 100644
--- a/drivers/net/ixp2000/ixp2400-msf.c
+++ b/drivers/net/ixp2000/ixp2400-msf.c
@@ -2,7 +2,7 @@
  * Generic library functions for the MSF (Media and Switch Fabric) unit
  * found on the Intel IXP2400 network processor.
  *
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/ixp2400-msf.h b/drivers/net/ixp2000/ixp2400-msf.h
index 3ac1af2..24b5b82 100644
--- a/drivers/net/ixp2000/ixp2400-msf.h
+++ b/drivers/net/ixp2000/ixp2400-msf.h
@@ -2,7 +2,7 @@
  * Generic library functions for the MSF (Media and Switch Fabric) unit
  * found on the Intel IXP2400 network processor.
  *
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/ixpdev.c b/drivers/net/ixp2000/ixpdev.c
index 78ddd8b..f5a17f5 100644
--- a/drivers/net/ixp2000/ixpdev.c
+++ b/drivers/net/ixp2000/ixpdev.c
@@ -1,6 +1,6 @@
 /*
  * IXP2000 MSF network device driver
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/ixpdev.h b/drivers/net/ixp2000/ixpdev.h
index 391ece6..bf093e0 100644
--- a/drivers/net/ixp2000/ixpdev.h
+++ b/drivers/net/ixp2000/ixpdev.h
@@ -1,6 +1,6 @@
 /*
  * IXP2000 MSF network device driver
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/ixpdev_priv.h b/drivers/net/ixp2000/ixpdev_priv.h
index 86aa08e..a431279 100644
--- a/drivers/net/ixp2000/ixpdev_priv.h
+++ b/drivers/net/ixp2000/ixpdev_priv.h
@@ -1,6 +1,6 @@
 /*
  * IXP2000 MSF network device driver
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/pm3386.c b/drivers/net/ixp2000/pm3386.c
index e08d3f9..8f737bb 100644
--- a/drivers/net/ixp2000/pm3386.c
+++ b/drivers/net/ixp2000/pm3386.c
@@ -1,6 +1,6 @@
 /*
  * Helper functions for the PM3386s on the Radisys ENP2611
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/ixp2000/pm3386.h b/drivers/net/ixp2000/pm3386.h
index cc4183d..354ac6c 100644
--- a/drivers/net/ixp2000/pm3386.h
+++ b/drivers/net/ixp2000/pm3386.h
@@ -1,6 +1,6 @@
 /*
  * Helper functions for the PM3386s on the Radisys ENP2611
- * Copyright (C) 2004, 2005 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2004, 2005 Lennert Buytenhek
  * Dedicated to Marija Kulikova.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 34425b9..c3014ee 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -18,7 +18,7 @@
  *				     <sjhill@realitydiluted.com>
  *
  * Copyright (C) 2007-2008 Marvell Semiconductor
- *			   Lennert Buytenhek <buytenh@marvell.com>
+ *			   Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3695227..fce64b1 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5030,5 +5030,5 @@ module_exit(mwl8k_exit);
 
 MODULE_DESCRIPTION(MWL8K_DESC);
 MODULE_VERSION(MWL8K_VERSION);
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com>");
+MODULE_AUTHOR("Lennert Buytenhek");
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
index 4e68161..db6cf18 100644
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -17,7 +17,7 @@
  *  by Nick Bane <nick@cecomputing.co.uk> 26-8-2004
  *
  * Modified for ep93xx from ohci-pxa27x.c
- *  by Lennert Buytenhek <buytenh@wantstofly.org> 28-2-2006
+ *  by Lennert Buytenhek 28-2-2006
  *  Based on an earlier driver by Ray Lehtiniemi
  *
  * This file is licenced under the GPL.
diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index 35f61dd..8592847 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -841,7 +841,6 @@ static void __exit pxa168fb_exit(void)
 }
 module_exit(pxa168fb_exit);
 
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com> "
-	      "Green Wan <gwan@marvell.com>");
+MODULE_AUTHOR("Lennert Buytenhek, Green Wan <gwan@marvell.com>");
 MODULE_DESCRIPTION("Framebuffer driver for PXA168/910");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index dd3f201..6f84cef 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -2,7 +2,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 84bbb82..67024e0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 21e5901..2ec4d28 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 88485cc..b07a302 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ee64287..60017d1 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index dce8f00..d63e11a 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e216079..1940e53 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index cb43312..174c2d9 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index f97af559..689f2d2 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *	Bart De Schuymer		<bdschuym@pandora.be>
  *
  *	This program is free software; you can redistribute it and/or
diff --git a/net/bridge/br_notify.c b/net/bridge/br_notify.c
index 7d337c9..911d219 100644
--- a/net/bridge/br_notify.c
+++ b/net/bridge/br_notify.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 19e2f46..de53108 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2,7 +2,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_private_stp.h b/net/bridge/br_private_stp.h
index 8b650f7..200683b 100644
--- a/net/bridge/br_private_stp.h
+++ b/net/bridge/br_private_stp.h
@@ -2,7 +2,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 7370d14..d7e1c69 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 289646e..5cf9ae3 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 79372d4..6e8c2ed 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp_timer.c b/net/bridge/br_stp_timer.c
index 3e96514..179800e 100644
--- a/net/bridge/br_stp_timer.c
+++ b/net/bridge/br_stp_timer.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 0c55eaa..1c6b915 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -98,8 +98,8 @@
  *
  * Randy Dunlap fixed u64 printk compiler waring
  *
- * Remove FCS from BW calculation.  Lennert Buytenhek <buytenh@wantstofly.org>
- * New time handling. Lennert Buytenhek <buytenh@wantstofly.org> 041213
+ * Remove FCS from BW calculation.  Lennert Buytenhek
+ * New time handling. Lennert Buytenhek 041213
  *
  * Corrections from Nikolai Malykh (nmalykh@bilim.com)
  * Removed unused flags F_SET_SRCMAC & F_SET_SRCIP 041230
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 3fb14b7..1ad5371 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -428,7 +428,7 @@ static void __exit dsa_cleanup_module(void)
 }
 module_exit(dsa_cleanup_module);
 
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>");
+MODULE_AUTHOR("Lennert Buytenhek");
 MODULE_DESCRIPTION("Driver for Distributed Switch Architecture switch chips");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:dsa");
diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
index 042f4e9..e1b5eb0 100644
--- a/sound/soc/ep93xx/ep93xx-i2s.c
+++ b/sound/soc/ep93xx/ep93xx-i2s.c
@@ -6,7 +6,7 @@
  *
  * Based on the original driver by:
  *   Copyright (C) 2007 Chase Douglas <chasedouglas@gmail>
- *   Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ *   Copyright (C) 2006 Lennert Buytenhek
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index a456e49..e18915c 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -1,7 +1,7 @@
 /*
  * linux/sound/arm/ep93xx-pcm.c - EP93xx ALSA PCM interface
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  * Copyright (C) 2006 Applied Data Systems
  *
  * Rewritten for the SoC audio subsystem (Based on PXA2xx code):
diff --git a/sound/soc/ep93xx/ep93xx-pcm.h b/sound/soc/ep93xx/ep93xx-pcm.h
index 111e112..3ded0a9 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.h
+++ b/sound/soc/ep93xx/ep93xx-pcm.h
@@ -1,7 +1,7 @@
 /*
  * sound/soc/ep93xx/ep93xx-pcm.h - EP93xx ALSA PCM interface
  *
- * Copyright (C) 2006 Lennert Buytenhek <buytenh@wantstofly.org>
+ * Copyright (C) 2006 Lennert Buytenhek
  * Copyright (C) 2006 Applied Data Systems
  *
  * This program is free software; you can redistribute it and/or modify
