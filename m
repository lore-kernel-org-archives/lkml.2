Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab0J2W3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:29:32 -0400
Received: from static.200.77.63.178.clients.your-server.de ([178.63.77.200]:50806
	"EHLO Debian-50-lenny-64-minimal" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932472Ab0J2W33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:29:29 -0400
Date: Sat, 30 Oct 2010 00:29:29 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/6] arm: plat-tcc: Change mail address of Hans J. Koch
Message-ID: <20101029222929.GD4331@local>
References: <20101029221231.GA4331@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029221231.GA4331@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My old mail address doesn't exist anymore. This changes all occurrences
to my new address.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
---
 arch/arm/mach-tcc8k/board-tcc8000-sdk.c      |    2 +-
 arch/arm/mach-tcc8k/clock.c                  |    2 +-
 arch/arm/mach-tcc8k/devices.c                |    2 +-
 arch/arm/mach-tcc8k/io.c                     |    2 +-
 arch/arm/mach-tcc8k/irq.c                    |    2 +-
 arch/arm/mach-tcc8k/time.c                   |    2 +-
 arch/arm/plat-tcc/clock.c                    |    2 +-
 arch/arm/plat-tcc/include/mach/clock.h       |    2 +-
 arch/arm/plat-tcc/include/mach/debug-macro.S |    2 +-
 arch/arm/plat-tcc/include/mach/hardware.h    |    2 +-
 arch/arm/plat-tcc/include/mach/io.h          |    2 +-
 arch/arm/plat-tcc/include/mach/irqs.h        |    2 +-
 arch/arm/plat-tcc/include/mach/memory.h      |    2 +-
 arch/arm/plat-tcc/include/mach/tcc8k-regs.h  |    2 +-
 arch/arm/plat-tcc/include/mach/uncompress.h  |    2 +-
 arch/arm/plat-tcc/system.c                   |    2 +-
 16 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-tcc8k/board-tcc8000-sdk.c b/arch/arm/mach-tcc8k/board-tcc8000-sdk.c
index 7991415..7cba61f 100644
--- a/arch/arm/mach-tcc8k/board-tcc8000-sdk.c
+++ b/arch/arm/mach-tcc8k/board-tcc8000-sdk.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/mach-tcc8k/clock.c b/arch/arm/mach-tcc8k/clock.c
index ba32a15..7837f0e 100644
--- a/arch/arm/mach-tcc8k/clock.c
+++ b/arch/arm/mach-tcc8k/clock.c
@@ -1,7 +1,7 @@
 /*
  * Lowlevel clock handling for Telechips TCC8xxx SoCs
  *
- * Copyright (C) 2010 by Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2010 by Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GPL v2
  */
diff --git a/arch/arm/mach-tcc8k/devices.c b/arch/arm/mach-tcc8k/devices.c
index 6722ad7..3300159 100644
--- a/arch/arm/mach-tcc8k/devices.c
+++ b/arch/arm/mach-tcc8k/devices.c
@@ -2,7 +2,7 @@
  * linux/arch/arm/mach-tcc8k/devices.c
  *
  * Copyright (C) Telechips, Inc.
