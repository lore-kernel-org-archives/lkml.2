Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1DDVPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:15:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1DDVPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xqG4dO7+t2F5RkouU39oMeFLQt8tUi6F6W0Z8sjJ8Ryrxh+C945R+HV8wrcCutMPQZ
         S0vfvF0eTV/Z/00Xo5tpmNq0jV1V7lj1oKSMaeMFNyvfbEiYD9uMuLu7FFkmMzY6tH6k
         uk/OUArdVp4Vp6LGYx7PcWaiXmRLY+Av8B8Fw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: davem@davemloft.net
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]update old email address in various parts of the kernel.
Date: Mon,  4 Apr 2011 14:15:29 -0700
Message-Id: <1301951729-18814-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure...but I am guessing the owner of the email address dm@engr.sgi.com
needs to change this themselves for one reason or another as stated in submitting
patches etc...Anyways was doing some other testing and this was my test subject
seding and friends!! anyways take it and/or leave it..either case my testing worked.. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/fw/arc/cmdline.c          |    2 +-
 arch/mips/fw/arc/env.c              |    2 +-
 arch/mips/fw/arc/identify.c         |    2 +-
 arch/mips/fw/arc/init.c             |    2 +-
 arch/mips/fw/arc/misc.c             |    2 +-
 arch/mips/fw/arc/salone.c           |    2 +-
 arch/mips/fw/arc/time.c             |    2 +-
 arch/mips/fw/arc/tree.c             |    2 +-
 arch/mips/include/asm/asmmacro-32.h |    2 +-
 arch/mips/include/asm/asmmacro-64.h |    2 +-
 arch/mips/include/asm/cpu.h         |    2 +-
 arch/mips/include/asm/r4kcache.h    |    2 +-
 arch/mips/include/asm/sgialib.h     |    2 +-
 arch/mips/include/asm/sgiarcs.h     |    2 +-
 arch/mips/kernel/octeon_switch.S    |    2 +-
 arch/mips/kernel/r2300_fpu.S        |    2 +-
 arch/mips/kernel/r2300_switch.S     |    2 +-
 arch/mips/kernel/r4k_fpu.S          |    2 +-
 arch/mips/kernel/r4k_switch.S       |    2 +-
 arch/mips/kernel/r6000_fpu.S        |    2 +-
 arch/mips/mm/c-r3k.c                |    2 +-
 arch/mips/mm/c-r4k.c                |    2 +-
 arch/mips/mm/c-tx39.c               |    2 +-
 arch/mips/mm/sc-ip22.c              |    2 +-
 arch/mips/mm/sc-r5k.c               |    2 +-
 arch/mips/mm/tlb-r3k.c              |    2 +-
 arch/mips/mm/tlb-r4k.c              |    2 +-
 arch/mips/mm/tlb-r8k.c              |    2 +-
 arch/mips/sgi-ip22/ip22-hpc.c       |    2 +-
 arch/mips/sgi-ip22/ip22-int.c       |    2 +-
 arch/mips/sgi-ip22/ip22-mc.c        |    2 +-
 arch/mips/sgi-ip22/ip22-setup.c     |    2 +-
 drivers/net/sgiseeq.c               |    2 +-
 drivers/net/sgiseeq.h               |    2 +-
 drivers/scsi/sgiwd93.c              |    2 +-
 drivers/video/console/newport_con.c |    2 +-
 include/video/newport.h             |    2 +-
 37 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/mips/fw/arc/cmdline.c b/arch/mips/fw/arc/cmdline.c
index 5c8603c..9fdf07e 100644
--- a/arch/mips/fw/arc/cmdline.c
+++ b/arch/mips/fw/arc/cmdline.c
@@ -5,7 +5,7 @@
  *
  * cmdline.c: Kernel command line creation using ARCS argc/argv.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/arch/mips/fw/arc/env.c b/arch/mips/fw/arc/env.c
index 6f5dd42..1118a26 100644
--- a/arch/mips/fw/arc/env.c
+++ b/arch/mips/fw/arc/env.c
@@ -5,7 +5,7 @@
  *
  * env.c: ARCS environment variable routines.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/arch/mips/fw/arc/identify.c b/arch/mips/fw/arc/identify.c
index 0ce9acf..788060a 100644
--- a/arch/mips/fw/arc/identify.c
+++ b/arch/mips/fw/arc/identify.c
@@ -9,7 +9,7 @@
  *
  * This code is based on arch/mips/sgi/kernel/system.c, which is
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/arch/mips/fw/arc/init.c b/arch/mips/fw/arc/init.c
index 3ad8788..629b24d 100644
--- a/arch/mips/fw/arc/init.c
+++ b/arch/mips/fw/arc/init.c
@@ -5,7 +5,7 @@
  *
  * PROM library initialisation code.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/arch/mips/fw/arc/misc.c b/arch/mips/fw/arc/misc.c
