Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2DXQZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:25:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:47644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab2DXQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:25:40 -0400
Message-Id: <20120424162224.526249106@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 24 Apr 2012 18:10:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
References: <20120424161039.293018424@chello.nl>
Content-Disposition: inline; filename=math128.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grow rudimentary u128 support without relying on gcc/libgcc.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/math128.h      |    4 ++
 arch/arm/include/asm/math128.h        |    4 ++
 arch/avr32/include/asm/math128.h      |    4 ++
 arch/blackfin/include/asm/math128.h   |    4 ++
 arch/c6x/include/asm/math128.h        |    4 ++
 arch/cris/include/asm/math128.h       |    4 ++
 arch/frv/include/asm/math128.h        |    4 ++
 arch/h8300/include/asm/math128.h      |    4 ++
 arch/hexagon/include/asm/math128.h    |    4 ++
 arch/ia64/include/asm/math128.h       |    4 ++
 arch/m32r/include/asm/math128.h       |    4 ++
 arch/m68k/include/asm/math128.h       |    4 ++
 arch/microblaze/include/asm/math128.h |    4 ++
 arch/mips/include/asm/math128.h       |    4 ++
 arch/mn10300/include/asm/math128.h    |    4 ++
 arch/openrisc/include/asm/math128.h   |    4 ++
 arch/parisc/include/asm/math128.h     |    4 ++
 arch/powerpc/include/asm/math128.h    |    4 ++
 arch/s390/include/asm/math128.h       |    4 ++
 arch/score/include/asm/math128.h      |    4 ++
 arch/sh/include/asm/math128.h         |    4 ++
 arch/sparc/include/asm/math128.h      |    4 ++
 arch/tile/include/asm/math128.h       |    4 ++
 arch/um/include/asm/math128.h         |    4 ++
 arch/unicore32/include/asm/math128.h  |    4 ++
 arch/x86/include/asm/math128.h        |    4 ++
 arch/xtensa/include/asm/math128.h     |    4 ++
 include/linux/math128.h               |   47 ++++++++++++++++++++++++++++++++++
 lib/Makefile                          |    2 -
 lib/math128.c                         |   42 ++++++++++++++++++++++++++++++
 30 files changed, 198 insertions(+), 1 deletion(-)

--- /dev/null
+++ b/arch/alpha/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/arm/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/avr32/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/blackfin/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/c6x/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/cris/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/frv/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/h8300/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/hexagon/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/ia64/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/m32r/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/m68k/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/microblaze/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/mips/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/mn10300/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/openrisc/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/parisc/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/powerpc/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/s390/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/score/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/sh/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/sparc/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/tile/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/um/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/unicore32/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/x86/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/arch/xtensa/include/asm/math128.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#endif /* _ASM_MATH128_H */
--- /dev/null
+++ b/include/linux/math128.h
@@ -0,0 +1,47 @@
+#ifndef _LINUX_MATH128_H
+#define _LINUX_MATH128_H
+
+#include <linux/types.h>
+
+typedef struct {
+	u64 hi, lo;
+} u128;
+
+#include <asm/math128.h>
+
+#ifndef add_u128
+static inline u128 add_u128(u128 a, u128 b)
+{
+	u128 res;
+
+	res.hi = a.hi + b.hi;
+	res.lo = a.lo + b.lo;
+
+	if (res.lo < a.lo || res.lo < b.lo)
+		res.hi++;
+
+	return res;
+}
+#endif /* add_u128 */
+
+#ifndef mult_u128
+extern int u128 mult_u128(u64 a, u64 b);
+#endif
+
+#ifndef cmp_u128
+static inline int cmp_u128(u128 a, u128 b)
+{
+	if (a.hi > b.hi)
+		return 1;
+	if (a.hi < b.hi)
+		return -1;
+	if (a.lo > b.lo)
+		return 1;
+	if (a.lo < b.lo)
+		return -1;
+
+	return 0;
+}
+#endif /* cmp_u128 */
+
+#endif /* _LINUX_MATH128_H */
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o math128.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
--- /dev/null
+++ b/lib/math128.c
@@ -0,0 +1,42 @@
+#include <linux/math128.h>
+
+#ifndef mult_u128
+/*
+ * a * b = (ah * 2^32 + al) * (bh * 2^32 + bl) =
+ *   ah*bh * 2^64 + (ah*bl + bh*al) * 2^32 + al*bl
+ */
+u128 mult_u128(u64 a, u64 b)
+{
+	u128 res;
+	u64 ah, al;
+	u64 bh, bl;
+	u128 t1, t2, t3, t4;
+
+	ah = a >> 32;
+	al = a & ((1ULL << 32) - 1);
+
+	bh = b >> 32;
+	bl = b & ((1ULL << 32) - 1);
+
+	t1.lo = 0;
+	t1.hi = ah * bh;
+
+	t2.lo = ah * bl;
+	t2.hi = t2.lo >> 32;
+	t2.lo <<= 32;
+
+	t3.lo = al * bh;
+	t3.hi = t3.lo >> 32;
+	t3.lo <<= 32;
+
+	t4.lo = al * bl;
+	t4.hi = 0;
+
+	res = add_u128(t1, t2);
+	res = add_u128(res, t3);
+	res = add_u128(res, t4);
+
+	return res;
+}
+#endif /* mult_u128 */
+


