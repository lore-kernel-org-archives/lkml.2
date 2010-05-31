Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0EaHA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:00:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:38180 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab0EaHAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:00:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm 3/3] remove needless ISA_DMA_THRESHOLD
Date: Mon, 31 May 2010 15:59:04 +0900
Message-Id: <1275289144-28782-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 31 May 2010 16:00:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures don't need to define ISA_DMA_THRESHOLD anymore.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/include/asm/scatterlist.h      |    2 --
 arch/avr32/include/asm/scatterlist.h      |    2 --
 arch/blackfin/include/asm/scatterlist.h   |    2 --
 arch/cris/include/asm/scatterlist.h       |    2 --
 arch/frv/include/asm/scatterlist.h        |    2 --
 arch/h8300/include/asm/scatterlist.h      |    2 --
 arch/ia64/include/asm/scatterlist.h       |    9 ---------
 arch/m32r/include/asm/scatterlist.h       |    2 --
 arch/m68k/include/asm/scatterlist.h       |    3 ---
 arch/microblaze/include/asm/scatterlist.h |    2 --
 arch/mips/include/asm/scatterlist.h       |    2 --
 arch/mn10300/include/asm/scatterlist.h    |    2 --
 arch/parisc/include/asm/scatterlist.h     |    1 -
 arch/powerpc/include/asm/scatterlist.h    |    3 ---
 arch/s390/include/asm/scatterlist.h       |    2 --
 arch/score/include/asm/scatterlist.h      |    2 --
 arch/sh/include/asm/scatterlist.h         |    2 --
 arch/sparc/include/asm/scatterlist.h      |    1 -
 arch/x86/include/asm/scatterlist.h        |    1 -
 arch/xtensa/include/asm/scatterlist.h     |    2 --
 20 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/arch/alpha/include/asm/scatterlist.h b/arch/alpha/include/asm/scatterlist.h
index 5728c52..017d747 100644
--- a/arch/alpha/include/asm/scatterlist.h
+++ b/arch/alpha/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (~0UL)
-
 #endif /* !(_ALPHA_SCATTERLIST_H) */
diff --git a/arch/avr32/include/asm/scatterlist.h b/arch/avr32/include/asm/scatterlist.h
index 06394e5..a5902d9 100644
--- a/arch/avr32/include/asm/scatterlist.h
+++ b/arch/avr32/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0xffffffff)
-
 #endif /* __ASM_AVR32_SCATTERLIST_H */
diff --git a/arch/blackfin/include/asm/scatterlist.h b/arch/blackfin/include/asm/scatterlist.h
index 64d41d3..d177a15 100644
--- a/arch/blackfin/include/asm/scatterlist.h
+++ b/arch/blackfin/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD	(0xffffffff)
-
 #endif				/* !(_BLACKFIN_SCATTERLIST_H) */
diff --git a/arch/cris/include/asm/scatterlist.h b/arch/cris/include/asm/scatterlist.h
index 249a784..f11f8f4 100644
--- a/arch/cris/include/asm/scatterlist.h
+++ b/arch/cris/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0x1fffffff)
-
 #endif /* !(__ASM_CRIS_SCATTERLIST_H) */
diff --git a/arch/frv/include/asm/scatterlist.h b/arch/frv/include/asm/scatterlist.h
index 1614bfd..0e5eb30 100644
--- a/arch/frv/include/asm/scatterlist.h
+++ b/arch/frv/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0xffffffffUL)
-
 #endif /* !_ASM_SCATTERLIST_H */
diff --git a/arch/h8300/include/asm/scatterlist.h b/arch/h8300/include/asm/scatterlist.h
index de08a4a..82130ed 100644
--- a/arch/h8300/include/asm/scatterlist.h
+++ b/arch/h8300/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD	(0xffffffff)
-
 #endif /* !(_H8300_SCATTERLIST_H) */
diff --git a/arch/ia64/include/asm/scatterlist.h b/arch/ia64/include/asm/scatterlist.h
index f299a4f..08fd93b 100644
--- a/arch/ia64/include/asm/scatterlist.h
+++ b/arch/ia64/include/asm/scatterlist.h
@@ -2,15 +2,6 @@
 #define _ASM_IA64_SCATTERLIST_H
 
 #include <asm-generic/scatterlist.h>
-/*
- * It used to be that ISA_DMA_THRESHOLD had something to do with the
- * DMA-limits of ISA-devices.  Nowadays, its only remaining use (apart
- * from the aha1542.c driver, which isn't 64-bit clean anyhow) is to
- * tell the block-layer (via BLK_BOUNCE_ISA) what the max. physical
- * address of a page is that is allocated with GFP_DMA.  On IA-64,
- * that's 4GB - 1.
- */
-#define ISA_DMA_THRESHOLD	0xffffffff
 #define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_IA64_SCATTERLIST_H */
diff --git a/arch/m32r/include/asm/scatterlist.h b/arch/m32r/include/asm/scatterlist.h
index aeeddd8..7370b8b 100644
--- a/arch/m32r/include/asm/scatterlist.h
+++ b/arch/m32r/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0x1fffffff)
-
 #endif /* _ASM_M32R_SCATTERLIST_H */