index e527c5f..29627fb 100644
--- a/arch/mips/fw/arc/misc.c
+++ b/arch/mips/fw/arc/misc.c
@@ -5,7 +5,7 @@
  *
  * Miscellaneous ARCS PROM routines.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1999 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 1999 Silicon Graphics, Inc.
  */
diff --git a/arch/mips/fw/arc/salone.c b/arch/mips/fw/arc/salone.c
index e6afb64..9b56895 100644
--- a/arch/mips/fw/arc/salone.c
+++ b/arch/mips/fw/arc/salone.c
@@ -2,7 +2,7 @@
  * Routines to load into memory and execute stand-along program images using
  * ARCS PROM firmware.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <linux/init.h>
 #include <asm/sgialib.h>
diff --git a/arch/mips/fw/arc/time.c b/arch/mips/fw/arc/time.c
index 42138c8..190cdb5 100644
--- a/arch/mips/fw/arc/time.c
+++ b/arch/mips/fw/arc/time.c
@@ -5,7 +5,7 @@
  *
  * Extracting time information from ARCS prom.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <linux/init.h>
 
diff --git a/arch/mips/fw/arc/tree.c b/arch/mips/fw/arc/tree.c
index d68e5a5..924a37d 100644
--- a/arch/mips/fw/arc/tree.c
+++ b/arch/mips/fw/arc/tree.c
@@ -5,7 +5,7 @@
  *
  * PROM component device tree code.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1999 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 1999 Silicon Graphics, Inc.
  */
diff --git a/arch/mips/include/asm/asmmacro-32.h b/arch/mips/include/asm/asmmacro-32.h
index 5de3963..2413afe 100644
--- a/arch/mips/include/asm/asmmacro-32.h
+++ b/arch/mips/include/asm/asmmacro-32.h
@@ -1,7 +1,7 @@
 /*
  * asmmacro.h: Assembler macros to make things easier to read.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1998, 1999, 2003 Ralf Baechle
  */
 #ifndef _ASM_ASMMACRO_32_H
diff --git a/arch/mips/include/asm/asmmacro-64.h b/arch/mips/include/asm/asmmacro-64.h
index 225feef..08a527d 100644
--- a/arch/mips/include/asm/asmmacro-64.h
+++ b/arch/mips/include/asm/asmmacro-64.h
@@ -1,7 +1,7 @@
 /*
  * asmmacro.h: Assembler macros to make things easier to read.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1998, 1999 Ralf Baechle
  * Copyright (C) 1999 Silicon Graphics, Inc.
  */
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 8687753..e7af793 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -2,7 +2,7 @@
  * cpu.h: Values of the PRId register used to match up
  *        various MIPS cpu types.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 2004  Maciej W. Rozycki
  */
 #ifndef _ASM_CPU_H
diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index 387bf59..54ea47d 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -5,7 +5,7 @@
  *
  * Inline assembly cache operations.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997 - 2002 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 2004 Ralf Baechle (ralf@linux-mips.org)
  */
diff --git a/arch/mips/include/asm/sgialib.h b/arch/mips/include/asm/sgialib.h
index 2a2f1bd..f581157 100644
--- a/arch/mips/include/asm/sgialib.h
+++ b/arch/mips/include/asm/sgialib.h
@@ -5,7 +5,7 @@
  *
  * SGI ARCS firmware interface library for the Linux kernel.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 2001, 2002 Ralf Baechle (ralf@gnu.org)
  */
 #ifndef _ASM_SGIALIB_H
diff --git a/arch/mips/include/asm/sgiarcs.h b/arch/mips/include/asm/sgiarcs.h
index 721327f..1493429 100644
--- a/arch/mips/include/asm/sgiarcs.h
+++ b/arch/mips/include/asm/sgiarcs.h
@@ -5,7 +5,7 @@
  *
  * ARC firmware interface defines.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1999, 2001 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 1999 Silicon Graphics, Inc.
  */
diff --git a/arch/mips/kernel/octeon_switch.S b/arch/mips/kernel/octeon_switch.S
index dd18b26..ce89c80 100644
--- a/arch/mips/kernel/octeon_switch.S
+++ b/arch/mips/kernel/octeon_switch.S
@@ -4,7 +4,7 @@
  * for more details.
  *
  * Copyright (C) 1994, 1995, 1996, 1998, 1999, 2002, 2003 Ralf Baechle
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1994, 1995, 1996, by Andreas Busse
  * Copyright (C) 1999 Silicon Graphics, Inc.
  * Copyright (C) 2000 MIPS Technologies, Inc.