- * Copyright (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of GPL v2.
  *
diff --git a/arch/arm/mach-tcc8k/io.c b/arch/arm/mach-tcc8k/io.c
index 9b39d7f..4c7da0d 100644
--- a/arch/arm/mach-tcc8k/io.c
+++ b/arch/arm/mach-tcc8k/io.c
@@ -1,7 +1,7 @@
 /*
  * linux/arch/arm/mach-tcc8k/io.c
  *
- * (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * derived from TCC83xx io.c
  * Copyright (C) Telechips, Inc.
diff --git a/arch/arm/mach-tcc8k/irq.c b/arch/arm/mach-tcc8k/irq.c
index 34575c4..5e8ec9d 100644
--- a/arch/arm/mach-tcc8k/irq.c
+++ b/arch/arm/mach-tcc8k/irq.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Telechips, Inc.
- * Copyright (C) 2009-2010 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2009-2010 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GNU GPL version 2.
  */
diff --git a/arch/arm/mach-tcc8k/time.c b/arch/arm/mach-tcc8k/time.c
index 78d0600..3544de0 100644
--- a/arch/arm/mach-tcc8k/time.c
+++ b/arch/arm/mach-tcc8k/time.c
@@ -1,7 +1,7 @@
 /*
  * TCC8000 system timer setup
  *
- * (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GPL version 2.
  *
diff --git a/arch/arm/plat-tcc/clock.c b/arch/arm/plat-tcc/clock.c
index f3ced10..0d3261f 100644
--- a/arch/arm/plat-tcc/clock.c
+++ b/arch/arm/plat-tcc/clock.c
@@ -7,7 +7,7 @@
  * Modified for omap shared clock framework by Tony Lindgren <tony@atomide.com>
  * Copyright 2007 Freescale Semiconductor, Inc. All Rights Reserved.
  * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
- * Copyright 2010 Hans J. Koch, hjk@linutronix.de
+ * Copyright 2010 Hans J. Koch, hjk@hansjkoch.de
  *
  * Licensed under the terms of the GPL v2.
  */
diff --git a/arch/arm/plat-tcc/include/mach/clock.h b/arch/arm/plat-tcc/include/mach/clock.h
index a12f58a..0ffcc93 100644
--- a/arch/arm/plat-tcc/include/mach/clock.h
+++ b/arch/arm/plat-tcc/include/mach/clock.h
@@ -1,6 +1,6 @@
 /*
  * Low level clock header file for Telechips TCC architecture
- * (C) 2010 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2010 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the GPL v2.
  */
diff --git a/arch/arm/plat-tcc/include/mach/debug-macro.S b/arch/arm/plat-tcc/include/mach/debug-macro.S
index 7662f73..6733ecd 100644
--- a/arch/arm/plat-tcc/include/mach/debug-macro.S
+++ b/arch/arm/plat-tcc/include/mach/debug-macro.S
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 1994-1999 Russell King
  * Copyright (C) 2008-2009 Telechips
- * Copyright (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/plat-tcc/include/mach/hardware.h b/arch/arm/plat-tcc/include/mach/hardware.h
index e70d126..5645c3c 100644
--- a/arch/arm/plat-tcc/include/mach/hardware.h
+++ b/arch/arm/plat-tcc/include/mach/hardware.h
@@ -8,7 +8,7 @@
  * Copyright (C) 2001 RidgeRun, Inc.
  * Copyright (C) 2008-2009 Telechips
  *
- * Modifications for mainline (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * Modifications for mainline (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GNU Pulic License version 2.
  */
diff --git a/arch/arm/plat-tcc/include/mach/io.h b/arch/arm/plat-tcc/include/mach/io.h
index 3e911d3..f006f31 100644
--- a/arch/arm/plat-tcc/include/mach/io.h
+++ b/arch/arm/plat-tcc/include/mach/io.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 1997-1999 Russell King
  * Copyright (C) 2008-2009 Telechips
- * Copyright (C) 2010 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2010 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GNU Public License version 2.
  */
diff --git a/arch/arm/plat-tcc/include/mach/irqs.h b/arch/arm/plat-tcc/include/mach/irqs.h
index da86389..fa62e71 100644
--- a/arch/arm/plat-tcc/include/mach/irqs.h
+++ b/arch/arm/plat-tcc/include/mach/irqs.h
@@ -2,7 +2,7 @@
  * IRQ definitions for TCC8xxx
  *
  * Copyright (C) 2008-2009 Telechips
- * Copyright (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GPL v2.
  *
diff --git a/arch/arm/plat-tcc/include/mach/memory.h b/arch/arm/plat-tcc/include/mach/memory.h
index cd91ba8..c89cdc6 100644
--- a/arch/arm/plat-tcc/include/mach/memory.h
+++ b/arch/arm/plat-tcc/include/mach/memory.h
@@ -2,7 +2,7 @@
  * Copyright (C) 1999 ARM Limited
  * Copyright (C) 2000 RidgeRun, Inc.
  * Copyright (C) 2008-2009 Telechips
- * Copyright (C) 2010 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2010 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GPL v2.
  */
diff --git a/arch/arm/plat-tcc/include/mach/tcc8k-regs.h b/arch/arm/plat-tcc/include/mach/tcc8k-regs.h
index 1d94282..79912bb 100644
--- a/arch/arm/plat-tcc/include/mach/tcc8k-regs.h
+++ b/arch/arm/plat-tcc/include/mach/tcc8k-regs.h
@@ -1,7 +1,7 @@
 /*
  * Telechips TCC8000 register definitions
  *
- * (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GPLv2.
  */
diff --git a/arch/arm/plat-tcc/include/mach/uncompress.h b/arch/arm/plat-tcc/include/mach/uncompress.h
index 7a3e33a..df73880 100644
--- a/arch/arm/plat-tcc/include/mach/uncompress.h
+++ b/arch/arm/plat-tcc/include/mach/uncompress.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009 Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) 2009 Hans J. Koch <hjk@hansjkoch.de>
  *
  * This file is licensed under the terms of the GPL version 2.
  */
diff --git a/arch/arm/plat-tcc/system.c b/arch/arm/plat-tcc/system.c
index cc208fa..ac79308 100644
--- a/arch/arm/plat-tcc/system.c
+++ b/arch/arm/plat-tcc/system.c
@@ -1,7 +1,7 @@
 /*
  * System functions for Telechips TCCxxxx SoCs
  *
- * Copyright (C) Hans J. Koch <hjk@linutronix.de>
+ * Copyright (C) Hans J. Koch <hjk@hansjkoch.de>
  *
  * Licensed under the terms of the GPL v2.
  *
-- 
1.7.1