diff --git a/arch/m68k/include/asm/scatterlist.h b/arch/m68k/include/asm/scatterlist.h
index 175da06..3125054 100644
--- a/arch/m68k/include/asm/scatterlist.h
+++ b/arch/m68k/include/asm/scatterlist.h
@@ -3,7 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-/* This is bogus and should go away. */
-#define ISA_DMA_THRESHOLD (0x00ffffff)
-
 #endif /* !(_M68K_SCATTERLIST_H) */
diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
index dc4a890..35d786f 100644
--- a/arch/microblaze/include/asm/scatterlist.h
+++ b/arch/microblaze/include/asm/scatterlist.h
@@ -1,3 +1 @@
 #include <asm-generic/scatterlist.h>
-
-#define ISA_DMA_THRESHOLD	(~0UL)
diff --git a/arch/mips/include/asm/scatterlist.h b/arch/mips/include/asm/scatterlist.h
index 9af65e7..7ee0e64 100644
--- a/arch/mips/include/asm/scatterlist.h
+++ b/arch/mips/include/asm/scatterlist.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0x00ffffffUL)
-
 #endif /* __ASM_SCATTERLIST_H */
diff --git a/arch/mn10300/include/asm/scatterlist.h b/arch/mn10300/include/asm/scatterlist.h
index 7bd00b9..7baa400 100644
--- a/arch/mn10300/include/asm/scatterlist.h
+++ b/arch/mn10300/include/asm/scatterlist.h
@@ -13,6 +13,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0x00ffffff)
-
 #endif /* _ASM_SCATTERLIST_H */
diff --git a/arch/parisc/include/asm/scatterlist.h b/arch/parisc/include/asm/scatterlist.h
index 2c3b79b..8bf1f0d 100644
--- a/arch/parisc/include/asm/scatterlist.h
+++ b/arch/parisc/include/asm/scatterlist.h
@@ -5,7 +5,6 @@
 #include <asm/types.h>
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (~0UL)
 #define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
 
 #endif /* _ASM_PARISC_SCATTERLIST_H */
diff --git a/arch/powerpc/include/asm/scatterlist.h b/arch/powerpc/include/asm/scatterlist.h
index 34cc78f..de1f620 100644
--- a/arch/powerpc/include/asm/scatterlist.h
+++ b/arch/powerpc/include/asm/scatterlist.h
@@ -12,9 +12,6 @@
 #include <asm/dma.h>
 #include <asm-generic/scatterlist.h>
 
-#ifdef __powerpc64__
-#define ISA_DMA_THRESHOLD	(~0UL)
-#endif
 #define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_POWERPC_SCATTERLIST_H */
diff --git a/arch/s390/include/asm/scatterlist.h b/arch/s390/include/asm/scatterlist.h
index be44d94..35d786f 100644
--- a/arch/s390/include/asm/scatterlist.h
+++ b/arch/s390/include/asm/scatterlist.h
@@ -1,3 +1 @@
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
diff --git a/arch/score/include/asm/scatterlist.h b/arch/score/include/asm/scatterlist.h
index 4fa1a66..9f533b8 100644
--- a/arch/score/include/asm/scatterlist.h
+++ b/arch/score/include/asm/scatterlist.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_SCORE_SCATTERLIST_H
 #define _ASM_SCORE_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD	(~0UL)
-
 #include <asm-generic/scatterlist.h>
 
 #endif /* _ASM_SCORE_SCATTERLIST_H */
diff --git a/arch/sh/include/asm/scatterlist.h b/arch/sh/include/asm/scatterlist.h
index e38d1d4..98dfc35 100644
--- a/arch/sh/include/asm/scatterlist.h
+++ b/arch/sh/include/asm/scatterlist.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_SH_SCATTERLIST_H
 #define __ASM_SH_SCATTERLIST_H
 
-#define ISA_DMA_THRESHOLD	phys_addr_mask()
-
 #include <asm-generic/scatterlist.h>
 
 #endif /* __ASM_SH_SCATTERLIST_H */
diff --git a/arch/sparc/include/asm/scatterlist.h b/arch/sparc/include/asm/scatterlist.h
index 433e45f..92bb638 100644
--- a/arch/sparc/include/asm/scatterlist.h
+++ b/arch/sparc/include/asm/scatterlist.h
@@ -3,7 +3,6 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD	(~0UL)
 #define ARCH_HAS_SG_CHAIN
 
 #endif /* !(_SPARC_SCATTERLIST_H) */
diff --git a/arch/x86/include/asm/scatterlist.h b/arch/x86/include/asm/scatterlist.h
index fb0b187..4240878 100644
--- a/arch/x86/include/asm/scatterlist.h
+++ b/arch/x86/include/asm/scatterlist.h
@@ -3,7 +3,6 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (0x00ffffff)
 #define ARCH_HAS_SG_CHAIN
 
 #endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/arch/xtensa/include/asm/scatterlist.h b/arch/xtensa/include/asm/scatterlist.h
index b1f9fdc..a0421a6 100644
--- a/arch/xtensa/include/asm/scatterlist.h
+++ b/arch/xtensa/include/asm/scatterlist.h
@@ -13,6 +13,4 @@
 
 #include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (~0UL)
-
 #endif	/* _XTENSA_SCATTERLIST_H */
-- 
1.6.5