diff --git a/arch/mips/kernel/r2300_fpu.S b/arch/mips/kernel/r2300_fpu.S
index ac68e68..61c8a0f 100644
--- a/arch/mips/kernel/r2300_fpu.S
+++ b/arch/mips/kernel/r2300_fpu.S
@@ -6,7 +6,7 @@
  * Copyright (C) 1996, 1998 by Ralf Baechle
  *
  * Multi-arch abstraction and asm macros for easier reading:
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  *
  * Further modifications to make this work:
  * Copyright (c) 1998 Harald Koerfgen
diff --git a/arch/mips/kernel/r2300_switch.S b/arch/mips/kernel/r2300_switch.S
index 698414b..2938983 100644
--- a/arch/mips/kernel/r2300_switch.S
+++ b/arch/mips/kernel/r2300_switch.S
@@ -5,7 +5,7 @@
  * Copyright (C) 1994, 1995, 1996 by Andreas Busse
  *
  * Multi-cpu abstraction and macros for easier reading:
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  *
  * Further modifications to make this work:
  * Copyright (c) 1998-2000 Harald Koerfgen
diff --git a/arch/mips/kernel/r4k_fpu.S b/arch/mips/kernel/r4k_fpu.S
index dbd42ad..55ffe14 100644
--- a/arch/mips/kernel/r4k_fpu.S
+++ b/arch/mips/kernel/r4k_fpu.S
@@ -6,7 +6,7 @@
  * Copyright (C) 1996, 98, 99, 2000, 01 Ralf Baechle
  *
  * Multi-arch abstraction and asm macros for easier reading:
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  *
  * Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000 MIPS Technologies, Inc.
diff --git a/arch/mips/kernel/r4k_switch.S b/arch/mips/kernel/r4k_switch.S
index 8893ee1..9414f93 100644
--- a/arch/mips/kernel/r4k_switch.S
+++ b/arch/mips/kernel/r4k_switch.S
@@ -4,7 +4,7 @@
  * for more details.
  *
  * Copyright (C) 1994, 1995, 1996, 1998, 1999, 2002, 2003 Ralf Baechle
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1994, 1995, 1996, by Andreas Busse
  * Copyright (C) 1999 Silicon Graphics, Inc.
  * Copyright (C) 2000 MIPS Technologies, Inc.
diff --git a/arch/mips/kernel/r6000_fpu.S b/arch/mips/kernel/r6000_fpu.S
index 43cda53..da0fbe4 100644
--- a/arch/mips/kernel/r6000_fpu.S
+++ b/arch/mips/kernel/r6000_fpu.S
@@ -8,7 +8,7 @@
  * Copyright (C) 1996 by Ralf Baechle
  *
  * Multi-arch abstraction and asm macros for easier reading:
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #include <asm/asm.h>
 #include <asm/fpregdef.h>
diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 54e5f7b..e6b0efd 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -1,7 +1,7 @@
 /*
  * r2300.c: R2000 and R3000 specific mmu/cache code.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  *
  * with a lot of changes to make this thing work for R3000s
  * Tx39XX R4k style caches added. HK
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index b4923a7..fd5cb57 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  */
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index 6515b44..d352fad 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -1,7 +1,7 @@
 /*
  * r2300.c: R2000 and R3000 specific mmu/cache code.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  *
  * with a lot of changes to make this thing work for R3000s
  * Tx39XX R4k style caches added. HK
diff --git a/arch/mips/mm/sc-ip22.c b/arch/mips/mm/sc-ip22.c
index 13adb57..a6bd11f 100644
--- a/arch/mips/mm/sc-ip22.c
+++ b/arch/mips/mm/sc-ip22.c
@@ -2,7 +2,7 @@
  * sc-ip22.c: Indy cache management functions.
  *
  * Copyright (C) 1997, 2001 Ralf Baechle (ralf@gnu.org),
- * derived from r4xx0.c by David S. Miller (dm@engr.sgi.com).
+ * derived from r4xx0.c by David S. Miller (davem@davemloft.net).
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/arch/mips/mm/sc-r5k.c b/arch/mips/mm/sc-r5k.c
index f330d38..ae1e533 100644
--- a/arch/mips/mm/sc-r5k.c
+++ b/arch/mips/mm/sc-r5k.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 1997, 2001 Ralf Baechle (ralf@gnu.org),
- * derived from r4xx0.c by David S. Miller (dm@engr.sgi.com).
+ * derived from r4xx0.c by David S. Miller (davem@davemloft.net).
  */
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index 0f5ab23..40424af 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -1,7 +1,7 @@
 /*
  * r2300.c: R2000 and R3000 specific mmu/cache code.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  *
  * with a lot of changes to make this thing work for R3000s
  * Tx39XX R4k style caches added. HK
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index c618eed..ba40325 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997, 1998, 1999, 2000 Ralf Baechle ralf@gnu.org
  * Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2002 MIPS Technologies, Inc.  All rights reserved.
diff --git a/arch/mips/mm/tlb-r8k.c b/arch/mips/mm/tlb-r8k.c
index 2b82f23..3d95f76 100644
--- a/arch/mips/mm/tlb-r8k.c
+++ b/arch/mips/mm/tlb-r8k.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997, 1998, 1999, 2000 Ralf Baechle ralf@gnu.org
  * Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2002 MIPS Technologies, Inc.  All rights reserved.
diff --git a/arch/mips/sgi-ip22/ip22-hpc.c b/arch/mips/sgi-ip22/ip22-hpc.c
index 5c00cdd..bb70589 100644
--- a/arch/mips/sgi-ip22/ip22-hpc.c
+++ b/arch/mips/sgi-ip22/ip22-hpc.c
@@ -1,7 +1,7 @@
 /*
  * ip22-hpc.c: Routines for generic manipulation of the HPC controllers.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1998 Ralf Baechle
  */
 
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index 476423a..b4d08e4 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -2,7 +2,7 @@
  * ip22-int.c: Routines for generic manipulation of the INT[23] ASIC
  *             found on INDY and Indigo2 workstations.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997, 1998 Ralf Baechle (ralf@gnu.org)
  * Copyright (C) 1999 Andrew R. Baker (andrewb@uab.edu)
  *                    - Indigo2 changes
