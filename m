Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2DUJNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:13:48 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47233 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab2DUJKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:18 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 06/17] ARM clps711x: Remove now unused cs89712 board header
Date: Sat, 21 Apr 2012 13:11:19 +0400
Message-Id: <1334999490-27177-7-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/cs89712.h        |   49 ------------------------
 arch/arm/mach-clps711x/include/mach/hardware.h |    2 -
 2 files changed, 0 insertions(+), 51 deletions(-)
 delete mode 100644 arch/arm/include/asm/hardware/cs89712.h

diff --git a/arch/arm/include/asm/hardware/cs89712.h b/arch/arm/include/asm/hardware/cs89712.h
deleted file mode 100644
index f756269..0000000
--- a/arch/arm/include/asm/hardware/cs89712.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- *  arch/arm/include/asm/hardware/cs89712.h
- *
- *  This file contains the hardware definitions of the CS89712
- *  additional internal registers.
- *
- *  Copyright (C) 2001 Thomas Gleixner autronix automation <gleixner@autronix.de>
- *			
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#ifndef __ASM_HARDWARE_CS89712_H
-#define __ASM_HARDWARE_CS89712_H
-
-/*
-*	CS89712 additional registers
-*/
-                                  
-#define PCDR			0x0002	/* Port C Data register ---------------------------- */
-#define PCDDR			0x0042	/* Port C Data Direction register ------------------ */
-#define SDCONF			0x2300  /* SDRAM Configuration register ---------------------*/
-#define SDRFPR			0x2340  /* SDRAM Refresh period register --------------------*/
-
-#define SDCONF_ACTIVE		(1 << 10)
-#define SDCONF_CLKCTL		(1 << 9)
-#define SDCONF_WIDTH_4		(0 << 7)
-#define SDCONF_WIDTH_8		(1 << 7)
-#define SDCONF_WIDTH_16		(2 << 7)
-#define SDCONF_WIDTH_32		(3 << 7)
-#define SDCONF_SIZE_16		(0 << 5)
-#define SDCONF_SIZE_64		(1 << 5)
-#define SDCONF_SIZE_128		(2 << 5)
-#define SDCONF_SIZE_256		(3 << 5)
-#define SDCONF_CASLAT_2		(2)
-#define SDCONF_CASLAT_3		(3)
-
-#endif /* __ASM_HARDWARE_CS89712_H */
diff --git a/arch/arm/mach-clps711x/include/mach/hardware.h b/arch/arm/mach-clps711x/include/mach/hardware.h
index 8c7b28e..f00e87a 100644
--- a/arch/arm/mach-clps711x/include/mach/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach/hardware.h
@@ -73,7 +73,6 @@
 
 #include <asm/hardware/clps7111.h>
 #include <asm/hardware/ep7212.h>
-#include <asm/hardware/cs89712.h>
 
 #endif
 
@@ -82,7 +81,6 @@
 
 #include <asm/hardware/clps7111.h>
 #include <asm/hardware/ep7212.h>
-#include <asm/hardware/cs89712.h>
 
 /* static cdb89712_map_io() areas */
 #define REGISTER_START   0x80000000
-- 
1.7.3.4