diff --git a/arch/mips/sgi-ip22/ip22-mc.c b/arch/mips/sgi-ip22/ip22-mc.c
index 5268ac1..d22262e 100644
--- a/arch/mips/sgi-ip22/ip22-mc.c
+++ b/arch/mips/sgi-ip22/ip22-mc.c
@@ -1,7 +1,7 @@
 /*
  * ip22-mc.c: Routines for manipulating SGI Memory Controller.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1999 Andrew R. Baker (andrewb@uab.edu) - Indigo2 changes
  * Copyright (C) 2003 Ladislav Michl  (ladis@linux-mips.org)
  * Copyright (C) 2004 Peter Fuerst    (pf@net.alphadv.de) - IP28
diff --git a/arch/mips/sgi-ip22/ip22-setup.c b/arch/mips/sgi-ip22/ip22-setup.c
index 5deeb68..5e66213 100644
--- a/arch/mips/sgi-ip22/ip22-setup.c
+++ b/arch/mips/sgi-ip22/ip22-setup.c
@@ -1,7 +1,7 @@
 /*
  * ip22-setup.c: SGI specific setup, including init of the feature struct.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997, 1998 Ralf Baechle (ralf@gnu.org)
  */
 #include <linux/init.h>
diff --git a/drivers/net/sgiseeq.c b/drivers/net/sgiseeq.c
index 3a0cc63..f016e61 100644
--- a/drivers/net/sgiseeq.c
+++ b/drivers/net/sgiseeq.c
@@ -1,7 +1,7 @@
 /*
  * sgiseeq.c: Seeq8003 ethernet driver for SGI machines.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 
 #undef DEBUG
diff --git a/drivers/net/sgiseeq.h b/drivers/net/sgiseeq.h
index 523104d..2211e29 100644
--- a/drivers/net/sgiseeq.h
+++ b/drivers/net/sgiseeq.h
@@ -1,7 +1,7 @@
 /*
  * sgiseeq.h: Defines for the Seeq8003 ethernet controller.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  */
 #ifndef _SGISEEQ_H
 #define _SGISEEQ_H
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index fef0e3c..3a9d85c 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1999 Andrew R. Baker (andrewb@uab.edu)
  * Copyright (C) 2001 Florian Lohoff (flo@rfc822.org)
  * Copyright (C) 2003, 07 Ralf Baechle (ralf@linux-mips.org)
diff --git a/drivers/video/console/newport_con.c b/drivers/video/console/newport_con.c
index 3772433..93317b5 100644
--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -6,7 +6,7 @@
  * 
  * This driver is based on sgicons.c and cons_newport.
  * 
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1997 Miguel de Icaza (miguel@nuclecu.unam.mx)
  */
 #include <linux/init.h>
diff --git a/include/video/newport.h b/include/video/newport.h
index 001b935..db9d9e3 100644
--- a/include/video/newport.h
+++ b/include/video/newport.h
@@ -3,7 +3,7 @@
  * newport.h: Defines and register layout for NEWPORT graphics
  *            hardware.
  *
- * Copyright (C) 1996 David S. Miller (dm@engr.sgi.com)
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
  * 
  * Ulf Carlsson - Compability with the IRIX structures added
  */
-- 
1.7.4.2

