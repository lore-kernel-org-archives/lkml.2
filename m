Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1EKVHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:07:21 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756176Ab1EKVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:07:11 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] C6X: add include files
Date: Wed, 11 May 2011 16:13:55 -0400
Message-Id: <1305144843-5058-9-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-8-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/Kbuild              |    2 +
 arch/c6x/include/asm/asm-offsets.h       |    1 +
 arch/c6x/include/asm/atomic.h            |    6 +
 arch/c6x/include/asm/auxvec.h            |    6 +
 arch/c6x/include/asm/bitops.h            |  181 +++++++++++++++
 arch/c6x/include/asm/bitsperlong.h       |    6 +
 arch/c6x/include/asm/bug.h               |    6 +
 arch/c6x/include/asm/bugs.h              |    6 +
 arch/c6x/include/asm/byteorder.h         |   12 +
 arch/c6x/include/asm/cache.h             |  373 ++++++++++++++++++++++++++++++
 arch/c6x/include/asm/cacheflush.h        |   67 ++++++
 arch/c6x/include/asm/checksum.h          |  116 +++++++++
 arch/c6x/include/asm/clkdev.h            |   45 ++++
 arch/c6x/include/asm/clock.h             |   73 ++++++
 arch/c6x/include/asm/cputime.h           |    6 +
 arch/c6x/include/asm/current.h           |    6 +
 arch/c6x/include/asm/delay.h             |   69 ++++++
 arch/c6x/include/asm/device.h            |    6 +
 arch/c6x/include/asm/div64.h             |    6 +
 arch/c6x/include/asm/dma-mapping.h       |  302 ++++++++++++++++++++++++
 arch/c6x/include/asm/dma.h               |   25 ++
 arch/c6x/include/asm/elf.h               |  115 +++++++++
 arch/c6x/include/asm/emergency-restart.h |    6 +
 arch/c6x/include/asm/errno.h             |    6 +
 arch/c6x/include/asm/fb.h                |    6 +
 arch/c6x/include/asm/fcntl.h             |    6 +
 arch/c6x/include/asm/ftrace.h            |    6 +
 arch/c6x/include/asm/futex.h             |    6 +
 arch/c6x/include/asm/gemac.h             |  146 ++++++++++++
 arch/c6x/include/asm/gmdio.h             |  217 +++++++++++++++++
 arch/c6x/include/asm/hardirq.h           |   22 ++
 arch/c6x/include/asm/hardware.h          |   21 ++
 arch/c6x/include/asm/hw_irq.h            |    6 +
 arch/c6x/include/asm/io.h                |    6 +
 arch/c6x/include/asm/ioctl.h             |    6 +
 arch/c6x/include/asm/ioctls.h            |    6 +
 arch/c6x/include/asm/ipcbuf.h            |    6 +
 arch/c6x/include/asm/irq.h               |  101 ++++++++
 arch/c6x/include/asm/irq_regs.h          |    6 +
 arch/c6x/include/asm/irqflags.h          |   71 ++++++
 arch/c6x/include/asm/kdebug.h            |    6 +
 arch/c6x/include/asm/kmap_types.h        |    6 +
 arch/c6x/include/asm/leds.h              |   22 ++
 arch/c6x/include/asm/linkage.h           |    6 +
 arch/c6x/include/asm/local.h             |    6 +
 arch/c6x/include/asm/mman.h              |    7 +
 arch/c6x/include/asm/mmu.h               |   20 ++
 arch/c6x/include/asm/mmu_context.h       |    6 +
 arch/c6x/include/asm/module.h            |   35 +++
 arch/c6x/include/asm/msgbuf.h            |    6 +
 arch/c6x/include/asm/mutex.h             |    6 +
 arch/c6x/include/asm/page.h              |   11 +
 arch/c6x/include/asm/param.h             |    6 +
 arch/c6x/include/asm/pci.h               |    6 +
 arch/c6x/include/asm/percpu.h            |    6 +
 arch/c6x/include/asm/pgalloc.h           |    6 +
 arch/c6x/include/asm/pgtable.h           |   83 +++++++
 arch/c6x/include/asm/pll.h               |   79 +++++++
 arch/c6x/include/asm/pm.h                |   48 ++++
 arch/c6x/include/asm/poll.h              |    6 +
 arch/c6x/include/asm/posix_types.h       |    6 +
 arch/c6x/include/asm/processor.h         |  118 ++++++++++
 arch/c6x/include/asm/procinfo.h          |   30 +++
 arch/c6x/include/asm/ptrace.h            |  186 +++++++++++++++
 arch/c6x/include/asm/resource.h          |    6 +
 arch/c6x/include/asm/scatterlist.h       |    6 +
 arch/c6x/include/asm/sections.h          |   17 ++
 arch/c6x/include/asm/segment.h           |    1 +
 arch/c6x/include/asm/sembuf.h            |    6 +
 arch/c6x/include/asm/serial.h            |   25 ++
 arch/c6x/include/asm/setup.h             |   49 ++++
 arch/c6x/include/asm/sgmii.h             |   53 +++++
 arch/c6x/include/asm/shmbuf.h            |    6 +
 arch/c6x/include/asm/shmparam.h          |    6 +
 arch/c6x/include/asm/sigcontext.h        |   83 +++++++
 arch/c6x/include/asm/siginfo.h           |    6 +
 arch/c6x/include/asm/signal.h            |   17 ++
 arch/c6x/include/asm/socket.h            |    6 +
 arch/c6x/include/asm/sockios.h           |    6 +
 arch/c6x/include/asm/stat.h              |    6 +
 arch/c6x/include/asm/statfs.h            |    6 +
 arch/c6x/include/asm/string.h            |   29 +++
 arch/c6x/include/asm/swab.h              |    6 +
 arch/c6x/include/asm/syscalls.h          |   58 +++++
 arch/c6x/include/asm/system.h            |  194 ++++++++++++++++
 arch/c6x/include/asm/termbits.h          |    6 +
 arch/c6x/include/asm/termios.h           |    6 +
 arch/c6x/include/asm/thread_info.h       |  123 ++++++++++
 arch/c6x/include/asm/timer.h             |   31 +++
 arch/c6x/include/asm/timex.h             |   43 ++++
 arch/c6x/include/asm/tlb.h               |    8 +
 arch/c6x/include/asm/tlbflush.h          |    6 +
 arch/c6x/include/asm/topology.h          |    6 +
 arch/c6x/include/asm/traps.h             |   39 +++
 arch/c6x/include/asm/types.h             |    6 +
 arch/c6x/include/asm/uaccess.h           |  103 ++++++++
 arch/c6x/include/asm/ucontext.h          |    6 +
 arch/c6x/include/asm/unaligned.h         |  290 +++++++++++++++++++++++
 arch/c6x/include/asm/unistd.h            |   32 +++
 arch/c6x/include/asm/user.h              |    1 +
 arch/c6x/include/asm/vga.h               |    6 +
 101 files changed, 4106 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/Kbuild
 create mode 100644 arch/c6x/include/asm/asm-offsets.h
 create mode 100644 arch/c6x/include/asm/atomic.h
 create mode 100644 arch/c6x/include/asm/auxvec.h
 create mode 100644 arch/c6x/include/asm/bitops.h
 create mode 100644 arch/c6x/include/asm/bitsperlong.h
 create mode 100644 arch/c6x/include/asm/bug.h
 create mode 100644 arch/c6x/include/asm/bugs.h
 create mode 100644 arch/c6x/include/asm/byteorder.h
 create mode 100644 arch/c6x/include/asm/cache.h
 create mode 100644 arch/c6x/include/asm/cacheflush.h
 create mode 100644 arch/c6x/include/asm/checksum.h
 create mode 100644 arch/c6x/include/asm/clkdev.h
 create mode 100644 arch/c6x/include/asm/clock.h
 create mode 100644 arch/c6x/include/asm/cputime.h
 create mode 100644 arch/c6x/include/asm/current.h
 create mode 100644 arch/c6x/include/asm/delay.h
 create mode 100644 arch/c6x/include/asm/device.h
 create mode 100644 arch/c6x/include/asm/div64.h
 create mode 100644 arch/c6x/include/asm/dma-mapping.h
 create mode 100644 arch/c6x/include/asm/dma.h
 create mode 100644 arch/c6x/include/asm/elf.h
 create mode 100644 arch/c6x/include/asm/emergency-restart.h
 create mode 100644 arch/c6x/include/asm/errno.h
 create mode 100644 arch/c6x/include/asm/fb.h
 create mode 100644 arch/c6x/include/asm/fcntl.h
 create mode 100644 arch/c6x/include/asm/ftrace.h
 create mode 100644 arch/c6x/include/asm/futex.h
 create mode 100644 arch/c6x/include/asm/gemac.h
 create mode 100644 arch/c6x/include/asm/gmdio.h
 create mode 100644 arch/c6x/include/asm/hardirq.h
 create mode 100644 arch/c6x/include/asm/hardware.h
 create mode 100644 arch/c6x/include/asm/hw_irq.h
 create mode 100644 arch/c6x/include/asm/io.h
 create mode 100644 arch/c6x/include/asm/ioctl.h
 create mode 100644 arch/c6x/include/asm/ioctls.h
 create mode 100644 arch/c6x/include/asm/ipcbuf.h
 create mode 100644 arch/c6x/include/asm/irq.h
 create mode 100644 arch/c6x/include/asm/irq_regs.h
 create mode 100644 arch/c6x/include/asm/irqflags.h
 create mode 100644 arch/c6x/include/asm/kdebug.h
 create mode 100644 arch/c6x/include/asm/kmap_types.h
 create mode 100644 arch/c6x/include/asm/leds.h
 create mode 100644 arch/c6x/include/asm/linkage.h
 create mode 100644 arch/c6x/include/asm/local.h
 create mode 100644 arch/c6x/include/asm/mman.h
 create mode 100644 arch/c6x/include/asm/mmu.h
 create mode 100644 arch/c6x/include/asm/mmu_context.h
 create mode 100644 arch/c6x/include/asm/module.h
 create mode 100644 arch/c6x/include/asm/msgbuf.h
 create mode 100644 arch/c6x/include/asm/mutex.h
 create mode 100644 arch/c6x/include/asm/page.h
 create mode 100644 arch/c6x/include/asm/param.h
 create mode 100644 arch/c6x/include/asm/pci.h
 create mode 100644 arch/c6x/include/asm/percpu.h
 create mode 100644 arch/c6x/include/asm/pgalloc.h
 create mode 100644 arch/c6x/include/asm/pgtable.h
 create mode 100644 arch/c6x/include/asm/pll.h
 create mode 100644 arch/c6x/include/asm/pm.h
 create mode 100644 arch/c6x/include/asm/poll.h
 create mode 100644 arch/c6x/include/asm/posix_types.h
 create mode 100644 arch/c6x/include/asm/processor.h
 create mode 100644 arch/c6x/include/asm/procinfo.h
 create mode 100644 arch/c6x/include/asm/ptrace.h
 create mode 100644 arch/c6x/include/asm/resource.h
 create mode 100644 arch/c6x/include/asm/scatterlist.h
 create mode 100644 arch/c6x/include/asm/sections.h
 create mode 100644 arch/c6x/include/asm/segment.h
 create mode 100644 arch/c6x/include/asm/sembuf.h
 create mode 100644 arch/c6x/include/asm/serial.h
 create mode 100644 arch/c6x/include/asm/setup.h
 create mode 100644 arch/c6x/include/asm/sgmii.h
 create mode 100644 arch/c6x/include/asm/shmbuf.h
 create mode 100644 arch/c6x/include/asm/shmparam.h
 create mode 100644 arch/c6x/include/asm/sigcontext.h
 create mode 100644 arch/c6x/include/asm/siginfo.h
 create mode 100644 arch/c6x/include/asm/signal.h
 create mode 100644 arch/c6x/include/asm/socket.h
 create mode 100644 arch/c6x/include/asm/sockios.h
 create mode 100644 arch/c6x/include/asm/stat.h
 create mode 100644 arch/c6x/include/asm/statfs.h
 create mode 100644 arch/c6x/include/asm/string.h
 create mode 100644 arch/c6x/include/asm/swab.h
 create mode 100644 arch/c6x/include/asm/syscalls.h
 create mode 100644 arch/c6x/include/asm/system.h
 create mode 100644 arch/c6x/include/asm/termbits.h
 create mode 100644 arch/c6x/include/asm/termios.h
 create mode 100644 arch/c6x/include/asm/thread_info.h
 create mode 100644 arch/c6x/include/asm/timer.h
 create mode 100644 arch/c6x/include/asm/timex.h
 create mode 100644 arch/c6x/include/asm/tlb.h
 create mode 100644 arch/c6x/include/asm/tlbflush.h
 create mode 100644 arch/c6x/include/asm/topology.h
 create mode 100644 arch/c6x/include/asm/traps.h
 create mode 100644 arch/c6x/include/asm/types.h
 create mode 100644 arch/c6x/include/asm/uaccess.h
 create mode 100644 arch/c6x/include/asm/ucontext.h
 create mode 100644 arch/c6x/include/asm/unaligned.h
 create mode 100644 arch/c6x/include/asm/unistd.h
 create mode 100644 arch/c6x/include/asm/user.h
 create mode 100644 arch/c6x/include/asm/vga.h

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
new file mode 100644
index 0000000..b200fda
--- /dev/null
+++ b/arch/c6x/include/asm/Kbuild
@@ -0,0 +1,2 @@
+include include/asm-generic/Kbuild.asm
+
diff --git a/arch/c6x/include/asm/asm-offsets.h b/arch/c6x/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/c6x/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/c6x/include/asm/atomic.h b/arch/c6x/include/asm/atomic.h
new file mode 100644
index 0000000..d995e0e
--- /dev/null
+++ b/arch/c6x/include/asm/atomic.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_ATOMIC_H
+#define _ASM_C6X_ATOMIC_H
+
+#include <asm-generic/atomic.h>
+
+#endif /* _ASM_C6X_ATOMIC_H */
diff --git a/arch/c6x/include/asm/auxvec.h b/arch/c6x/include/asm/auxvec.h
new file mode 100644
index 0000000..8d881e6
--- /dev/null
+++ b/arch/c6x/include/asm/auxvec.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_AUXVEC_H
+#define _ASM_C6X_AUXVEC_H
+
+#include <asm-generic/auxvec.h>
+
+#endif /* _ASM_C6X_AUXVEC_H */
diff --git a/arch/c6x/include/asm/bitops.h b/arch/c6x/include/asm/bitops.h
new file mode 100644
index 0000000..c7391b4
--- /dev/null
+++ b/arch/c6x/include/asm/bitops.h
@@ -0,0 +1,181 @@
+/*
+ *  linux/include/asm-c6x/bitops.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_BITOPS_H
+#define _ASM_C6X_BITOPS_H
+
+#ifdef __KERNEL__
+
+#include <linux/bitops.h>
+
+#include <asm/system.h>
+#include <asm/byteorder.h>
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit() barrier()
+#define smp_mb__after_clear_bit()  barrier()
+
+static inline void set_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *a = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*a |= mask;
+	local_irq_restore(flags);
+}
+
+static inline void clear_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *a = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*a &= ~mask;
+	local_irq_restore(flags);
+}
+
+static inline void change_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *a = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*a ^= mask;
+	local_irq_restore(flags);
+}
+
+static inline int test_and_set_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *a = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long flags;
+	int retval;
+
+	local_irq_save(flags);
+	retval = (mask & *a) != 0;
+	*a |= mask;
+	local_irq_restore(flags);
+	return retval;
+}
+
+static inline int test_and_clear_bit(int nr, volatile void *addr)
+{
+	unsigned long *a = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = (mask & *a) != 0;
+	*a &= ~mask;
+	local_irq_restore(flags);
+	return retval;
+}
+
+static inline int test_and_change_bit(int nr, volatile void *addr)
+{
+	unsigned long *a = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long flags;
+	int retval;
+
+	local_irq_save(flags);
+	retval = (mask & *a) != 0;
+	*a ^= mask;
+	local_irq_restore(flags);
+	return retval;
+}
+
+/*
+ * We are lucky, DSP is perfect for bitops: do it in 3 cycles
+ */
+
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ * Note __ffs(0) = undef, __ffs(1) = 0, __ffs(0x80000000) = 31.
+ *
+ */
+static inline unsigned long __ffs(unsigned long x)
+{
+	asm (" bitr  .M1  %0,%0\n"
+	     " nop\n"
+	     " lmbd  .L1  1,%0,%0\n"
+	     : "+a"(x));
+
+	return x;
+}
+
+/*
+ * ffz - find first zero in word.
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+#define ffz(x) __ffs(~(x))
+
+/**
+ * fls - find last (most-significant) bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs.
+ * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
+ */
+static inline int fls(int x)
+{
+	if (!x)
+		return 0;
+
+	asm (" lmbd  .L1  1,%0,%0\n" : "+a"(x));
+
+	return 32 - x;
+}
+
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz (man ffs).
+ * Note ffs(0) = 0, ffs(1) = 1, ffs(0x80000000) = 32.
+ */
+static inline int ffs(int x)
+{
+	if (!x)
+		return 0;
+
+	return __ffs(x) + 1;
+}
+
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/find.h>
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+#include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_C6X_BITOPS_H */
diff --git a/arch/c6x/include/asm/bitsperlong.h b/arch/c6x/include/asm/bitsperlong.h
new file mode 100644
index 0000000..2cd2b80
--- /dev/null
+++ b/arch/c6x/include/asm/bitsperlong.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_BITSPERLONG_H
+#define _ASM_C6X_BITSPERLONG_H
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* _ASM_C6X_BITSPERLONG_H */
diff --git a/arch/c6x/include/asm/bug.h b/arch/c6x/include/asm/bug.h
new file mode 100644
index 0000000..6dbbb6e
--- /dev/null
+++ b/arch/c6x/include/asm/bug.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_BUG_H
+#define _ASM_C6X_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif /* _ASM_C6X_BUG_H */
diff --git a/arch/c6x/include/asm/bugs.h b/arch/c6x/include/asm/bugs.h
new file mode 100644
index 0000000..c810e54
--- /dev/null
+++ b/arch/c6x/include/asm/bugs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_BUGS_H
+#define _ASM_C6X_BUGS_H
+
+#include <asm-generic/bugs.h>
+
+#endif /* _ASM_C6X_BUGS_H */
diff --git a/arch/c6x/include/asm/byteorder.h b/arch/c6x/include/asm/byteorder.h
new file mode 100644
index 0000000..166038d
--- /dev/null
+++ b/arch/c6x/include/asm/byteorder.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_C6X_BYTEORDER_H
+#define _ASM_C6X_BYTEORDER_H
+
+#include <asm/types.h>
+
+#ifdef _BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
+#else /* _BIG_ENDIAN */
+#include <linux/byteorder/little_endian.h>
+#endif /* _BIG_ENDIAN */
+
+#endif /* _ASM_BYTEORDER_H */
diff --git a/arch/c6x/include/asm/cache.h b/arch/c6x/include/asm/cache.h
new file mode 100644
index 0000000..00f66a6
--- /dev/null
+++ b/arch/c6x/include/asm/cache.h
@@ -0,0 +1,373 @@
+/*
+ *  linux/include/asm-c6x/cache.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2005, 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_CACHE_H
+#define _ASM_C6X_CACHE_H
+
+#include <linux/irqflags.h>
+#include <asm/hardware.h>
+#include <mach/cache.h>
+
+/*
+ * Current C6x architecture does not support hw cache coherency
+ */
+#define arch_is_coherent()    0
+
+/*
+ * For practical reasons the L1_CACHE_BYTES defines should not be smaller than
+ * the L2 line size
+ */
+#define L1_CACHE_BYTES        L2_CACHE_BYTES
+
+#define L2_CACHE_ALIGN_LOW(x) \
+	(((x) & ~(L2_CACHE_BYTES - 1)))
+#define L2_CACHE_ALIGN_UP(x) \
+	(((x) + (L2_CACHE_BYTES - 1)) & ~(L2_CACHE_BYTES - 1))
+#define L2_CACHE_ALIGN_CNT(x) \
+	(((x) + (sizeof(int) - 1)) & ~(sizeof(int) - 1))
+
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+#define ARCH_SLAB_MINALIGN	L1_CACHE_BYTES
+
+/*
+ * Align a physical address to MAR regions
+ */
+#define CACHE_REGION_START(v) (((u32) (v)) & ~(IMCR_MAR_SIZE - 1))
+#define CACHE_REGION_END(v)   (((u32) (v) + (IMCR_MAR_SIZE - 1)) & ~(IMCR_MAR_SIZE - 1))
+
+/*
+ * CCFG register values and bits
+ */
+#define L2MODE_0K_CACHE   0x0
+#define L2MODE_32K_CACHE  0x1
+#define L2MODE_64K_CACHE  0x2
+#define L2MODE_128K_CACHE 0x3
+#define L2MODE_256K_CACHE 0x7
+
+#define L2PRIO_URGENT     0x0
+#define L2PRIO_HIGH       0x1
+#define L2PRIO_MEDIUM     0x2
+#define L2PRIO_LOW        0x3
+
+#define CCFG_ID           0x100   /* Invalidate L1P bit */
+#define CCFG_IP           0x200   /* Invalidate L1D bit */
+
+/*
+ * L1 & L2 caches generic functions
+ */
+#define imcr_get(reg)	(*((volatile unsigned int *) (reg)))
+#define imcr_set(reg, value)					\
+	do {							\
+		*((volatile unsigned int *) (reg)) = (value);	\
+		(value) = *((volatile unsigned int *) (reg));	\
+	} while (0)
+
+/*
+ * Generic function to perform a block cache operation as
+ * invalidate or writeback/invalidate
+ */
+static inline void cache_block_operation(unsigned int *start,
+					 unsigned int *end,
+					 unsigned int bar_reg,
+					 unsigned int wc_reg)
+{
+	unsigned long flags;
+	unsigned int wcnt =
+		(L2_CACHE_ALIGN_CNT((unsigned int) end)
+		 - L2_CACHE_ALIGN_LOW((unsigned int) start)) >> 2;
+	unsigned int wc = 0;
+
+	for (; wcnt; wcnt -= wc, start += wc) {
+loop:
+		local_irq_save(flags);
+
+		/*
+		 * If another cache operation is occuring
+		 */
+		if (unlikely(*((volatile unsigned int *) wc_reg))) {
+			local_irq_restore(flags);
+
+			/* Wait for previous operation completion */
+			while (*((volatile unsigned int *) wc_reg))
+				;
+
+			/* Try again */
+			goto loop;
+		}
+
+		*((volatile unsigned int *) bar_reg) =
+			L2_CACHE_ALIGN_LOW((unsigned int) start);
+
+		if (wcnt > 0xffff)
+			wc = 0xffff;
+		else
+			wc = wcnt;
+
+		/* Set word count value in the WC register */
+		*((volatile unsigned int *) wc_reg) = wc & 0xffff;
+
+		local_irq_restore(flags);
+
+		/* Wait for completion */
+		while (*((volatile unsigned int *) wc_reg))
+			;
+	}
+}
+
+static inline void cache_block_operation_nowait(unsigned int *start,
+						unsigned int *end,
+						unsigned int bar_reg,
+						unsigned int wc_reg)
+{
+	unsigned long flags;
+	unsigned int wcnt =
+		(L2_CACHE_ALIGN_CNT((unsigned int) end)
+		 - L2_CACHE_ALIGN_LOW((unsigned int) start)) >> 2;
+	unsigned int wc = 0;
+
+	for (; wcnt; wcnt -= wc, start += wc) {
+
+		local_irq_save(flags);
+
+		*((volatile unsigned int *) bar_reg) =
+			L2_CACHE_ALIGN_LOW((unsigned int) start);
+
+		if (wcnt > 0xffff)
+			wc = 0xffff;
+		else
+			wc = wcnt;
+
+		/* Set word count value in the WC register */
+		*((volatile unsigned int *) wc_reg) = wc & 0xffff;
+
+		local_irq_restore(flags);
+
+		/* Don't wait for completion on last cache operation */
+		if (wcnt > 0xffff)
+			while (*((volatile unsigned int *) wc_reg))
+				;
+	}
+}
+
+static inline void cache_block_operation_wait(unsigned int wc_reg)
+{
+	/* Wait for completion */
+	while (*((volatile unsigned int *) wc_reg))
+		;
+}
+
+/*
+ * L1 caches management
+ */
+
+/*
+ * Disable L1 caches
+ */
+static inline void L1_cache_off(void)
+{
+	unsigned int cfg = 0;
+	imcr_set(IMCR_L1PCFG, cfg);
+	imcr_set(IMCR_L1DCFG, cfg);
+}
+
+/*
+ * Enable L1 caches
+ */
+static inline void L1_cache_on(void)
+{
+	unsigned int cfg = 7;
+	imcr_set(IMCR_L1PCFG, cfg);
+	imcr_set(IMCR_L1DCFG, cfg);
+}
+
+/*
+ *  L1P global-invalidate all
+ */
+static inline void L1P_cache_global_invalidate(void)
+{
+	unsigned int set = 1;
+	imcr_set(IMCR_L1PINV, set);
+	while (imcr_get(IMCR_L1PINV) & 1)
+		;
+}
+
+/*
+ *  L1D global-invalidate all
+ *
+ * Warning: this operation causes all updated data in L1D to
+ * be discarded rather than written back to the lower levels of
+ * memory
+ */
+static inline void L1D_cache_global_invalidate(void)
+{
+	unsigned int set = 1;
+	imcr_set(IMCR_L1DINV, set);
+	while (imcr_get(IMCR_L1DINV) & 1)
+		;
+}
+
+static inline void L1D_cache_global_writeback(void)
+{
+	unsigned int set = 1;
+	imcr_set(IMCR_L1DWB, set);
+	while (imcr_get(IMCR_L1DWB) & 1)
+		;
+}
+
+static inline void L1D_cache_global_writeback_invalidate(void)
+{
+	unsigned int set = 1;
+	imcr_set(IMCR_L1DWBINV, set);
+	while (imcr_get(IMCR_L1DWBINV) & 1)
+		;
+}
+
+/*
+ *  L1 block operations
+ */
+#define L1P_cache_block_invalidate(start, end)             \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L1PIBAR, IMCR_L1PIWC)
+
+#define L1D_cache_block_invalidate(start, end)		   \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L1DIBAR, IMCR_L1DIWC)
+
+#define L1D_cache_block_writeback_invalidate(start, end)   \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L1DWIBAR, IMCR_L1DWIWC)
+
+#define L1D_cache_block_writeback(start, end)		   \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L1DWBAR, IMCR_L1DWWC)
+
+#ifdef CONFIG_TMS320C6X_CACHES_ON
+/*
+ * L2 caches management
+ */
+
+/*
+ * Set L2 operation mode
+ */
+static inline void L2_cache_set_mode(unsigned int mode)
+{
+	unsigned int ccfg = imcr_get(IMCR_CCFG);
+
+	/* Clear and set the L2MODE bits in CCFG */
+	ccfg &= ~7;
+	ccfg |= (mode & 7);
+	imcr_set(IMCR_CCFG, ccfg);
+}
+
+/*
+ *  L2 global-writeback and global-invalidate all
+ */
+static inline void L2_cache_global_writeback_invalidate(void)
+{
+	*((volatile unsigned int *) (IMCR_L2WBINV)) = 1;
+	while (*((volatile unsigned int *) (IMCR_L2WBINV)))
+		;
+}
+
+/*
+ *  L2 global-writeback all
+ */
+static inline void L2_cache_global_writeback(void)
+{
+	*((volatile unsigned int *) (IMCR_L2WB)) = 1;
+	while (*((volatile unsigned int *) (IMCR_L2WB)))
+		;
+}
+
+/*
+ *  L2 block operations
+ */
+#define L2_cache_block_invalidate(start, end)              \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L2IBAR, IMCR_L2IWC)
+
+#define L2_cache_block_writeback(start, end)		   \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L2WBAR, IMCR_L2WWC)
+
+#define L2_cache_block_writeback_invalidate(start, end)	   \
+	cache_block_operation((unsigned int *) (start),	   \
+			      (unsigned int *) (end),	   \
+			      IMCR_L2WIBAR, IMCR_L2WIWC)
+
+#define L2_cache_block_invalidate_nowait(start, end)		  \
+	cache_block_operation_nowait((unsigned int *) (start),	  \
+				     (unsigned int *) (end),	  \
+				     IMCR_L2IBAR, IMCR_L2IWC)
+
+#define L2_cache_block_invalidate_wait()	      \
+	cache_block_operation_wait(IMCR_L2IWC)
+
+#define L2_cache_block_writeback_nowait(start, end)		  \
+	cache_block_operation_nowait((unsigned int *) (start),	  \
+				     (unsigned int *) (end),	  \
+				     IMCR_L2WBAR, IMCR_L2WWC)
+
+#define L2_cache_block_writeback_wait()		      \
+	cache_block_operation_wait(IMCR_L2WWC)
+
+#define L2_cache_block_writeback_invalidate_nowait(start, end)	  \
+	cache_block_operation_nowait((unsigned int *) (start),	  \
+				     (unsigned int *) (end),	  \
+				     IMCR_L2WIBAR, IMCR_L2WIWC)
+
+#define L2_cache_block_writeback_invalidate_wait()    \
+	cache_block_operation_wait(IMCR_L2WIWC)
+
+/*
+ * Cacheability controls
+ */
+static inline void enable_caching(unsigned long start, unsigned long end)
+{
+	unsigned int *mar = (unsigned int *) IMCR_MAR_BASE + (start >> 24);
+	unsigned int *mar_e = (unsigned int *) IMCR_MAR_BASE + (end >> 24);
+
+	for (; mar <= mar_e; mar++)
+		*mar |= 1;
+}
+
+static inline void disable_caching(unsigned long start, unsigned long end)
+{
+	unsigned int *mar = (unsigned int *) IMCR_MAR_BASE + (start >> 24);
+	unsigned int *mar_e = (unsigned int *) IMCR_MAR_BASE + (end >> 24);
+
+	for (; mar <= mar_e; mar++)
+		*mar &= ~1;
+}
+
+#else /* CONFIG_TMS320C6X_CACHES_ON */
+#define L2_cache_set_mode(mode)
+#define L2_cache_global_writeback_invalidate()
+#define L2_cache_global_writeback()
+#define L2_cache_block_invalidate(start, end)
+#define L2_cache_block_writeback(start, end)
+#define L2_cache_block_writeback_invalidate(start, end)
+#define L2_cache_block_invalidate_nowait(start, end)
+#define L2_cache_block_invalidate_wait()
+#define L2_cache_block_writeback_nowait(start, end)
+#define L2_cache_block_writeback_wait()
+#define L2_cache_block_writeback_invalidate_nowait(start, end)
+#define L2_cache_block_writeback_invalidate_wait()
+
+#endif /* CONFIG_TMS320C6X_CACHES_ON */
+#endif /* _ASM_C6X_CACHE_H */
diff --git a/arch/c6x/include/asm/cacheflush.h b/arch/c6x/include/asm/cacheflush.h
new file mode 100644
index 0000000..f56fa4c
--- /dev/null
+++ b/arch/c6x/include/asm/cacheflush.h
@@ -0,0 +1,67 @@
+/*
+ *  linux/include/asm-c6x/pgalloc.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_CACHEFLUSH_H
+#define _ASM_C6X_CACHEFLUSH_H
+
+#include <linux/spinlock.h>
+
+#include <asm/setup.h>
+#include <asm/cache.h>
+#include <asm/mman.h>
+#include <asm/page.h>
+#include <asm/string.h>
+
+/*
+ * virtually-indexed cache management (our cache is physically indexed)
+ */
+#define flush_cache_all()			do {} while (0)
+#define flush_cache_mm(mm)			do {} while (0)
+#define flush_cache_dup_mm(mm)			do {} while (0)
+#define flush_cache_range(mm, start, end)	do {} while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do {} while (0)
+#define flush_cache_vmap(start, end)		do {} while (0)
+#define flush_cache_vunmap(start, end)		do {} while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
+#define flush_dcache_page(page)			do {} while (0)
+#define flush_dcache_mmap_lock(mapping)		do {} while (0)
+#define flush_dcache_mmap_unlock(mapping)	do {} while (0)
+
+/*
+ * physically-indexed cache management
+ */
+#define flush_icache_range(s, e)				  \
+	do {							  \
+		L1D_cache_block_writeback((s), (e));		  \
+		L1P_cache_block_invalidate((s), (e));		  \
+	} while (0)
+
+#define flush_icache_page(vma, page)					  \
+do {								  \
+	if ((vma)->vm_flags & PROT_EXEC)				  \
+		L1D_cache_block_writeback_invalidate(page_address(page),  \
+			(unsigned long) page_address(page) + PAGE_SIZE)); \
+		L1P_cache_block_invalidate(page_address(page),		  \
+			(unsigned long) page_address(page) + PAGE_SIZE)); \
+} while (0)
+
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+do {						     \
+	memcpy(dst, src, len);			     \
+	flush_icache_range((unsigned) (dst), (unsigned) (dst) + (len)); \
+} while (0)
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+#endif /* _ASM_C6X_CACHEFLUSH_H */
diff --git a/arch/c6x/include/asm/checksum.h b/arch/c6x/include/asm/checksum.h
new file mode 100644
index 0000000..9813a80
--- /dev/null
+++ b/arch/c6x/include/asm/checksum.h
@@ -0,0 +1,116 @@
+/*
+ *  linux/include/asm-c6x/checksum.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_CHECKSUM_H
+#define _ASM_C6X_CHECKSUM_H
+
+#include <asm/byteorder.h>
+
+/*
+ * Computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+extern __wsum csum_partial(const void *buff, int len, __wsum sum);
+
+/*
+ * The same as csum_partial, but copies from src while it checksums
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern __wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum);
+
+/*
+ * This is a new version of the above that records errors it finds in *errp,
+ * but continues and zeros the rest of the buffer.
+ */
+#define csum_partial_copy_nocheck csum_partial_copy
+
+/*
+ * The same as csum_partial_copy, but copies from user space.
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+#define csum_partial_copy_from_user(src, dst, len, sum, err_ptr) \
+	csum_partial_copy(src, dst, len, sum)
+
+/*
+ * This is a version of ip_compute_csum() optimized for IP headers,
+ * which always checksum on 4 octet boundaries.
+ *
+ */
+extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+
+/*
+ * Fold a partial checksum
+ */
+static inline __sum16 csum_fold(__wsum csum)
+{
+	u32 sum = (u32)csum;
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return (__sum16)~sum;
+}
+
+/*
+ * Computes the checksum of the TCP/UDP pseudo-header
+ */
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	unsigned long long s = (__force u32)sum;
+
+	s += (__force u32)saddr;
+	s += (__force u32)daddr;
+#ifdef _BIG_ENDIAN
+	s += proto + len;
+#else
+	s += (proto + len) << 8;
+#endif
+	s += (s >> 32);
+
+	return (__force __wsum)s;
+}
+
+/*
+ * Computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+/*
+ * This routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+static inline __sum16
+ip_compute_csum(const void *buff, int len)
+{
+	extern unsigned int do_csum(const unsigned char *, size_t);
+	return (__force __sum16)~do_csum(buff, len);
+}
+
+#endif /* _ASM_C6X_CHECKSUM_H */
diff --git a/arch/c6x/include/asm/clkdev.h b/arch/c6x/include/asm/clkdev.h
new file mode 100644
index 0000000..aff359c
--- /dev/null
+++ b/arch/c6x/include/asm/clkdev.h
@@ -0,0 +1,45 @@
+/*
+ *  arch/c6x/include/asm/clkdev.h
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  Original code from: arch/arm/include/asm/clkdev.h
+ *
+ *  Copyright (C) 2008 Russell King.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper for the clk API to assist looking up a struct clk.
+ */
+#ifndef _ASM_CLKDEV_H
+#define _ASM_CLKDEV_H
+
+struct clk;
+struct device;
+
+struct clk_lookup {
+	struct list_head	node;
+	const char		*dev_id;
+	const char		*con_id;
+	struct clk		*clk;
+};
+
+struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
+	const char *dev_fmt, ...);
+
+void clkdev_add(struct clk_lookup *cl);
+void clkdev_drop(struct clk_lookup *cl);
+
+void clkdev_add_table(struct clk_lookup *, size_t);
+int clk_add_alias(const char *, const char *, char *, struct device *);
+
+int __clk_get(struct clk *clk);
+void __clk_put(struct clk *clk);
+
+int clk_register(struct clk *clk);
+void clk_unregister(struct clk *clk);
+
+#endif /* _ASM_CLKDEV_H */
diff --git a/arch/c6x/include/asm/clock.h b/arch/c6x/include/asm/clock.h
new file mode 100644
index 0000000..d8f1a77
--- /dev/null
+++ b/arch/c6x/include/asm/clock.h
@@ -0,0 +1,73 @@
+/*
+ * TI C64X clock definitions
+ *
+ * Copyright (C) 2010 Texas Instruments.
+ * Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ * Copied heavily from arm/mach-davinci/clock.h, so:
+ *
+ * Copyright (C) 2006-2007 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_C6X_CLOCK_H
+#define _ASM_C6X_CLOCK_H
+
+#include <mach/pll.h>
+
+#ifndef __ASSEMBLER__
+
+#include <linux/list.h>
+#include <asm/clkdev.h>
+
+struct pll_data {
+	u32 phys_base;
+	void __iomem *base;
+	u32 num;
+	u32 flags;
+	u32 input_rate;
+};
+#define PLL_HAS_PREDIV		0x01
+
+struct clk {
+	struct list_head	node;
+	struct module		*owner;
+	const char		*name;
+	unsigned long		rate;
+	int			usecount;
+	u32			flags;
+	struct clk		*parent;
+	struct list_head	children;	/* list of children */
+	struct list_head	childnode;	/* parent's child list node */
+	struct pll_data		*pll_data;
+	u32			div;
+	unsigned long (*recalc) (struct clk *);
+	int (*set_rate) (struct clk *clk, unsigned long rate);
+	int (*round_rate) (struct clk *clk, unsigned long rate);
+};
+
+/* Clock flags: SoC-specific flags start at BIT(16) */
+#define ALWAYS_ENABLED		BIT(1)
+#define CLK_PLL			BIT(2) /* PLL-derived clock */
+#define PRE_PLL			BIT(3) /* source is before PLL mult/div */
+#define FIXED_DIV_PLL		BIT(4) /* fixed divisor from PLL */
+#define FIXED_RATE_PLL		BIT(5) /* fixed ouput rate PLL */
+
+#define CLK(dev, con, ck)	\
+	{			\
+		.dev_id = dev,	\
+		.con_id = con,	\
+		.clk = ck,	\
+	}			\
+
+int c6x_clk_init(struct clk_lookup *clocks);
+int c6x_set_pllrate(struct pll_data *pll, unsigned int prediv,
+		    unsigned int mult);
+
+#endif
+
+#endif /* _ASM_C6X_CLOCK_H */
diff --git a/arch/c6x/include/asm/cputime.h b/arch/c6x/include/asm/cputime.h
new file mode 100644
index 0000000..e352391
--- /dev/null
+++ b/arch/c6x/include/asm/cputime.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_CPUTIME_H
+#define _ASM_C6X_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* _ASM_C6X_CPUTIME_H */
diff --git a/arch/c6x/include/asm/current.h b/arch/c6x/include/asm/current.h
new file mode 100644
index 0000000..7841d42
--- /dev/null
+++ b/arch/c6x/include/asm/current.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_CURRENT_H
+#define _ASM_C6X_CURRENT_H
+
+#include <asm-generic/current.h>
+
+#endif /* _ASM_C6X_CURRENT_H */
diff --git a/arch/c6x/include/asm/delay.h b/arch/c6x/include/asm/delay.h
new file mode 100644
index 0000000..d18f3b8
--- /dev/null
+++ b/arch/c6x/include/asm/delay.h
@@ -0,0 +1,69 @@
+/*
+ *  linux/include/asm-c6x/delay.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_DELAY_H
+#define _ASM_C6X_DELAY_H
+
+#include <linux/kernel.h>
+
+extern unsigned int ticks_per_ns_scaled;
+
+static inline void __delay(unsigned long loops)
+{
+	uint32_t tmp;
+
+	/* 6 cycles per loop */
+	asm volatile ("        mv    .s1  %0,%1\n"
+		      "0: [%1] b     .s1  0b\n"
+		      "        add   .l1  -6,%0,%0\n"
+		      "        cmplt .l1  1,%0,%1\n"
+		      "        nop   3\n"
+		      : "+a"(loops), "=A"(tmp));
+}
+
+static inline void _c6x_tickdelay(unsigned int x)
+{
+	uint32_t cnt, endcnt;
+
+	asm volatile ("        mvc   .s2   TSCL,%0\n"
+		      "        add   .s2x  %0,%1,%2\n"
+		      " ||     mvk   .l2   1,B0\n"
+		      "0: [B0] b     .s2   0b\n"
+		      "        mvc   .s2   TSCL,%0\n"
+		      "        sub   .s2   %0,%2,%0\n"
+		      "        cmpgt .l2   0,%0,B0\n"
+		      "        nop   2\n"
+		      : "=b"(cnt), "+a"(x), "=b"(endcnt) : : "B0");
+}
+
+/* use scaled math to avoid slow division */
+#define C6X_NDELAY_SCALE 10
+
+static inline void _ndelay(unsigned int n)
+{
+	_c6x_tickdelay((ticks_per_ns_scaled * n) >> C6X_NDELAY_SCALE);
+}
+
+static inline void _udelay(unsigned int n)
+{
+	while (n >= 10) {
+		_ndelay(10000);
+		n -= 10;
+	}
+	while (n-- > 0)
+		_ndelay(1000);
+}
+
+#define udelay(x) _udelay((unsigned int)(x))
+#define ndelay(x) _ndelay((unsigned int)(x))
+
+#endif /* _ASM_C6X_DELAY_H */
diff --git a/arch/c6x/include/asm/device.h b/arch/c6x/include/asm/device.h
new file mode 100644
index 0000000..0313e82
--- /dev/null
+++ b/arch/c6x/include/asm/device.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_DEVICE_H
+#define _ASM_C6X_DEVICE_H
+
+#include <asm-generic/device.h>
+
+#endif /* _ASM_C6X_DEVICE_H */
diff --git a/arch/c6x/include/asm/div64.h b/arch/c6x/include/asm/div64.h
new file mode 100644
index 0000000..46943e6
--- /dev/null
+++ b/arch/c6x/include/asm/div64.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_DIV64_H
+#define _ASM_C6X_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* _ASM_C6X_DIV64_H */
diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
new file mode 100644
index 0000000..52aa79b
--- /dev/null
+++ b/arch/c6x/include/asm/dma-mapping.h
@@ -0,0 +1,302 @@
+/*
+ *  linux/arch/c6x/include/asm/dma-mapping.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot <aurelien.jacquiot@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#ifndef _ASM_C6X_DMA_MAPPING_H
+#define _ASM_C6X_DMA_MAPPING_H
+
+#ifdef __KERNEL__
+
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/scatterlist.h>
+
+#include <asm/io.h>
+#include <asm/types.h>
+#include <asm-generic/dma-coherent.h>
+
+#define dma_supported(d, m)	    (1)
+
+#define __pfn_to_bus(pfn)	   ((pfn) << PAGE_SHIFT)
+#define __bus_to_pfn(paddr)	   ((paddr) >> PAGE_SHIFT)
+#define __bus_to_phys(x)	   (x)
+#define __phys_to_bus(x)	   (x)
+#define __bus_to_virt(b)	   phys_to_virt(__bus_to_phys(b))
+#define __virt_to_bus(v)	   __phys_to_bus(virt_to_phys(v))
+
+/*
+ * page_to_dma/dma_to_virt/virt_to_dma are architecture private functions
+ * used internally by the DMA-mapping API to provide DMA addresses. They
+ * must not be used by drivers.
+ */
+static inline dma_addr_t page_to_dma(struct device *dev, struct page *page)
+{
+	return (dma_addr_t)__pfn_to_bus(page_to_pfn(page));
+}
+
+static inline struct page *dma_to_page(struct device *dev, dma_addr_t addr)
+{
+	return pfn_to_page(__bus_to_pfn(addr));
+}
+
+static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
+{
+	return (void *)__bus_to_virt(addr);
+}
+
+static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
+{
+	return (dma_addr_t)__virt_to_bus(addr);
+}
+
+static inline int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
+			     enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+	BUG_ON(direction == DMA_NONE);
+
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = sg_phys(sg);
+	}
+
+	return nents;
+}
+
+static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+				enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
+
+extern int __dma_is_coherent(struct device *dev, dma_addr_t handle);
+
+static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
+{
+	if (arch_is_coherent() || __dma_is_coherent(dev, handle))
+		return 1;
+	else
+		return 0;
+}
+
+/*
+ * DMA errors are defined by all-bits-set in the DMA address.
+ */
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return dma_addr == ~0;
+}
+
+/**
+ * dma_alloc_coherent - allocate consistent memory for DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @size: required memory size
+ * @handle: bus-specific DMA address
+ *
+ * Allocate some uncached, unbuffered memory for a device for
+ * performing DMA.  This function allocates pages, and will
+ * return the CPU-viewed address, and sets @handle to be the
+ * device-viewed address.
+ */
+extern void *dma_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
+
+/**
+ * dma_free_coherent - free memory allocated by dma_alloc_coherent
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @size: size of memory originally requested in dma_alloc_coherent
+ * @cpu_addr: CPU-view address returned from dma_alloc_coherent
+ * @handle: device-view address returned from dma_alloc_coherent
+ *
+ * Free (and unmap) a DMA buffer previously allocated by
+ * dma_alloc_coherent().
+ *
+ * References to memory and mappings associated with cpu_addr/handle
+ * during and after this call executing are illegal.
+ */
+extern void dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
+#define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
+
+extern void __dma_single_cpu_to_dev(const void *kaddr, size_t size,
+				    enum dma_data_direction dir);
+
+extern void __dma_single_dev_to_cpu(const void *kaddr, size_t size,
+				    enum dma_data_direction dir);
+
+extern void __dma_page_cpu_to_dev(struct page *page, unsigned long off,
+				  size_t size, enum dma_data_direction dir);
+
+extern void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
+				  size_t size, enum dma_data_direction dir);
+
+/**
+ * dma_map_single - map a single buffer for streaming DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @cpu_addr: CPU direct mapped address of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Ensure that any data held in the cache is appropriately discarded
+ * or written back.
+ *
+ * The device owns this memory once this call has completed.  The CPU
+ * can regain ownership by calling dma_unmap_single() or
+ * dma_sync_single_for_cpu().
+ */
+static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
+		size_t size, enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+
+	__dma_single_cpu_to_dev(cpu_addr, size, dir);
+
+	return virt_to_dma(dev, cpu_addr);
+}
+
+/**
+ * dma_map_page - map a portion of a page for streaming DMA
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @page: page that buffer resides in
+ * @offset: offset into page for start of buffer
+ * @size: size of buffer to map
+ * @dir: DMA transfer direction
+ *
+ * Ensure that any data held in the cache is appropriately discarded
+ * or written back.
+ *
+ * The device owns this memory once this call has completed.  The CPU
+ * can regain ownership by calling dma_unmap_page().
+ */
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+
+	__dma_page_cpu_to_dev(page, offset, size, dir);
+
+	return page_to_dma(dev, page) + offset;
+}
+
+/**
+ * dma_unmap_single - unmap a single buffer previously mapped
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer (same as passed to dma_map_single)
+ * @dir: DMA transfer direction (same as passed to dma_map_single)
+ *
+ * Unmap a single streaming mode DMA translation.  The handle and size
+ * must match what was provided in the previous dma_map_single() call.
+ * All other usages are undefined.
+ *
+ * After this call, reads by the CPU to the buffer are guaranteed to see
+ * whatever the device wrote there.
+ */
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t handle,
+		 size_t size, enum dma_data_direction dir)
+{
+	__dma_single_dev_to_cpu(dma_to_virt(dev, handle), size, dir);
+}
+
+/**
+ * dma_unmap_page - unmap a buffer previously mapped through dma_map_page()
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @size: size of buffer (same as passed to dma_map_page)
+ * @dir: DMA transfer direction (same as passed to dma_map_page)
+ *
+ * Unmap a page streaming mode DMA translation.  The handle and size
+ * must match what was provided in the previous dma_map_page() call.
+ * All other usages are undefined.
+ *
+ * After this call, reads by the CPU to the buffer are guaranteed to see
+ * whatever the device wrote there.
+ */
+static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
+{
+	__dma_page_dev_to_cpu(dma_to_page(dev, handle), handle & ~PAGE_MASK,
+		size, dir);
+}
+
+/**
+ * dma_sync_single_range_for_cpu
+ * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
+ * @handle: DMA address of buffer
+ * @offset: offset of region to start sync
+ * @size: size of region to sync
+ * @dir: DMA transfer direction (same as passed to dma_map_single)
+ *
+ * Make physical memory consistent for a single streaming mode DMA
+ * translation after a transfer.
+ *
+ * If you perform a dma_map_single() but wish to interrogate the
+ * buffer using the cpu, yet do not wish to teardown the PCI dma
+ * mapping, you must call this function before doing so.  At the
+ * next point you give the PCI dma address back to the card, you
+ * must first the perform a dma_sync_for_device, and then the
+ * device again owns the buffer.
+ */
+static inline void dma_sync_single_range_for_cpu(struct device *dev,
+		dma_addr_t handle, unsigned long offset, size_t size,
+		enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+
+	__dma_single_dev_to_cpu(dma_to_virt(dev, handle) + offset, size, dir);
+}
+
+static inline void dma_sync_single_range_for_device(struct device *dev,
+		dma_addr_t handle, unsigned long offset, size_t size,
+		enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+
+	__dma_single_cpu_to_dev(dma_to_virt(dev, handle) + offset, size, dir);
+}
+
+static inline void dma_sync_single_for_cpu(struct device *dev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	dma_sync_single_range_for_cpu(dev, handle, 0, size, dir);
+}
+
+static inline void dma_sync_single_for_device(struct device *dev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	dma_sync_single_range_for_device(dev, handle, 0, size, dir);
+}
+
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents,
+		    enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+}
+
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nents,
+		    enum dma_data_direction dir)
+{
+	BUG_ON(!valid_dma_direction(dir));
+}
+
+extern int coherent_mem_init(void);
+extern unsigned long dma_memory_start;
+extern unsigned long dma_memory_size;
+
+#endif /* __KERNEL__ */
+#endif	/* _ASM_C6X_DMA_MAPPING_H */
diff --git a/arch/c6x/include/asm/dma.h b/arch/c6x/include/asm/dma.h
new file mode 100644
index 0000000..0431395
--- /dev/null
+++ b/arch/c6x/include/asm/dma.h
@@ -0,0 +1,25 @@
+/*
+ *  linux/include/asm-c6x/dma.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_DMA_H
+#define _ASM_C6X_DMA_H
+
+#define MAX_DMA_ADDRESS  0xFFFFFFFF
+#define MAX_DMA_CHANNELS 64
+
+/* Reserve a DMA channel */
+extern int request_dma(unsigned int dmanr, const char *device_id);
+
+/* Release it again */
+extern void free_dma(unsigned int dmanr);
+
+#endif /* _ASM_C6X_DMA_H */
diff --git a/arch/c6x/include/asm/elf.h b/arch/c6x/include/asm/elf.h
new file mode 100644
index 0000000..272c3ae
--- /dev/null
+++ b/arch/c6x/include/asm/elf.h
@@ -0,0 +1,115 @@
+/*
+ *  linux/include/asm-c6x/elf.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_ELF_H
+#define _ASM_C6X_ELF_H
+
+/*
+ * ELF register definitions..
+ */
+#include <asm/ptrace.h>
+
+typedef unsigned long elf_greg_t;
+typedef unsigned long elf_fpreg_t;
+
+#define ELF_NGREG  58
+#define ELF_NFPREG 1
+
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x) ((x)->e_machine == EM_TI_C6000)
+
+#define elf_check_const_displacement(x) (1)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#ifdef __LITTLE_ENDIAN__
+#define ELF_DATA	ELFDATA2LSB
+#else
+#define ELF_DATA	ELFDATA2MSB
+#endif
+
+#define ELF_CLASS	ELFCLASS32
+#define ELF_ARCH	EM_TI_C6000
+
+/* Nothing for now. Need to setup DP... */
+#define ELF_PLAT_INIT(_r)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE	4096
+
+#define ELF_CORE_COPY_REGS(_dest, _regs)		\
+	memcpy((char *) &_dest, (char *) _regs,		\
+	sizeof(struct pt_regs));
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.  */
+
+#define ELF_PLATFORM  (NULL)
+
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+
+/* C6X specific section types */
+#define SHT_C6000_UNWIND	0x70000001
+#define SHT_C6000_PREEMPTMAP	0x70000002
+#define SHT_C6000_ATTRIBUTES	0x70000003
+
+/* C6X specific DT_ tags */
+#define DT_C6000_DSBT_BASE	0x70000000
+#define DT_C6000_DSBT_SIZE	0x70000001
+#define DT_C6000_PREEMPTMAP	0x70000002
+#define DT_C6000_DSBT_INDEX	0x70000003
+
+/* C6X specific relocs */
+#define R_C6000_NONE		0
+#define R_C6000_ABS32		1
+#define R_C6000_ABS16		2
+#define R_C6000_ABS8		3
+#define R_C6000_PCR_S21		4
+#define R_C6000_PCR_S12		5
+#define R_C6000_PCR_S10		6
+#define R_C6000_PCR_S7		7
+#define R_C6000_ABS_S16		8
+#define R_C6000_ABS_L16		9
+#define R_C6000_ABS_H16		10
+#define R_C6000_SBR_U15_B	11
+#define R_C6000_SBR_U15_H	12
+#define R_C6000_SBR_U15_W	13
+#define R_C6000_SBR_S16		14
+#define R_C6000_SBR_L16_B	15
+#define R_C6000_SBR_L16_H	16
+#define R_C6000_SBR_L16_W	17
+#define R_C6000_SBR_H16_B	18
+#define R_C6000_SBR_H16_H	19
+#define R_C6000_SBR_H16_W	20
+#define R_C6000_SBR_GOT_U15_W	21
+#define R_C6000_SBR_GOT_L16_W	22
+#define R_C6000_SBR_GOT_H16_W	23
+#define R_C6000_DSBT_INDEX	24
+#define R_C6000_PREL31		25
+#define R_C6000_COPY		26
+#define R_C6000_ALIGN		253
+#define R_C6000_FPHEAD		254
+#define R_C6000_NOCMP		255
+
+#endif /*_ASM_C6X_ELF_H */
diff --git a/arch/c6x/include/asm/emergency-restart.h b/arch/c6x/include/asm/emergency-restart.h
new file mode 100644
index 0000000..6cc0cf1
--- /dev/null
+++ b/arch/c6x/include/asm/emergency-restart.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_EMERGENCY_RESTART_H
+#define _ASM_C6X_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_C6X_EMERGENCY_RESTART_H */
diff --git a/arch/c6x/include/asm/errno.h b/arch/c6x/include/asm/errno.h
new file mode 100644
index 0000000..7f74f4a
--- /dev/null
+++ b/arch/c6x/include/asm/errno.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_ERRNO_H
+#define _ASM_C6X_ERRNO_H
+
+#include <asm-generic/errno.h>
+
+#endif /* _ASM_C6X_ERRNO_H */
diff --git a/arch/c6x/include/asm/fb.h b/arch/c6x/include/asm/fb.h
new file mode 100644
index 0000000..392e52a
--- /dev/null
+++ b/arch/c6x/include/asm/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_FB_H
+#define _ASM_C6X_FB_H
+
+#include <asm-generic/fb.h>
+
+#endif /* _ASM_C6X_FB_H */
diff --git a/arch/c6x/include/asm/fcntl.h b/arch/c6x/include/asm/fcntl.h
new file mode 100644
index 0000000..7a8f9eb
--- /dev/null
+++ b/arch/c6x/include/asm/fcntl.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_FCNTL_H
+#define _ASM_C6X_FCNTL_H
+
+#include <asm-generic/fcntl.h>
+
+#endif /* _ASM_C6X_FCNTL_H */
diff --git a/arch/c6x/include/asm/ftrace.h b/arch/c6x/include/asm/ftrace.h
new file mode 100644
index 0000000..3701958
--- /dev/null
+++ b/arch/c6x/include/asm/ftrace.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_FTRACE_H
+#define _ASM_C6X_FTRACE_H
+
+/* empty */
+
+#endif /* _ASM_C6X_FTRACE_H */
diff --git a/arch/c6x/include/asm/futex.h b/arch/c6x/include/asm/futex.h
new file mode 100644
index 0000000..d492f20
--- /dev/null
+++ b/arch/c6x/include/asm/futex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_FUTEX_H
+#define _ASM_C6X_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* _ASM_C6X_FUTEX_H */
diff --git a/arch/c6x/include/asm/gemac.h b/arch/c6x/include/asm/gemac.h
new file mode 100644
index 0000000..c73c65a
--- /dev/null
+++ b/arch/c6x/include/asm/gemac.h
@@ -0,0 +1,146 @@
+/*
+ *  linux/include/asm-c6x/gemac.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Nicolas Videau <nicolas.videau@jaluna.com>
+ *	    Aurelien Jacquiot <a-jacquiot@ti.com>
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_GEMAC_H
+#define _ASM_C6X_GEMAC_H
+
+#ifdef __KERNEL__
+
+/*
+ * Tx and Rx buffers parameters (total should be lower than 512)
+ */
+#define QUEUE_NUM	  8			 /* Number of queues in the EMAC */
+#define DESC_NUM	  512			 /* Max number of descriptors in the descriptor
+						    memory (invariant) */
+#define QUEUE_DESC_NUM	  (DESC_NUM / QUEUE_NUM) /* Number of descriptors per queue */
+#define MAC_ADDR_NUM	  32			 /* Number of MAC addresses */
+
+#define TX_RING_SIZE	  (QUEUE_DESC_NUM / 2)	 /* Must be a power of 2 */
+#define RX_RING_SIZE	  (QUEUE_DESC_NUM - TX_RING_SIZE)
+#define RX_RING_MOD_MAX   (RX_RING_SIZE - 1)
+#define TX_RING_MOD_MASK  (TX_RING_SIZE - 1)
+
+#define PKT_MTU_CRC	  (ETH_FRAME_LEN + 4)
+#define PKT_MTU_NOCRC	  ETH_FRAME_LEN
+
+#define TX_TIMEOUT	  (2*HZ)
+#define EMAC_TIMER_PERIOD (HZ/10)
+
+#define GEMAC_RESET_COLD  1
+#define GEMAC_RESET_WARM  2
+
+#define IDX_TO_CHAN(i)	  (i)			  /* Convert index to channel */
+#define IDX_TO_MAC(i)	  ((i) << 1)		  /* Convert index to MAC addr offset */
+#define DEV_TO_MAC(d)	  ((d) * CORE_NUM)	  /* Convert dev_id to MAC addr offset */
+
+/*
+ * EMAC descriptor
+ */
+struct emac_desc {
+	struct emac_desc  *next;
+	u8		  *buff;
+	u32		  buff_offset_len;
+	u32		  packet_flags_len;
+};
+
+/*
+ * Private EMAC information
+ */
+struct emac_private {
+	struct sk_buff *tx_skbuff[TX_RING_SIZE]; /* software TX skbuff ring */
+	struct sk_buff *rx_skbuff[RX_RING_SIZE]; /* software RX skbuff ring */
+	unsigned long skb_cur;
+	unsigned long skb_tx_dirty;
+	unsigned long skb_rx_dirty;
+	unsigned long count_tx;
+
+	struct emac_desc *rx_desc_base;
+	struct emac_desc *tx_desc_base; /* address of rx and tx buffers base */
+	struct emac_desc *cur_rx;
+	struct emac_desc *cur_tx;	/* the next free ring entries */
+	struct emac_desc *dirty_tx;	/* the ring entry to be freed */
+	struct emac_desc *head_tx;	/* the new list head to be sent */
+
+	struct net_device *dev;
+
+	unsigned long mode_flags;
+	unsigned long slave;
+	unsigned long packet_mtu;
+	unsigned long tx_full;
+	unsigned long fatal_error;
+	spinlock_t    lock;
+	unsigned long emac_reg_base;
+	unsigned long ectl_reg_base;
+	unsigned long emac_dsc_base;
+	unsigned long mdio_reg_base;
+#ifdef EMAC_HAS_ALE_SUPPORT
+	unsigned int  mcast_valid_len;
+	unsigned int *mcast_infos;
+#endif
+};
+
+/*
+ * EMAC Configuration information
+ */
+struct emac_config {
+	u32 flags;
+	u32 enetaddr[6];
+};
+
+#define emac_setbit_reg(reg, val)					\
+	(*((volatile u32 *) (ep->emac_reg_base + (reg))) |= (u32) (val))
+
+#define emac_clearbit_reg(reg, val)					\
+	(*((volatile u32 *) (ep->emac_reg_base + (reg))) &= ~((u32) (val)))
+
+#define emac_set_reg(reg, val)						\
+	(*((volatile u32 *) (ep->emac_reg_base + (reg))) = (u32) (val))
+
+#define emac_get_reg(reg)				\
+	(*((volatile u32 *) (ep->emac_reg_base + (reg))))
+
+#define emac_addr_reg(reg)				\
+	((volatile u32 *) (ep->emac_reg_base + (reg)))
+
+#define emac_set_stat(w, reg)			\
+	do {					\
+		u32 stat = emac_get_reg(reg);	\
+		emac_set_reg(reg, stat);	\
+		stat += (w);			\
+		(w) = stat;			\
+	} while (0)
+
+#if defined(CONFIG_SOC_TMS320C6457) || defined(CONFIG_SOC_TMS320C6472) || defined(CONFIG_SOC_TMS320C6474)
+#define ectl_setbit_reg(reg, val)					\
+	(*((volatile u32 *) (ep->ectl_reg_base + (reg))) |= (u32) (val))
+
+#define ectl_clearbit_reg(reg, val)					\
+	(*((volatile u32 *) (ep->ectl_reg_base + (reg))) &= ~((u32) (val)))
+
+#define ectl_set_reg(reg, val)						\
+	(*((volatile u32 *) (ep->ectl_reg_base + (reg))) = (u32) (val))
+
+#define ectl_get_reg(reg)				\
+	(*((volatile u32 *) (ep->ectl_reg_base + (reg))))
+
+/* Value for interrupt pacing: (CPUCLK/6) / 250000 (1/4us) = 0x29a on 1GHz DSP */
+#define gemac_int_prescaler()					\
+	((c6x_core_freq / 6) / 250000)
+
+#endif /* defined(CONFIG_SOC_TMS320C6457) || defined(CONFIG_SOC_TMS320C6472) || defined(CONFIG_SOC_TMS320C6474) */
+
+#include <mach/gemac.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_C6X_EMAC_H */
diff --git a/arch/c6x/include/asm/gmdio.h b/arch/c6x/include/asm/gmdio.h
new file mode 100644
index 0000000..af0b177
--- /dev/null
+++ b/arch/c6x/include/asm/gmdio.h
@@ -0,0 +1,217 @@
+/*
+ *  linux/include/asm-c6x/gmdio.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Nicolas Videau (nicolas.videau@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_GMDIO_H
+#define _ASM_C6X_GMDIO_H
+
+#ifdef __KERNEL__
+#include <mach/dscr.h>
+#include <mach/gmdio.h>
+
+#define MDIO_VERSION		  0x000 /* Module Version Register */
+#define MDIO_CONTROL		  0x004 /* Module Control Register */
+#define MDIO_ALIVE		  0x008 /* PHY "Alive" Indication Register */
+#define MDIO_LINK		  0x00c /* PHY Link Status Register */
+#define MDIO_LINKINTRAW		  0x010 /* Link Status Change Interrupt Register */
+#define MDIO_LINKINTMASKED	  0x014 /* Link Status Change Interrupt Register (Masked) */
+#define MDIO_USERINTRAW		  0x020 /* User Command Complete Interrupt */
+#define MDIO_USERINTMASKED	  0x024 /* User Command Complete Interrupt (Masked) */
+#define MDIO_USERINTMASKSET	  0x028 /* Enable User Command Complete Interrupt Mask */
+#define MDIO_USERINTMASKCLEAR	  0x02c /* Disable User Command Complete Interrupt Mask */
+#define MDIO_USERACCESS0	  0x080 /* User Access Register 0 */
+#define MDIO_USERPHYSEL0	  0x084 /* User PHY Select Register 0 */
+#define MDIO_USERACCESS1	  0x088 /* User Access Register 1 */
+#define MDIO_USERPHYSEL1	  0x08c /* User PHY Select Register 1 */
+
+#define EMAC_M_CLKDIV		 ((1 << 16) - 1)
+
+#define EMAC_B_FAULTENB		 (1 << 18)
+#define EMAC_B_FAULT		 (1 << 19)
+#define EMAC_B_PREAMBLE		 (1 << 20)
+#define EMAC_B_ENABLE		 (1 << 30)
+#define EMAC_B_IDLE		 (1 << 31)
+
+#define MDIO_B_ACK		 (1 << 29)
+#define MDIO_B_WRITE		 (1 << 30)
+#define MDIO_B_GO		 (1 << 31) /* for USERACESS */
+
+#define mdio_setbit_reg(reg, val) \
+	(*((volatile u32 *) (MDIO_REG_BASE + (reg))) |= (u32) (val))
+
+#define mdio_clearbit_reg(reg, val) \
+	(*((volatile u32 *) (MDIO_REG_BASE + (reg))) &= ~((u32) (val)))
+
+#define mdio_set_reg(reg, val) \
+	(*((volatile u32 *) (MDIO_REG_BASE + (reg))) = (u32) (val))
+
+#define mdio_get_reg(reg) \
+	(*((volatile u32 *) (MDIO_REG_BASE + (reg))))
+
+#define mdio_addr_reg(reg) \
+	((volatile u32 *) (MDIO_REG_BASE + (reg)))
+
+
+/*
+ * MDIO status
+ */
+struct mdio_status {
+	unsigned int mode;
+	unsigned int phy_state;
+	unsigned int phy_ticks;
+	unsigned int phy_addr;
+	unsigned int pending_status;
+	unsigned int link_status;
+	unsigned int macsel;
+	unsigned int emac_txidver;
+};
+
+/*
+ * MDIO events
+ */
+#define MDIO_EVENT_NOCHANGE	 0   /* No change from previous status */
+#define MDIO_EVENT_LINKDOWN	 1   /* Link down event */
+#define MDIO_EVENT_LINKUP	 2   /* Link (or re-link) event */
+#define MDIO_EVENT_PHYERROR	 3   /* No PHY connected */
+
+/*
+ * MDIO link status values
+ */
+#define MDIO_LINKSTATUS_NOLINK	 0
+#define MDIO_LINKSTATUS_HD10	 1
+#define MDIO_LINKSTATUS_FD10	 2
+#define MDIO_LINKSTATUS_HD100	 3
+#define MDIO_LINKSTATUS_FD100	 4
+#define MDIO_LINKSTATUS_FD1000	 5
+
+/*
+ * MDIO configuration mode flags
+ */
+#define MDIO_MODE_AUTONEG	 0x0001 /* Use Autonegotiate	     */
+#define MDIO_MODE_HD10		 0x0002 /* Use 10Mb/s Half Duplex    */
+#define MDIO_MODE_FD10		 0x0004 /* Use 10Mb/s Full Duplex    */
+#define MDIO_MODE_HD100		 0x0008 /* Use 100Mb/s Half Duplex   */
+#define MDIO_MODE_FD100		 0x0010 /* Use 100Mb/s Full Duplex   */
+#define MDIO_MODE_FD1000	 0x0020 /* Use 1000Mb/s Full Duplex  */
+#define MDIO_MODE_LOOPBACK	 0x0040 /* Use PHY Loopback	     */
+#define MDIO_MODE_NWAYACTIVE	 0x0080 /* NWAY is currently active  */
+#define MDIO_MODE_EXTLOOPBACK	 0x0100 /* Use external PHY Loopback */
+
+/*
+ * MDIO states in the PHY state machine
+ */
+#define MDIO_PHY_MDIOINIT	 0
+#define MDIO_PHY_RESET		 1
+#define MDIO_PHY_NWAYSTART	 2
+#define MDIO_PHY_NWAYWAIT	 3
+#define MDIO_PHY_LINKWAIT	 4
+#define MDIO_PHY_LINKED		 5
+
+/*
+ * PHY control registers
+ */
+#define MDIO_PHY_REG_CONTROL	 0
+#define MDIO_PHY_REG_STATUS	 1
+#define MDIO_PHY_REG_ID1	 2
+#define MDIO_PHY_REG_ID2	 3
+#define MDIO_PHY_REG_ADVERTISE	 4
+#define MDIO_PHY_REG_PARTNER	 5
+#define MDIO_PHY_REG_1000CONTROL 9
+#define MDIO_PHY_REG_1000STATUS  0xA
+#define MDIO_PHY_REG_EXTSTATUS	 0xF
+#define MDIO_PHY_REG_SHADOW	 0x18
+#define MDIO_PHY_REG_ACCESS	 0x1C
+
+#define MDIO_PHY_B_SPEEDMSB	 (1<<6)
+#define MDIO_PHY_B_DUPLEXFULL	 (1<<8)
+#define MDIO_PHY_B_AUTORESTART	 (1<<9)
+#define MDIO_PHY_B_ISOLATE	 (1<<10)
+#define MDIO_PHY_B_POWERDOWN	 (1<<11)
+#define MDIO_PHY_B_AUTONEGEN	 (1<<12)
+#define MDIO_PHY_B_SPEEDLSB	 (1<<13)
+#define MDIO_PHY_B_SPEED100	 (1<<13)
+#define MDIO_PHY_B_LOOPBACK	 (1<<14)
+#define MDIO_PHY_B_RESET	 (1<<15)    /* for CONTROL */
+
+#define MDIO_PHY_B_FD100	 (1<<14)
+#define MDIO_PHY_B_HD100	 (1<<13)
+#define MDIO_PHY_B_FD10		 (1<<12)
+#define MDIO_PHY_B_HD10		 (1<<11)
+#define MDIO_PHY_B_EXTSTATUS	 (1<<8)
+#define MDIO_PHY_B_NOPREAMBLE	 (1<<6)
+#define MDIO_PHY_B_AUTOCOMPLETE  (1<<5)
+#define MDIO_PHY_B_REMOTEFAULT	 (1<<4)
+#define MDIO_PHY_B_AUTOCAPABLE	 (1<<3)
+#define MDIO_PHY_B_LINKSTATUS	 (1<<2)
+#define MDIO_PHY_B_JABBER	 (1<<1)
+#define MDIO_PHY_B_EXTENDED	 (1<<0)     /* for STATUS */
+
+#define MDIO_PHY_B_NEXTPAGE	 (1<<15)
+#define MDIO_PHY_B_ACK		 (1<<14)
+#define MDIO_PHY_B_FAULT	 (1<<13)
+#define MDIO_PHY_B_PAUSE	 (1<<10)
+#define MDIO_PHY_B_AFD100	 (1<<8)
+#define MDIO_PHY_B_AHD100	 (1<<7)
+#define MDIO_PHY_B_AFD10	 (1<<6)
+#define MDIO_PHY_B_AHD10	 (1<<5)
+#define MDIO_PHY_B_MSGMASK	 (0x1F)
+#define MDIO_PHY_B_MSG		 (1<<0)     /* for ADVERTISE and PARTNER */
+
+#define MDIO_PHY_ADV_FD1000	 (1<<9)     /* for 1000CONTROL */
+
+#define MDIO_PHY_PRT_FD1000	 (1<<11)    /* for 1000STATUS */
+
+#define MDIO_PHY_EXT_FD1000	 (1<<13)    /* for EXTSTATUS */
+
+#define MDIO_PHY_B_EXTLOOPBACK	 0x8400
+#define MDIO_PHY_B_RGMIIMODE	 0xF080
+#define MDIO_PHY_B_INBAND	 0xF1C7     /* for SHADOW */
+
+#define MDIO_PHY_B_COPPER	 0xFC00     /* for ACCESS */
+
+
+#define mdio_phy_read(regadr, phyadr)			\
+	mdio_set_reg(MDIO_USERACCESS0, MDIO_B_GO |	\
+		     ((phyadr & 0x1f) << 16) |		\
+		     ((regadr & 0x1f) << 21))
+
+#define mdio_phy_write(regadr, phyadr, data)		\
+	mdio_set_reg(MDIO_USERACCESS0, MDIO_B_GO |	\
+		     MDIO_B_WRITE |			\
+		     ((phyadr & 0x1f) << 16) |		\
+		     ((regadr & 0x1f) << 21) |		\
+		     ((data & 0xffff)))
+
+#define mdio_phy_wait()					\
+	while (mdio_get_reg(MDIO_USERACCESS0) & MDIO_B_GO)
+
+#define mdio_phy_wait_res(results)				   \
+	do {							   \
+		while (mdio_get_reg(MDIO_USERACCESS0) & MDIO_B_GO) \
+			;					   \
+		results = mdio_get_reg(MDIO_USERACCESS0) & 0xffff; \
+	} while (0)
+
+#define mdio_phy_wait_res_ack(results, ack)				\
+	do {								\
+		while (mdio_get_reg(MDIO_USERACCESS0) & MDIO_B_GO)	\
+			;						\
+		results = mdio_get_reg(MDIO_USERACCESS0) & 0xffff;	\
+		ack = (mdio_get_reg(MDIO_USERACCESS0) & MDIO_B_ACK) >> 29; \
+	} while (0)
+
+extern int mdio_init(unsigned int txid_version);
+extern unsigned int mdio_get_status(void);
+extern unsigned int mdio_timer_tick(void);
+extern unsigned int mdio_get_macsel(void);
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_C6X_GMDIO_H */
diff --git a/arch/c6x/include/asm/hardirq.h b/arch/c6x/include/asm/hardirq.h
new file mode 100644
index 0000000..19c4a56
--- /dev/null
+++ b/arch/c6x/include/asm/hardirq.h
@@ -0,0 +1,22 @@
+/*
+ *  linux/include/asm-c6x/hardirq.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_C6X_HARDIRQ_H
+#define _ASM_C6X_HARDIRQ_H
+
+extern void ack_bad_irq(int irq);
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
+
+#endif /* _ASM_C6X_HARDIRQ_H */
diff --git a/arch/c6x/include/asm/hardware.h b/arch/c6x/include/asm/hardware.h
new file mode 100644
index 0000000..69db640
--- /dev/null
+++ b/arch/c6x/include/asm/hardware.h
@@ -0,0 +1,21 @@
+/*
+ *  linux/include/asm-c6x/hardware.h
+ *
+ *  Port on Texas Instruments TMS320C6x/C6x+ architecture
+ *
+ *  Copyright (C) 2005, 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_HARDWARE_H
+#define _ASM_C6X_HARDWARE_H
+
+#define __SYSREG(ADDR, TYPE) (*(volatile TYPE*)(ADDR))
+#define __SYSREGA(ADDR, TYPE) ((volatile TYPE*)(ADDR))
+
+#include <mach/hardware.h>
+
+#endif /* _ASM_C6X_HARDWARE_H */
diff --git a/arch/c6x/include/asm/hw_irq.h b/arch/c6x/include/asm/hw_irq.h
new file mode 100644
index 0000000..7c159eb
--- /dev/null
+++ b/arch/c6x/include/asm/hw_irq.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_HW_IRQ_H
+#define _ASM_C6X_HW_IRQ_H
+
+#include <asm-generic/hw_irq.h>
+
+#endif /* _ASM_C6X_HW_IRQ_H */
diff --git a/arch/c6x/include/asm/io.h b/arch/c6x/include/asm/io.h
new file mode 100644
index 0000000..e7a0353
--- /dev/null
+++ b/arch/c6x/include/asm/io.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_IO_H
+#define _ASM_C6X_IO_H
+
+#include <asm-generic/io.h>
+
+#endif /* _ASM_C6X_IO_H */
diff --git a/arch/c6x/include/asm/ioctl.h b/arch/c6x/include/asm/ioctl.h
new file mode 100644
index 0000000..53fd15e
--- /dev/null
+++ b/arch/c6x/include/asm/ioctl.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_IOCTL_H
+#define _ASM_C6X_IOCTL_H
+
+#include <asm-generic/ioctl.h>
+
+#endif /* _ASM_C6X_IOCTL_H */
diff --git a/arch/c6x/include/asm/ioctls.h b/arch/c6x/include/asm/ioctls.h
new file mode 100644
index 0000000..fd43676
--- /dev/null
+++ b/arch/c6x/include/asm/ioctls.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_IOCTLS_H
+#define _ASM_C6X_IOCTLS_H
+
+#include <asm-generic/ioctls.h>
+
+#endif /* _ASM_C6X_IOCTLS_H */
diff --git a/arch/c6x/include/asm/ipcbuf.h b/arch/c6x/include/asm/ipcbuf.h
new file mode 100644
index 0000000..9f2d5f0
--- /dev/null
+++ b/arch/c6x/include/asm/ipcbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_IPCBUF_H
+#define _ASM_C6X_IPCBUF_H
+
+#include <asm-generic/ipcbuf.h>
+
+#endif /* _ASM_C6X_IPCBUF_H */
diff --git a/arch/c6x/include/asm/irq.h b/arch/c6x/include/asm/irq.h
new file mode 100644
index 0000000..177f7db
--- /dev/null
+++ b/arch/c6x/include/asm/irq.h
@@ -0,0 +1,101 @@
+/*
+ *  linux/include/asm-c6x/irq.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_IRQ_H
+#define _ASM_C6X_IRQ_H
+
+#include <asm/hardware.h>
+#include <asm/percpu.h>
+
+#include <mach/irq.h>
+
+#define irq_canonicalize(irq)  (irq)
+
+#ifdef CONFIG_PIC_C64XPLUS
+#define NR_IRQS (NR_SOC_IRQS + NR_BOARD_IRQS)
+#else
+#define NR_IRQS (NR_SYS_IRQS + NR_BOARD_IRQS)
+#endif
+
+/*
+ * Number of C6x interrupt vectors.
+ *
+ * There are 16 vectors. One each is used by Reset and NMI. Two are reserved.
+ * The remaining 12 vectors are used to route SoC interrupt sources. These
+ * interrupt vectors are prioritized with INT4 having the highest priority
+ * and INT15 having the lowest.
+ *
+ * The C64x+ megamodule provides a way to combine SoC IRQ sources into a single
+ * IRQ vector. There are four combined sources, each of which feed into one of
+ * the 12 general interrupt vectors. The remaining 8 vectors can each route a
+ * single SoC interrupt directly.
+ *
+ */
+#define NR_SYS_IRQS 16
+
+/*
+ * Processor interrupt vector definitions
+ * Interrupt sources are prioritized from INT0 (highest) to INT15 (lowest).
+ */
+#define INT0		    0	 /* RESET */
+#define INT1		    1	 /* NMI */
+#define INT2		    2	 /* Reserved */
+#define INT3		    3	 /* Reserved */
+#define INT4		    4	 /* level 4 interrupt */
+#define INT5		    5	 /* level 5 interrupt */
+#define INT6		    6	 /* level 6 interrupt */
+#define INT7		    7	 /* level 7 interrupt */
+#define INT8		    8	 /* level 8 interrupt */
+#define INT9		    9	 /* level 9 interrupt */
+#define INT10		    10	 /* level 10 interrupt */
+#define INT11		    11	 /* level 11 interrupt */
+#define INT12		    12	 /* level 12 interrupt */
+#define INT13		    13	 /* level 13 interrupt */
+#define INT14		    14	 /* level 14 interrupt */
+#define INT15		    15	 /* level 15 interrupt */
+
+#ifdef CONFIG_PIC_C64XPLUS
+/* holds mapping of hw interrupt number to kernel IRQ number */
+extern uint16_t prio_to_irq[];
+
+#define hw_to_kernel_irq(hw) prio_to_irq[(hw)]
+
+/*
+ * Functions used to map interrupts from one level to another.
+ *
+ * For irq_map:
+ *    irq_src is a kernel IRQ number corresponding to megamodule combiner event
+ *    irq_dst is a hardware interrupt number (INT4 - INT15)
+ *
+ * For irq_cic_map:
+ *    irq_src is a kernel IRQ number corresponding to CIC combiner event
+ *    irq_dst is a kernel IRQ number corresponding to megamodule combiner event
+ *
+ * In order to map a CIC event directly to a core hardware interrupt, it must
+ * first be mapped to a megamodule event with irq_cic_map(). Then the megamodule
+ * event can be mapped to a core hardware interrupt with irq_map().
+ *
+ */
+extern void irq_map(unsigned int irq_src, unsigned int irq_dst);
+extern void irq_cic_map(unsigned int irq_src, unsigned int irq_dst);
+extern void cic_raw_map(unsigned int src, unsigned int dst, int core);
+
+extern void __init init_pic_c64xplus(void);
+#endif
+
+extern void init_IRQ(void);
+
+struct pt_regs;
+
+extern asmlinkage void c6x_do_IRQ(unsigned int prio, struct pt_regs *regs);
+
+#endif /* _ASM_C6X_IRQ_H */
diff --git a/arch/c6x/include/asm/irq_regs.h b/arch/c6x/include/asm/irq_regs.h
new file mode 100644
index 0000000..143adfe
--- /dev/null
+++ b/arch/c6x/include/asm/irq_regs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_IRQ_REGS_H
+#define _ASM_C6X_IRQ_REGS_H
+
+#include <asm-generic/irq_regs.h>
+
+#endif /* _ASM_C6X_IRQ_REGS_H */
diff --git a/arch/c6x/include/asm/irqflags.h b/arch/c6x/include/asm/irqflags.h
new file mode 100644
index 0000000..bac497f
--- /dev/null
+++ b/arch/c6x/include/asm/irqflags.h
@@ -0,0 +1,71 @@
+/* C6X IRQ flag handling
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+/* read interrupt enabled status */
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+
+	asm volatile (" mvc .s2 CSR,%0\n" : "=b"(flags));
+	return flags;
+}
+
+/* set interrupt enabled status */
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile (" mvc .s2 %0,CSR\n" : : "b"(flags));
+}
+
+/* unconditionally enable interrupts */
+static inline void arch_local_irq_enable(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	flags |= 1;
+	arch_local_irq_restore(flags);
+}
+
+/* unconditionally disable interrupts */
+static inline void arch_local_irq_disable(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	flags &= ~1;
+	arch_local_irq_restore(flags);
+}
+
+/* get status and disable interrupts */
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+
+	flags = arch_local_save_flags();
+	arch_local_irq_restore(flags & ~1);
+	return flags;
+}
+
+/* test flags */
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & 1) == 0;
+}
+
+/* test hardware interrupt enable bit */
+static inline int arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_IRQFLAGS_H */
diff --git a/arch/c6x/include/asm/kdebug.h b/arch/c6x/include/asm/kdebug.h
new file mode 100644
index 0000000..d2c70ad
--- /dev/null
+++ b/arch/c6x/include/asm/kdebug.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_KDEBUG_H
+#define _ASM_C6X_KDEBUG_H
+
+#include <asm-generic/kdebug.h>
+
+#endif /* _ASM_C6X_KDEBUG_H */
diff --git a/arch/c6x/include/asm/kmap_types.h b/arch/c6x/include/asm/kmap_types.h
new file mode 100644
index 0000000..696057f
--- /dev/null
+++ b/arch/c6x/include/asm/kmap_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_KMAP_TYPES_H
+#define _ASM_C6X_KMAP_TYPES_H
+
+#include <asm-generic/kmap_types.h>
+
+#endif /* _ASM_C6X_KMAP_TYPES_H */
diff --git a/arch/c6x/include/asm/leds.h b/arch/c6x/include/asm/leds.h
new file mode 100644
index 0000000..bdd17da
--- /dev/null
+++ b/arch/c6x/include/asm/leds.h
@@ -0,0 +1,22 @@
+/*
+ *  arch/c6x/include/asm/leds.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_LEDS_H
+#define _ASM_C6X_LEDS_H
+
+#include <mach/board.h>
+
+#ifndef __ASSEMBLY__
+extern void c6x_arch_idle_led(int state);
+#endif
+
+#endif /* _ASM_C6X_LEDS_H */
diff --git a/arch/c6x/include/asm/linkage.h b/arch/c6x/include/asm/linkage.h
new file mode 100644
index 0000000..d6807e9
--- /dev/null
+++ b/arch/c6x/include/asm/linkage.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_LINKAGE_H
+#define _ASM_C6X_LINKAGE_H
+
+#include <asm-generic/linkage.h>
+
+#endif /* _ASM_C6X_LINKAGE_H */
diff --git a/arch/c6x/include/asm/local.h b/arch/c6x/include/asm/local.h
new file mode 100644
index 0000000..17a94b4
--- /dev/null
+++ b/arch/c6x/include/asm/local.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_LOCAL_H
+#define _ASM_C6X_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ASM_C6X_LOCAL_H */
diff --git a/arch/c6x/include/asm/mman.h b/arch/c6x/include/asm/mman.h
new file mode 100644
index 0000000..8234838
--- /dev/null
+++ b/arch/c6x/include/asm/mman.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_C6X_MMAN_H
+#define _ASM_C6X_MMAN_H
+
+#include <asm-generic/mman.h>
+
+#endif /* _ASM_C6X_MMAN_H */
+
diff --git a/arch/c6x/include/asm/mmu.h b/arch/c6x/include/asm/mmu.h
new file mode 100644
index 0000000..8d376e9
--- /dev/null
+++ b/arch/c6x/include/asm/mmu.h
@@ -0,0 +1,20 @@
+/*
+ *  linux/include/asm-c6x/mmu.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_MMU_H
+#define _ASM_C6X_MMU_H
+
+typedef struct {
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* _ASM_C6X_MMU_H */
diff --git a/arch/c6x/include/asm/mmu_context.h b/arch/c6x/include/asm/mmu_context.h
new file mode 100644
index 0000000..7b222ba
--- /dev/null
+++ b/arch/c6x/include/asm/mmu_context.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_MMU_CONTEXT_H
+#define _ASM_C6X_MMU_CONTEXT_H
+
+#include <asm-generic/mmu_context.h>
+
+#endif /* _ASM_C6X_MMU_CONTEXT_H */
diff --git a/arch/c6x/include/asm/module.h b/arch/c6x/include/asm/module.h
new file mode 100644
index 0000000..d76d106
--- /dev/null
+++ b/arch/c6x/include/asm/module.h
@@ -0,0 +1,35 @@
+/*
+ *  arch/c6x/include/asm/module.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34 by: Mark Salter (msalter@redhat.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_MODULE_H
+#define _ASM_C6X_MODULE_H
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+#define Elf_Addr	Elf32_Addr
+#define Elf_Word	Elf32_Word
+
+/*
+ * This file contains the C6x architecture specific module code.
+ */
+struct mod_arch_specific {
+};
+
+struct loaded_sections {
+	unsigned int new_vaddr;
+	unsigned int loaded;
+};
+
+#endif /* _ASM_C6X_MODULE_H */
diff --git a/arch/c6x/include/asm/msgbuf.h b/arch/c6x/include/asm/msgbuf.h
new file mode 100644
index 0000000..14f063e
--- /dev/null
+++ b/arch/c6x/include/asm/msgbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_MSGBUF_H
+#define _ASM_C6X_MSGBUF_H
+
+#include <asm-generic/msgbuf.h>
+
+#endif /* _ASM_C6X_MSGBUF_H */
diff --git a/arch/c6x/include/asm/mutex.h b/arch/c6x/include/asm/mutex.h
new file mode 100644
index 0000000..7a7248e
--- /dev/null
+++ b/arch/c6x/include/asm/mutex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_MUTEX_H
+#define _ASM_C6X_MUTEX_H
+
+#include <asm-generic/mutex-null.h>
+
+#endif /* _ASM_C6X_MUTEX_H */
diff --git a/arch/c6x/include/asm/page.h b/arch/c6x/include/asm/page.h
new file mode 100644
index 0000000..d18e2b0
--- /dev/null
+++ b/arch/c6x/include/asm/page.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_C6X_PAGE_H
+#define _ASM_C6X_PAGE_H
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/page.h>
+
+#endif /* _ASM_C6X_PAGE_H */
diff --git a/arch/c6x/include/asm/param.h b/arch/c6x/include/asm/param.h
new file mode 100644
index 0000000..986e6c5
--- /dev/null
+++ b/arch/c6x/include/asm/param.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_PARAM_H
+#define _ASM_C6X_PARAM_H
+
+#include <asm-generic/param.h>
+
+#endif /* _ASM_C6X_PARAM_H */
diff --git a/arch/c6x/include/asm/pci.h b/arch/c6x/include/asm/pci.h
new file mode 100644
index 0000000..d7da231
--- /dev/null
+++ b/arch/c6x/include/asm/pci.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_PCI_H
+#define _ASM_C6X_PCI_H
+
+#include <asm-generic/pci.h>
+
+#endif /* _ASM_C6X_PCI_H */
diff --git a/arch/c6x/include/asm/percpu.h b/arch/c6x/include/asm/percpu.h
new file mode 100644
index 0000000..dbb7dc5
--- /dev/null
+++ b/arch/c6x/include/asm/percpu.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_PERCPU_H
+#define _ASM_C6X_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* _ASM_C6X_PERCPU_H */
diff --git a/arch/c6x/include/asm/pgalloc.h b/arch/c6x/include/asm/pgalloc.h
new file mode 100644
index 0000000..aff53f7
--- /dev/null
+++ b/arch/c6x/include/asm/pgalloc.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_PGALLOC_H
+#define _ASM_C6X_PGALLOC_H
+
+#include <asm-generic/pgalloc.h>
+
+#endif /* _ASM_C6X_PGALLOC_H */
diff --git a/arch/c6x/include/asm/pgtable.h b/arch/c6x/include/asm/pgtable.h
new file mode 100644
index 0000000..4e849d7
--- /dev/null
+++ b/arch/c6x/include/asm/pgtable.h
@@ -0,0 +1,83 @@
+/*
+ *  linux/include/asm-c6x/pgtable.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PGTABLE_H
+#define _ASM_C6X_PGTABLE_H
+
+#include <asm-generic/4level-fixup.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+
+/*
+ * All 32bit addresses are effectively valid for vmalloc...
+ * Sort of meaningless for non-VM targets.
+ */
+#define	VMALLOC_START	0
+#define	VMALLOC_END	0xffffffff
+
+#define pgd_present(pgd)	(1)
+#define pgd_none(pgd)		(0)
+#define pgd_bad(pgd)		(0)
+#define pgd_clear(pgdp)
+#define kern_addr_valid(addr) (1)
+
+#define pmd_offset(a, b)	((void *)0)
+#define pmd_none(x)		(!pmd_val(x))
+#define pmd_present(x)		(pmd_val(x))
+#define pmd_clear(xp)		do { set_pmd(xp, __pmd(0)); } while (0)
+#define pmd_bad(x)		(pmd_val(x) & ~PAGE_MASK)
+
+#define PAGE_NONE		__pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_SHARED		__pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_COPY		__pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_READONLY	        __pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_KERNEL		__pgprot(0)    /* these mean nothing to NO_MM */
+#define pgprot_noncached(prot)	(prot)
+
+extern void paging_init(void);
+
+#define __swp_type(x)		(0)
+#define __swp_offset(x)		(0)
+#define __swp_entry(typ, off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
+
+static inline int pte_file(pte_t pte)
+{
+	return 0;
+}
+
+#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+#define ZERO_PAGE(vaddr)	virt_to_page(empty_zero_page)
+extern unsigned long empty_zero_page;
+
+#define swapper_pg_dir ((pgd_t *) 0)
+
+/*
+ * No page table caches to initialise
+ */
+#define pgtable_cache_init()   do { } while (0)
+#define io_remap_pfn_range      remap_pfn_range
+
+#define io_remap_page_range(vma, vaddr, paddr, size, prot)		\
+		remap_pfn_range(vma, vaddr, (paddr) >> PAGE_SHIFT, size, prot)
+
+#include <asm-generic/pgtable.h>
+
+#endif /* _ASM_C6X_PGTABLE_H */
diff --git a/arch/c6x/include/asm/pll.h b/arch/c6x/include/asm/pll.h
new file mode 100644
index 0000000..86bcdd8
--- /dev/null
+++ b/arch/c6x/include/asm/pll.h
@@ -0,0 +1,79 @@
+/*
+ *  linux/include/asm-c6x/pll.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Nicolas Videau (nicolas.videau@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PLL_H
+#define _ASM_C6X_PLL_H
+
+#include <asm/io.h>
+#include <mach/pll.h>
+
+#ifdef ARCH_PLL1_BASE
+#define pll1_set_reg(reg, val) \
+	(*(volatile unsigned long *)(ARCH_PLL1_BASE + (reg)) = (val))
+
+#define pll1_get_reg(reg) \
+	(*(volatile unsigned long *)(ARCH_PLL1_BASE + (reg)))
+
+#define pll1_clearbit_reg(reg, val) \
+	pll1_set_reg((reg), pll1_get_reg(reg) & ~((u32)(val)))
+
+#define pll1_setbit_reg(reg, val) \
+	pll1_set_reg((reg), pll1_get_reg(reg) | (u32)(val))
+
+static inline void pll1_wait_gostat(void)
+{
+	while (pll1_get_reg(PLLSTAT) & PLLSTAT_GOSTAT)
+		;
+}
+#endif /* ARCH_PLL1_BASE */
+
+#ifdef ARCH_PLL2_BASE
+#define pll2_set_reg(reg, val) \
+	(*(volatile unsigned long *)(ARCH_PLL2_BASE + (reg)) = (val))
+
+#define pll2_get_reg(reg) \
+	(*(volatile unsigned long *)(ARCH_PLL2_BASE + (reg)))
+
+#define pll2_clearbit_reg(reg, val) \
+	pll2_set_reg((reg), pll2_get_reg(reg) & ~((u32)(val)))
+
+#define pll2_setbit_reg(reg, val) \
+	pll2_set_reg((reg), pll2_get_reg(reg) | (u32)(val))
+
+static inline void pll2_wait_gostat(void)
+{
+	while (pll2_get_reg(PLLSTAT) & PLLSTAT_GOSTAT)
+		;
+}
+#endif /* ARCH_PLL2_BASE */
+
+#ifdef ARCH_PLL3_BASE
+#define pll3_set_reg(reg, val) \
+	(*(volatile unsigned long *)(ARCH_PLL3_BASE + (reg)) = (val))
+
+#define pll3_get_reg(reg) \
+	(*(volatile unsigned long *)(ARCH_PLL3_BASE + (reg)))
+
+#define pll3_clearbit_reg(reg, val) \
+	pll3_set_reg((reg), pll3_get_reg(reg) & ~((u32)(val)))
+
+#define pll3_setbit_reg(reg, val) \
+	pll3_set_reg((reg), pll3_get_reg(reg) | (u32)(val))
+
+static inline void pll3_wait_gostat(void)
+{
+	while (pll3_get_reg(PLLSTAT) & PLLSTAT_GOSTAT)
+		;
+}
+#endif /* ARCH_PLL2_BASE */
+
+#endif /*_ASM_C6X_PLL_H */
diff --git a/arch/c6x/include/asm/pm.h b/arch/c6x/include/asm/pm.h
new file mode 100644
index 0000000..1bc387f
--- /dev/null
+++ b/arch/c6x/include/asm/pm.h
@@ -0,0 +1,48 @@
+/*
+ *  linux/include/asm-c6x/pm.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PM_H
+#define _ASM_C6X_PM_H
+
+#define PWRD_NONE	 0x00
+#define PWRD_PD1A	 0x09
+#define PWRD_PD1B	 0x11
+#define PWRD_PD2	 0x1a
+#define PWRD_PD3	 0x1c
+#define PWRD_IDLE	 0xff
+
+#define pwrd_set(pwrd)	 or_creg(CSR, ((pwrd) & 0xff) << 10))
+#define do_idle()	 asm(" IDLE\n")
+
+#define PWR_PDCTL_BASE	 0x019c0200
+
+#define PWR_PDCTL_MCBSP2 0x10
+#define PWR_PDCTL_MCBSP1 0x08
+#define PWR_PDCTL_MCBSP0 0x04
+#define PWR_PDCTL_EMIF	 0x02
+#define PWR_PDCTL_DMA	 0x01
+#define PWR_PDCTL_ALL	 0x1f
+
+#define pwr_pdctl_setbit(val) \
+	(*((volatile unsigned int *) PWR_PDCTL_BASE) |= (unsigned int) (val))
+
+#define pwr_pdctl_clearbit(val) \
+	(*((volatile unsigned int *) PWR_PDCTL_BASE) &= ~((unsigned int) (val)))
+
+#define pwr_pdctl_set(val) \
+	(*((volatile unsigned int *) PWR_PDCTL_BASE) = (unsigned int) (val))
+
+#define pwr_pdctl_get() \
+	(*((volatile unsigned int *) PWR_PDCTL_BASE))
+
+#endif /* _ASM_C6X_PM_H */
+
diff --git a/arch/c6x/include/asm/poll.h b/arch/c6x/include/asm/poll.h
new file mode 100644
index 0000000..2d5834e
--- /dev/null
+++ b/arch/c6x/include/asm/poll.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_POLL_H
+#define _ASM_C6X_POLL_H
+
+#include <asm-generic/poll.h>
+
+#endif /* _ASM_C6X_POLL_H */
diff --git a/arch/c6x/include/asm/posix_types.h b/arch/c6x/include/asm/posix_types.h
new file mode 100644
index 0000000..3585157
--- /dev/null
+++ b/arch/c6x/include/asm/posix_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_POSIX_TYPES_H
+#define _ASM_C6X_POSIX_TYPES_H
+
+#include <asm-generic/posix_types.h>
+
+#endif /* _ASM_C6X_POSIX_TYPES_H */
diff --git a/arch/c6x/include/asm/processor.h b/arch/c6x/include/asm/processor.h
new file mode 100644
index 0000000..bb5678d
--- /dev/null
+++ b/arch/c6x/include/asm/processor.h
@@ -0,0 +1,118 @@
+/*
+ * linux/include/asm-c6x/processor.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PROCESSOR_H
+#define _ASM_C6X_PROCESSOR_H
+
+#include <asm/ptrace.h>
+#include <asm/page.h>
+#include <asm/current.h>
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr()			\
+({						\
+	void *__pc;				\
+	asm("mvc .S2 pce1,%0\n" : "=b"(__pc));	\
+	__pc;					\
+})
+
+/*
+ * User space process size. Meaningless for NOMMU.
+ */
+#define TASK_SIZE	0xFFFFFFFF
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's. We won't be using it
+ */
+#define TASK_UNMAPPED_BASE	0
+
+struct thread_struct {
+	unsigned long long b15_14;
+	unsigned long long a15_14;
+	unsigned long long b13_12;
+	unsigned long long a13_12;
+	unsigned long long b11_10;
+	unsigned long long a11_10;
+	unsigned long long ricl_icl;
+	unsigned long  usp;		/* user stack pointer */
+	unsigned long  pc;		/* kernel pc */
+	unsigned long  wchan;
+};
+
+#define INIT_THREAD					\
+{							\
+	.usp = 0,					\
+	.wchan = 0,					\
+}
+
+#define INIT_MMAP { \
+	&init_mm, 0, 0, NULL, PAGE_SHARED, VM_READ | VM_WRITE | VM_EXEC, 1, \
+	NULL, NULL }
+
+#define task_pt_regs(task) \
+	((struct pt_regs *)(THREAD_START_SP + task_stack_page(task)) - 1)
+
+#define alloc_kernel_stack()	__get_free_page(GFP_KERNEL)
+#define free_kernel_stack(page) free_page((page))
+
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+extern void start_thread(struct pt_regs *regs, unsigned int pc,
+			 unsigned long usp);
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+/* Prepare to copy thread state - unlazy all lazy status */
+#define prepare_to_copy(tsk)	do { } while (0)
+
+extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
+
+#define copy_segments(tsk, mm)		do { } while (0)
+#define release_segments(mm)		do { } while (0)
+
+/*
+ * saved PC of a blocked thread.
+ */
+#define thread_saved_pc(tsk) (task_pt_regs(tsk)->pc)
+
+/*
+ * saved kernel SP of a blocked thread.
+ */
+#ifdef _BIG_ENDIAN
+#define thread_saved_ksp(tsk) \
+	(*(unsigned long *)&(tsk)->thread.b15_14)
+#else
+#define thread_saved_ksp(tsk) \
+	(*(((unsigned long *)&(tsk)->thread.b15_14) + 1))
+#endif
+
+extern unsigned long get_wchan(struct task_struct *p);
+
+#define KSTK_EIP(tsk)	(task_pt_regs(task)->pc)
+#define	KSTK_ESP(tsk)	(task_pt_regs(task)->sp)
+
+#define cpu_relax()		do { } while (0)
+
+extern const struct seq_operations cpuinfo_op;
+
+#endif /* ASM_C6X_PROCESSOR_H */
diff --git a/arch/c6x/include/asm/procinfo.h b/arch/c6x/include/asm/procinfo.h
new file mode 100644
index 0000000..b9937ef
--- /dev/null
+++ b/arch/c6x/include/asm/procinfo.h
@@ -0,0 +1,30 @@
+/*
+ *  arch/c6x/include/asm/procinfo.h
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter (msalter@redhat.com)
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PROCINFO_H
+#define _ASM_C6X_PROCINFO_H
+
+#ifdef __KERNEL__
+
+struct proc_info_list {
+	unsigned int		cpu_val;
+	unsigned int		cpu_mask;
+	const char		*arch_name;
+	const char		*elf_name;
+	unsigned int		elf_hwcap;
+};
+
+#else	/* __KERNEL__ */
+#include <asm/elf.h>
+#warning "Please include asm/elf.h instead"
+#endif	/* __KERNEL__ */
+
+#endif	/* _ASM_C6X_PROCINFO_H */
diff --git a/arch/c6x/include/asm/ptrace.h b/arch/c6x/include/asm/ptrace.h
new file mode 100644
index 0000000..7e94de8
--- /dev/null
+++ b/arch/c6x/include/asm/ptrace.h
@@ -0,0 +1,186 @@
+/*
+ *  linux/include/asm-c6x/ptrace.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PTRACE_H
+#define _ASM_C6X_PTRACE_H
+
+#include <linux/linkage.h>
+
+#if defined(__TMS320C6XPLUS__) || defined(_TMS320C6400_PLUS)
+#define BKPT_OPCODE	   0x56454314	    /* illegal opcode */
+#else
+#define BKPT_OPCODE	   0x0000a122	    /* BNOP .S2 0,5 */
+#endif
+
+#ifdef _BIG_ENDIAN
+#define PT_LO(odd, even)  odd
+#define PT_HI(odd, even)  even
+#else
+#define PT_LO(odd, even)  even
+#define PT_HI(odd, even)  odd
+#endif
+
+#define PT_A4_ORG  PT_LO(1, 0)
+#define PT_TSR	   PT_HI(1, 0)
+#define PT_ILC	   PT_LO(3, 2)
+#define PT_RILC    PT_HI(3, 2)
+#define PT_CSR	   PT_LO(5, 4)
+#define PT_PC	   PT_HI(5, 4)
+#define PT_B16	   PT_LO(7, 6)
+#define PT_B17	   PT_HI(7, 6)
+#define PT_B18	   PT_LO(9, 8)
+#define PT_B19	   PT_HI(9, 8)
+#define PT_B20	   PT_LO(11, 10)
+#define PT_B21	   PT_HI(11, 10)
+#define PT_B22	   PT_LO(13, 12)
+#define PT_B23	   PT_HI(13, 12)
+#define PT_B24	   PT_LO(15, 14)
+#define PT_B25	   PT_HI(15, 14)
+#define PT_B26	   PT_LO(17, 16)
+#define PT_B27	   PT_HI(17, 16)
+#define PT_B28	   PT_LO(19, 18)
+#define PT_B29	   PT_HI(19, 18)
+#define PT_B30	   PT_LO(21, 20)
+#define PT_B31	   PT_HI(21, 20)
+#define PT_B0	   PT_LO(23, 22)
+#define PT_B1	   PT_HI(23, 22)
+#define PT_B2	   PT_LO(25, 24)
+#define PT_B3	   PT_HI(25, 24)
+#define PT_B4	   PT_LO(27, 26)
+#define PT_B5	   PT_HI(27, 26)
+#define PT_B6	   PT_LO(29, 28)
+#define PT_B7	   PT_HI(29, 28)
+#define PT_B8	   PT_LO(31, 30)
+#define PT_B9	   PT_HI(31, 30)
+#define PT_B10	   PT_LO(33, 32)
+#define PT_B11	   PT_HI(33, 32)
+#define PT_B12	   PT_LO(35, 34)
+#define PT_B13	   PT_HI(35, 34)
+#define PT_A16	   PT_LO(37, 36)
+#define PT_A17	   PT_HI(37, 36)
+#define PT_A18	   PT_LO(39, 38)
+#define PT_A19	   PT_HI(39, 38)
+#define PT_A20	   PT_LO(41, 40)
+#define PT_A21	   PT_HI(41, 40)
+#define PT_A22	   PT_LO(43, 42)
+#define PT_A23	   PT_HI(43, 42)
+#define PT_A24	   PT_LO(45, 44)
+#define PT_A25	   PT_HI(45, 44)
+#define PT_A26	   PT_LO(47, 46)
+#define PT_A27	   PT_HI(47, 46)
+#define PT_A28	   PT_LO(49, 48)
+#define PT_A29	   PT_HI(49, 48)
+#define PT_A30	   PT_LO(51, 50)
+#define PT_A31	   PT_HI(51, 50)
+#define PT_A0	   PT_LO(53, 52)
+#define PT_A1	   PT_HI(53, 52)
+#define PT_A2	   PT_LO(55, 54)
+#define PT_A3	   PT_HI(55, 54)
+#define PT_A4	   PT_LO(57, 56)
+#define PT_A5	   PT_HI(57, 56)
+#define PT_A6	   PT_LO(59, 58)
+#define PT_A7	   PT_HI(59, 58)
+#define PT_A8	   PT_LO(61, 60)
+#define PT_A9	   PT_HI(61, 60)
+#define PT_A10	   PT_LO(63, 62)
+#define PT_A11	   PT_HI(63, 62)
+#define PT_A12	   PT_LO(65, 64)
+#define PT_A13	   PT_HI(65, 64)
+#define PT_A14	   PT_LO(67, 66)
+#define PT_A15	   PT_HI(67, 66)
+#define PT_B14	   PT_LO(69, 68)
+#define PT_B15	   PT_HI(69, 68)
+
+#define PT_DP	   PT_B14  /* Data Segment Pointer (B14) */
+#define PT_SP	   PT_B15  /* Stack Pointer (B15)  */
+
+#ifndef __ASSEMBLY__
+
+#ifdef _BIG_ENDIAN
+#define REG_PAIR(odd, even) unsigned long odd; unsigned long even
+#else
+#define REG_PAIR(odd, even) unsigned long even; unsigned long odd
+#endif
+
+/*
+ * this struct defines the way the registers are stored on the
+ * stack during a system call. fields defined with REG_PAIR
+ * are saved and restored using double-word memory operations
+ * which means the word ordering of the pair depends on endianess.
+ */
+struct pt_regs {
+	REG_PAIR(tsr, orig_a4);
+	REG_PAIR(rilc, ilc);
+	REG_PAIR(pc, csr);
+
+	REG_PAIR(b17, b16);
+	REG_PAIR(b19, b18);
+	REG_PAIR(b21, b20);
+	REG_PAIR(b23, b22);
+	REG_PAIR(b25, b24);
+	REG_PAIR(b27, b26);
+	REG_PAIR(b29, b28);
+	REG_PAIR(b31, b30);
+
+	REG_PAIR(b1, b0);
+	REG_PAIR(b3, b2);
+	REG_PAIR(b5, b4);
+	REG_PAIR(b7, b6);
+	REG_PAIR(b9, b8);
+	REG_PAIR(b11, b10);
+	REG_PAIR(b13, b12);
+
+	REG_PAIR(a17, a16);
+	REG_PAIR(a19, a18);
+	REG_PAIR(a21, a20);
+	REG_PAIR(a23, a22);
+	REG_PAIR(a25, a24);
+	REG_PAIR(a27, a26);
+	REG_PAIR(a29, a28);
+	REG_PAIR(a31, a30);
+
+	REG_PAIR(a1, a0);
+	REG_PAIR(a3, a2);
+	REG_PAIR(a5, a4);
+	REG_PAIR(a7, a6);
+	REG_PAIR(a9, a8);
+	REG_PAIR(a11, a10);
+	REG_PAIR(a13, a12);
+
+	REG_PAIR(a15, a14);
+	REG_PAIR(sp, dp);
+};
+
+#define PTRACE_GETREGS		  12
+#define PTRACE_SETREGS		  13
+#define PTRACE_GETFPREGS	  14
+#define PTRACE_SETFPREGS	  15
+
+#ifdef __KERNEL__
+
+#define DEFAULT_CSR		  0x0001	/* interrupt enable by default */
+						/* used in /include/asm/processor.h*/
+
+#define user_mode(regs)		  ((((regs)->tsr) & 0x40) != 0)
+
+#define instruction_pointer(regs) ((regs)->pc)
+#define profile_pc(regs) instruction_pointer(regs)
+extern void show_regs(struct pt_regs *);
+
+extern asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs);
+extern asmlinkage void syscall_trace_exit(struct pt_regs *regs);
+
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_C6X_PTRACE_H */
diff --git a/arch/c6x/include/asm/resource.h b/arch/c6x/include/asm/resource.h
new file mode 100644
index 0000000..5c18fea
--- /dev/null
+++ b/arch/c6x/include/asm/resource.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_RESOURCE_H
+#define _ASM_C6X_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_C6X_RESOURCE_H */
diff --git a/arch/c6x/include/asm/scatterlist.h b/arch/c6x/include/asm/scatterlist.h
new file mode 100644
index 0000000..f4a0622
--- /dev/null
+++ b/arch/c6x/include/asm/scatterlist.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SCATTERLIST_H
+#define _ASM_C6X_SCATTERLIST_H
+
+#include <asm-generic/scatterlist.h>
+
+#endif /* _ASM_C6X_SCATTERLIST_H */
diff --git a/arch/c6x/include/asm/sections.h b/arch/c6x/include/asm/sections.h
new file mode 100644
index 0000000..d26cc45
--- /dev/null
+++ b/arch/c6x/include/asm/sections.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_C6X_SECTIONS_H
+#define _ASM_C6X_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+extern char _vectors_start[];
+extern char _vectors_end[];
+
+#ifdef CONFIG_MTD_UCLINUX
+extern char _ebss[];
+#endif
+
+#ifdef CONFIG_XIP_KERNEL
+extern char _data_lma[];
+#endif
+
+#endif /* _ASM_C6X_SECTIONS_H */
diff --git a/arch/c6x/include/asm/segment.h b/arch/c6x/include/asm/segment.h
new file mode 100644
index 0000000..f1b81e5
--- /dev/null
+++ b/arch/c6x/include/asm/segment.h
@@ -0,0 +1 @@
+#include <asm-generic/segment.h>
diff --git a/arch/c6x/include/asm/sembuf.h b/arch/c6x/include/asm/sembuf.h
new file mode 100644
index 0000000..77a6b25
--- /dev/null
+++ b/arch/c6x/include/asm/sembuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SEMBUF_H
+#define _ASM_C6X_SEMBUF_H
+
+#include <asm-generic/sembuf.h>
+
+#endif /* _ASM_C6X_SEMBUF_H */
diff --git a/arch/c6x/include/asm/serial.h b/arch/c6x/include/asm/serial.h
new file mode 100644
index 0000000..47bc618
--- /dev/null
+++ b/arch/c6x/include/asm/serial.h
@@ -0,0 +1,25 @@
+/*
+ *  linux/include/asm-c6x/serial.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SERIAL_H
+#define _ASM_C6X_SERIAL_H
+
+#include <mach/board.h>
+
+#ifndef BASE_BAUD
+/*
+ * This assumes you have a 1.8432 MHz clock for your UART.
+ */
+#define BASE_BAUD (1843200 / 16)
+#endif
+
+#endif /* _ASM_C6X_SERIAL_H */
diff --git a/arch/c6x/include/asm/setup.h b/arch/c6x/include/asm/setup.h
new file mode 100644
index 0000000..67c499f
--- /dev/null
+++ b/arch/c6x/include/asm/setup.h
@@ -0,0 +1,49 @@
+/*
+ *  linux/include/asm-c6x/setup.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SETUP_H
+#define _ASM_C6X_SETUP_H
+
+#include <asm/hardware.h>
+
+#define COMMAND_LINE_SIZE   1024
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_MTD_UCLINUX
+extern struct map_info uclinux_ram_map;
+#endif
+
+#ifdef CONFIG_EARLY_PRINTK
+extern void early_printk(const char *fmt, ...);
+
+#ifdef CONFIG_HVC_C6X
+extern void hvc_c6x_early_puts(const char *buf, unsigned count);
+#endif
+
+#endif /* CONFIG_EARLY_PRINTK */
+
+extern unsigned int c6x_platram_start;
+extern unsigned int c6x_platram_size;
+
+struct tag_header;
+
+extern struct tag_header *c6x_tags_pointer;
+
+extern void c6x_mtd_early_init(void);
+extern void c6x_soc_setup_arch(void);
+extern void c6x_board_setup_arch(void);
+extern char *arch_compute_silicon_rev(u32 silicon_rev);
+extern unsigned int arch_get_silicon_rev(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_C6X_SETUP_H */
diff --git a/arch/c6x/include/asm/sgmii.h b/arch/c6x/include/asm/sgmii.h
new file mode 100644
index 0000000..b6342b3
--- /dev/null
+++ b/arch/c6x/include/asm/sgmii.h
@@ -0,0 +1,53 @@
+/*
+ *  linux/include/asm-c6x/sgmii.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2007, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SGMII_H
+#define _ASM_C6X_SGMII_H
+
+struct sgmii_config_s {
+	unsigned int loopback;
+	unsigned int master;
+	unsigned int autoneg;
+	unsigned int txconfig;
+	unsigned int rxconfig;
+	unsigned int auxconfig;
+};
+
+extern int sgmii_reset(void);
+extern int sgmii_config(struct sgmii_config_s *);
+
+#ifdef __KERNEL__
+#include <asm/hardware.h>
+
+#define SGMII_SRESET_RESET    0x1
+#define SGMII_SRESET_RTRESET  0x2
+#define SGMII_CTL_AUTONEG     0x01
+#define SGMII_CTL_LOOPBACK    0x10
+#define SGMII_CTL_MASTER      0x20
+
+#define sgmii_setbit_reg(reg, val) \
+	(*((volatile u32 *) (reg)) |= (u32) (val))
+
+#define sgmii_clearbit_reg(reg, val) \
+	(*((volatile u32 *) (reg)) &= ~((u32) (val)))
+
+#define sgmii_set_reg(reg, val) \
+	(*((volatile u32 *) (reg)) = (u32) (val))
+
+#define sgmii_get_reg(reg) \
+	(*((volatile u32 *) (reg)))
+
+#define sgmii_addr_reg(reg) \
+	((volatile u32 *) (reg))
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_C6X_SGMII_H */
diff --git a/arch/c6x/include/asm/shmbuf.h b/arch/c6x/include/asm/shmbuf.h
new file mode 100644
index 0000000..9e677aa
--- /dev/null
+++ b/arch/c6x/include/asm/shmbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SHMBUF_H
+#define _ASM_C6X_SHMBUF_H
+
+#include <asm-generic/shmbuf.h>
+
+#endif /* _ASM_C6X_SHMBUF_H */
diff --git a/arch/c6x/include/asm/shmparam.h b/arch/c6x/include/asm/shmparam.h
new file mode 100644
index 0000000..0e06c26
--- /dev/null
+++ b/arch/c6x/include/asm/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SHMPARAM_H
+#define _ASM_C6X_SHMPARAM_H
+
+#include <asm-generic/shmparam.h>
+
+#endif /* _ASM_C6X_SHMPARAM_H */
diff --git a/arch/c6x/include/asm/sigcontext.h b/arch/c6x/include/asm/sigcontext.h
new file mode 100644
index 0000000..bc171c4
--- /dev/null
+++ b/arch/c6x/include/asm/sigcontext.h
@@ -0,0 +1,83 @@
+/*
+ *  linux/include/asm-c6x/sigcontext.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SIGCONTEXT_H
+#define _ASM_C6X_SIGCONTEXT_H
+
+
+struct sigcontext {
+	unsigned long  sc_mask;		/* old sigmask */
+	unsigned long  sc_sp;		/* old user stack pointer */
+
+	unsigned long  sc_a4;
+	unsigned long  sc_b4;
+	unsigned long  sc_a6;
+	unsigned long  sc_b6;
+	unsigned long  sc_a8;
+	unsigned long  sc_b8;
+
+	unsigned long  sc_a0;
+	unsigned long  sc_a1;
+	unsigned long  sc_a2;
+	unsigned long  sc_a3;
+	unsigned long  sc_a5;
+	unsigned long  sc_a7;
+	unsigned long  sc_a9;
+
+	unsigned long  sc_b0;
+	unsigned long  sc_b1;
+	unsigned long  sc_b2;
+	unsigned long  sc_b3;
+	unsigned long  sc_b5;
+	unsigned long  sc_b7;
+	unsigned long  sc_b9;
+
+	unsigned long  sc_a16;
+	unsigned long  sc_a17;
+	unsigned long  sc_a18;
+	unsigned long  sc_a19;
+	unsigned long  sc_a20;
+	unsigned long  sc_a21;
+	unsigned long  sc_a22;
+	unsigned long  sc_a23;
+	unsigned long  sc_a24;
+	unsigned long  sc_a25;
+	unsigned long  sc_a26;
+	unsigned long  sc_a27;
+	unsigned long  sc_a28;
+	unsigned long  sc_a29;
+	unsigned long  sc_a30;
+	unsigned long  sc_a31;
+
+	unsigned long  sc_b16;
+	unsigned long  sc_b17;
+	unsigned long  sc_b18;
+	unsigned long  sc_b19;
+	unsigned long  sc_b20;
+	unsigned long  sc_b21;
+	unsigned long  sc_b22;
+	unsigned long  sc_b23;
+	unsigned long  sc_b24;
+	unsigned long  sc_b25;
+	unsigned long  sc_b26;
+	unsigned long  sc_b27;
+	unsigned long  sc_b28;
+	unsigned long  sc_b29;
+	unsigned long  sc_b30;
+	unsigned long  sc_b31;
+
+	unsigned long  sc_csr;
+	unsigned long  sc_pc;
+};
+
+#endif /* _ASM_C6X_SIGCONTEXT_H */
+
diff --git a/arch/c6x/include/asm/siginfo.h b/arch/c6x/include/asm/siginfo.h
new file mode 100644
index 0000000..01ce660
--- /dev/null
+++ b/arch/c6x/include/asm/siginfo.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SIGINFO_H
+#define _ASM_C6X_SIGINFO_H
+
+#include <asm-generic/siginfo.h>
+
+#endif /* _ASM_C6X_SIGINFO_H */
diff --git a/arch/c6x/include/asm/signal.h b/arch/c6x/include/asm/signal.h
new file mode 100644
index 0000000..f1cd870
--- /dev/null
+++ b/arch/c6x/include/asm/signal.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_C6X_SIGNAL_H
+#define _ASM_C6X_SIGNAL_H
+
+#include <asm-generic/signal.h>
+
+#ifndef __ASSEMBLY__
+#include <linux/linkage.h>
+
+struct pt_regs;
+
+extern asmlinkage int do_rt_sigreturn(struct pt_regs *regs);
+extern asmlinkage void do_notify_resume(struct pt_regs *regs,
+					u32 thread_info_flags,
+					int syscall);
+#endif
+
+#endif /* _ASM_C6X_SIGNAL_H */
diff --git a/arch/c6x/include/asm/socket.h b/arch/c6x/include/asm/socket.h
new file mode 100644
index 0000000..dc28af3
--- /dev/null
+++ b/arch/c6x/include/asm/socket.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SOCKET_H
+#define _ASM_C6X_SOCKET_H
+
+#include <asm-generic/socket.h>
+
+#endif /* _ASM_C6X_SOCKET_H */
diff --git a/arch/c6x/include/asm/sockios.h b/arch/c6x/include/asm/sockios.h
new file mode 100644
index 0000000..fd7ebd9
--- /dev/null
+++ b/arch/c6x/include/asm/sockios.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SOCKIOS_H
+#define _ASM_C6X_SOCKIOS_H
+
+#include <asm-generic/sockios.h>
+
+#endif /* _ASM_C6X_SOCKIOS_H */
diff --git a/arch/c6x/include/asm/stat.h b/arch/c6x/include/asm/stat.h
new file mode 100644
index 0000000..8aafa67
--- /dev/null
+++ b/arch/c6x/include/asm/stat.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_STAT_H
+#define _ASM_C6X_STAT_H
+
+#include <asm-generic/stat.h>
+
+#endif /* _ASM_C6X_STAT_H */
diff --git a/arch/c6x/include/asm/statfs.h b/arch/c6x/include/asm/statfs.h
new file mode 100644
index 0000000..b111ba0
--- /dev/null
+++ b/arch/c6x/include/asm/statfs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_STATFS_H
+#define _ASM_C6X_STATFS_H
+
+#include <asm-generic/statfs.h>
+
+#endif /* _ASM_C6X_STATFS_H */
diff --git a/arch/c6x/include/asm/string.h b/arch/c6x/include/asm/string.h
new file mode 100644
index 0000000..bfdabde
--- /dev/null
+++ b/arch/c6x/include/asm/string.h
@@ -0,0 +1,29 @@
+/*
+ *  linux/include/asm-c6x/string.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_STRING_H
+#define _ASM_C6X_STRING_H
+
+#include <asm/page.h>
+#include <linux/linkage.h>
+
+asmlinkage extern void *memcpy(void *to, const void *from, size_t n);
+extern void *memset(void *s, int c, size_t count);
+extern int memcmp(const void *cs, const void *ct, size_t count);
+extern void *memmove(void *s1, const void *s2, size_t n);
+
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMMOVE
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCMP
+
+#endif /* _ASM_C6X_STRING_H */
diff --git a/arch/c6x/include/asm/swab.h b/arch/c6x/include/asm/swab.h
new file mode 100644
index 0000000..909986f
--- /dev/null
+++ b/arch/c6x/include/asm/swab.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_SWAB_H
+#define _ASM_C6X_SWAB_H
+
+#include <asm-generic/swab.h>
+
+#endif /* _ASM_C6X_SWAB_H */
diff --git a/arch/c6x/include/asm/syscalls.h b/arch/c6x/include/asm/syscalls.h
new file mode 100644
index 0000000..f1a1130
--- /dev/null
+++ b/arch/c6x/include/asm/syscalls.h
@@ -0,0 +1,58 @@
+/*
+ * syscalls.h - Linux syscall interfaces (C6X-specific)
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __ASM_C6X_SYSCALLS_H
+#define __ASM_C6X_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+
+/* The array of function pointers for syscalls. */
+extern void *sys_call_table[];
+
+/* The following are trampolines in entry.S to handle 64-bit arguments */
+extern long sys_pread_c6x(unsigned int fd, char __user *buf,
+			  size_t count, off_t pos_low, off_t pos_high);
+extern long sys_pwrite_c6x(unsigned int fd, const char __user *buf,
+			   size_t count, off_t pos_low, off_t pos_high);
+extern long sys_truncate64_c6x(const char __user *path,
+			       off_t length_low, off_t length_high);
+extern long sys_ftruncate64_c6x(unsigned int fd,
+			       off_t length_low, off_t length_high);
+extern long sys_fadvise64_c6x(int fd, u32 offset_lo, u32 offset_hi,
+			      u32 len, int advice);
+extern long sys_fadvise64_64_c6x(int fd, u32 offset_lo, u32 offset_hi,
+				u32 len_lo, u32 len_hi, int advice);
+extern long sys_fallocate_c6x(int fd, int mode,
+			      u32 offset_lo, u32 offset_hi,
+			      u32 len_lo, u32 len_hi);
+extern int sys_cache_sync(unsigned long s, unsigned long e);
+
+struct pt_regs;
+
+extern asmlinkage int c6x_vfork(struct pt_regs *regs);
+extern asmlinkage int c6x_clone(struct pt_regs *regs);
+extern asmlinkage long c6x_execve(const char __user *name,
+				  const char __user *const __user *argv,
+				  const char __user *const __user *envp,
+				  struct pt_regs *regs);
+
+
+#include <asm-generic/syscalls.h>
+
+#endif /* __ASM_C6X_SYSCALLS_H */
diff --git a/arch/c6x/include/asm/system.h b/arch/c6x/include/asm/system.h
new file mode 100644
index 0000000..fe9ff5a
--- /dev/null
+++ b/arch/c6x/include/asm/system.h
@@ -0,0 +1,194 @@
+/*
+ *  linux/include/asm-c6x/system.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SYSTEM_H
+#define _ASM_C6X_SYSTEM_H
+
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+#define prepare_to_switch()    do { } while (0)
+
+struct task_struct;
+struct thread_struct;
+asmlinkage void *__switch_to(struct thread_struct *prev,
+			     struct thread_struct *next,
+			     struct task_struct *tsk);
+
+#define switch_to(prev, next, last)				\
+	do {							\
+		current->thread.wchan = (u_long) __builtin_return_address(0); \
+		(last) = __switch_to(&(prev)->thread,		\
+				     &(next)->thread, (prev));	\
+		mb();						\
+		current->thread.wchan = 0;			\
+	} while (0)
+
+/* Reset the board */
+#define HARD_RESET_NOW()
+
+#define get_creg(reg) \
+	({ unsigned int __x; asm volatile ("mvc .s2 " #reg ",%0\n" : "=b"(__x)); __x; })
+
+#define set_creg(reg, v) \
+	do { unsigned int __x = (unsigned int)(v); \
+		asm volatile ("mvc .s2 %0," #reg "\n" : : "b"(__x)); \
+	} while (0)
+
+#define or_creg(reg, n) \
+	do { unsigned __x, __n = (unsigned)(n);		  \
+		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
+			      "or  .l2 %1,%0,%0\n"	  \
+			      "mvc .s2 %0," #reg "\n"	  \
+			      "nop\n"			  \
+			      : "=&b"(__x) : "b"(__n));	  \
+	} while (0)
+
+#define and_creg(reg, n) \
+	do { unsigned __x, __n = (unsigned)(n);		  \
+		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
+			      "and .l2 %1,%0,%0\n"	  \
+			      "mvc .s2 %0," #reg "\n"	  \
+			      "nop\n"    \
+			      : "=&b"(__x) : "b"(__n));	  \
+	} while (0)
+
+#define get_coreid() (get_creg(DNUM) & 0xff)
+
+/*
+ * Interrupt management
+ */
+
+/* Return from interrupt function */
+#define iret()	  asm volatile("B   .S2 IRP\n" \
+			       "NOP 5\n")
+
+/* Set/get IST */
+#define set_ist(x)	set_creg(ISTP, x)
+#define get_ist()       get_creg(ISTP)
+
+#ifdef __TMS320C6XPLUS__
+#define __dint()                 asm volatile ("DINT\n")
+#define __rint()                 asm volatile ("RINT\n")
+#endif
+
+/*
+ * Exception management
+ */
+
+#ifdef __TMS320C6XPLUS__
+asmlinkage void enable_exception(void);
+#define disable_exception()
+#define get_except_type()        get_creg(EFR)
+#define ack_exception(type)      set_creg(ECR, 1 << (type))
+#define get_iexcept()            get_creg(IERR)
+#define set_iexcept(mask)        set_creg(IERR, (mask))
+#else
+#define enable_exception()
+#define disable_exception()
+#define get_except_type()
+#define ack_exception(type)
+#define get_iexcept()
+#define set_iexcept(mask)
+#endif
+
+/*
+ * Misc. functions
+ */
+
+/* Return from exception function */
+#define eret()			 { asm("B   .S2 NRP\n"); \
+				   asm("NOP  5\n"); }
+
+#define nop()                    asm("NOP\n");
+#define mb()                     barrier()
+#define rmb()                    barrier()
+#define wmb()                    barrier()
+#define set_mb(var, value)       do { var = value;  mb(); } while (0)
+#define set_wmb(var, value)      do { var = value; wmb(); } while (0)
+
+#define smp_mb()	         barrier()
+#define smp_rmb()	         barrier()
+#define smp_wmb()	         barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned int)(x), (void *) (ptr), \
+				    sizeof(*(ptr))))
+#define tas(ptr)    xchg((ptr), 1)
+
+unsigned int _lmbd(unsigned int, unsigned int);
+unsigned int _bitr(unsigned int);
+
+struct __xchg_dummy { unsigned int a[100]; };
+#define __xg(x) ((volatile struct __xchg_dummy *)(x))
+
+static inline unsigned int __xchg(unsigned int x, volatile void *ptr, int size)
+{
+	unsigned int tmp;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		tmp = 0;
+		tmp = *((unsigned char *) ptr);
+		*((unsigned char *) ptr) = (unsigned char) x;
+		break;
+	case 2:
+		tmp = 0;
+		tmp = *((unsigned short *) ptr);
+		*((unsigned short *) ptr) = x;
+		break;
+	case 4:
+		tmp = 0;
+		tmp = *((unsigned int *) ptr);
+		*((unsigned int *) ptr) = x;
+		break;
+	}
+	local_irq_restore(flags);
+	return tmp;
+}
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),		\
+						     (unsigned long)(o), \
+						     (unsigned long)(n), \
+						     sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#define _extu(x, s, e)							\
+	({      unsigned int __x;					\
+		asm volatile ("extu .S2 %3,%1,%2,%0\n" :		\
+			      "=b"(__x) : "n"(s), "n"(e), "b"(x));	\
+	       __x; })
+
+
+extern unsigned int c6x_core_freq;
+
+struct pt_regs;
+
+extern void die(char *str, struct pt_regs *fp, int nr);
+extern asmlinkage int process_exception(struct pt_regs *regs);
+extern void time_init(void);
+extern void free_initmem(void);
+
+#endif /* _ASM_C6X_SYSTEM_H */
diff --git a/arch/c6x/include/asm/termbits.h b/arch/c6x/include/asm/termbits.h
new file mode 100644
index 0000000..146dfad
--- /dev/null
+++ b/arch/c6x/include/asm/termbits.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_TERMBITS_H
+#define _ASM_C6X_TERMBITS_H
+
+#include <asm-generic/termbits.h>
+
+#endif /* _ASM_C6X_TERMBITS_H */
diff --git a/arch/c6x/include/asm/termios.h b/arch/c6x/include/asm/termios.h
new file mode 100644
index 0000000..77fd1da
--- /dev/null
+++ b/arch/c6x/include/asm/termios.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_TERMIOS_H
+#define _ASM_C6X_TERMIOS_H
+
+#include <asm-generic/termios.h>
+
+#endif /* _ASM_C6X_TERMIOS_H */
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
new file mode 100644
index 0000000..c1a3dd8
--- /dev/null
+++ b/arch/c6x/include/asm/thread_info.h
@@ -0,0 +1,123 @@
+/*
+ *  linux/include/asm-c6x/thread_info.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.3x: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_THREAD_INFO_H
+#define _ASM_C6X_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#include <asm/page.h>
+
+#ifdef CONFIG_4KSTACKS
+#define THREAD_SIZE		4096
+#define THREAD_SHIFT		12
+#define THREAD_ORDER		0
+#else
+#define THREAD_SIZE		8192
+#define THREAD_SHIFT		13
+#define THREAD_ORDER		1
+#endif
+
+#define THREAD_START_SP		(THREAD_SIZE - 8)
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * low level task data.
+ */
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	int			cpu;		/* cpu we're on */
+	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	mm_segment_t		addr_limit;	/* thread address space */
+	struct restart_block	restart_block;
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block	= {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* get the thread information struct of current task */
+static inline __attribute__((const))
+struct thread_info *current_thread_info(void)
+{
+	struct thread_info *ti;
+	asm volatile (" clr   .s2 B15,0,%1,%0\n"
+		      : "=b" (ti)
+		      : "Iu5" (THREAD_SHIFT - 1));
+	return ti;
+}
+
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+/* thread information allocation */
+#ifdef CONFIG_DEBUG_STACK_USAGE
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#else
+#define THREAD_FLAGS (GFP_KERNEL | __GFP_NOTRACK)
+#endif
+
+#define alloc_thread_info_node(tsk, node)	\
+	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
+
+#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_ORDER)
+#define get_thread_info(ti)	get_task_struct((ti)->task)
+#define put_thread_info(ti)	put_task_struct((ti)->task)
+#endif /* __ASSEMBLY__ */
+
+#define	PREEMPT_ACTIVE	0x10000000
+
+/*
+ * thread information flag bit numbers
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+
+#define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_MEMDIE		17	/* OOM killer killed process */
+
+#define TIF_WORK_MASK		0x00007FFE	/* work to do on interrupt/exception return */
+#define TIF_ALLWORK_MASK	0x00007FFF	/* work to do on any return to u-space */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_C6X_THREAD_INFO_H */
diff --git a/arch/c6x/include/asm/timer.h b/arch/c6x/include/asm/timer.h
new file mode 100644
index 0000000..8127a63
--- /dev/null
+++ b/arch/c6x/include/asm/timer.h
@@ -0,0 +1,31 @@
+/*
+ *  linux/include/asm-c6x/timer.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2005, 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_TIMER_H
+#define _ASM_C6X_TIMER_H
+
+#include <linux/interrupt.h>
+#include <mach/timer.h>
+
+#ifdef CONFIG_USE_RT_TIMER
+extern void adjust_time(void);
+#endif
+
+#define TIMER_REG(reg)	     (*((volatile unsigned int *) (reg)))
+#define TIMER_REG64(reg)     (*((volatile unsigned long long *) (reg)))
+
+#ifndef __ASSEMBLY__
+extern int c6x_arch_init_clocksource(void);
+extern int c6x_arch_init_clockevents(void);
+#endif	/* __ASSEMBLY__ */
+
+#endif /*_ASM_C6X_TIMER_H */
diff --git a/arch/c6x/include/asm/timex.h b/arch/c6x/include/asm/timex.h
new file mode 100644
index 0000000..9570f58
--- /dev/null
+++ b/arch/c6x/include/asm/timex.h
@@ -0,0 +1,43 @@
+/*
+ *  linux/include/asm-c6x/timex.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Modified for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_TIMEX_H
+#define _ASM_C6X_TIMEX_H
+
+/*
+ * This should be close enough...
+ */
+#define CLOCK_TICK_RATE ((1000 * 1000000UL) / 6)
+
+/* 64-bit timestamp */
+typedef unsigned long long cycles_t;
+
+extern cycles_t cacheflush_time;
+
+static inline cycles_t get_cycles(void)
+{
+	unsigned l, h;
+
+	asm volatile (" dint\n"
+		      " mvc .s2 TSCL,%0\n"
+		      " mvc .s2 TSCH,%1\n"
+		      " rint\n"
+		      : "=b"(l), "=b"(h));
+	return ((cycles_t)h << 32) | l;
+}
+
+extern int init_tsc_clocksource(void);
+extern int init_timer64_clocksource(void);
+
+#endif /* _ASM_C6X_TIMEX_H */
diff --git a/arch/c6x/include/asm/tlb.h b/arch/c6x/include/asm/tlb.h
new file mode 100644
index 0000000..8709e5e
--- /dev/null
+++ b/arch/c6x/include/asm/tlb.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_C6X_TLB_H
+#define _ASM_C6X_TLB_H
+
+#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_C6X_TLB_H */
diff --git a/arch/c6x/include/asm/tlbflush.h b/arch/c6x/include/asm/tlbflush.h
new file mode 100644
index 0000000..e00f0b9
--- /dev/null
+++ b/arch/c6x/include/asm/tlbflush.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_TLBFLUSH_H
+#define _ASM_C6X_TLBFLUSH_H
+
+#include <asm-generic/tlbflush.h>
+
+#endif /* _ASM_C6X_TLBFLUSH_H */
diff --git a/arch/c6x/include/asm/topology.h b/arch/c6x/include/asm/topology.h
new file mode 100644
index 0000000..30767fd
--- /dev/null
+++ b/arch/c6x/include/asm/topology.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_TOPOLOGY_H
+#define _ASM_C6X_TOPOLOGY_H
+
+#include <asm-generic/topology.h>
+
+#endif /* _ASM_C6X_TOPOLOGY_H */
diff --git a/arch/c6x/include/asm/traps.h b/arch/c6x/include/asm/traps.h
new file mode 100644
index 0000000..d2ab603
--- /dev/null
+++ b/arch/c6x/include/asm/traps.h
@@ -0,0 +1,39 @@
+/*
+ *  linux/include/asm-c6x/traps.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_TRAPS_H
+#define _ASM_C6X_TRAPS_H
+
+#ifdef CONFIG_TMS320C64XPLUS
+
+#define EXCEPT_TYPE_NXF   31	   /* NMI */
+#define EXCEPT_TYPE_EXC   30	   /* external exception */
+#define EXCEPT_TYPE_IXF   1	   /* internal exception */
+#define EXCEPT_TYPE_SXF   0	   /* software exception */
+
+#define EXCEPT_CAUSE_LBX  (1 << 7) /* loop buffer exception */
+#define EXCEPT_CAUSE_PRX  (1 << 6) /* privilege exception */
+#define EXCEPT_CAUSE_RAX  (1 << 5) /* resource access exception */
+#define EXCEPT_CAUSE_RCX  (1 << 4) /* resource conflict exception */
+#define EXCEPT_CAUSE_OPX  (1 << 3) /* opcode exception */
+#define EXCEPT_CAUSE_EPX  (1 << 2) /* execute packet exception */
+#define EXCEPT_CAUSE_FPX  (1 << 1) /* fetch packet exception */
+#define EXCEPT_CAUSE_IFX  (1 << 0) /* instruction fetch exception */
+
+struct exception_info {
+	char *kernel_str;
+	int  signo;
+	int  code;
+};
+
+#endif /* CONFIG_TMS320C64XPLUS */
+#endif /* _ASM_C6X_TRAPS_H */
diff --git a/arch/c6x/include/asm/types.h b/arch/c6x/include/asm/types.h
new file mode 100644
index 0000000..c2fe78b
--- /dev/null
+++ b/arch/c6x/include/asm/types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_TYPES_H
+#define _ASM_C6X_TYPES_H
+
+#include <asm-generic/types.h>
+
+#endif /* _ASM_C6X_TYPES_H */
diff --git a/arch/c6x/include/asm/uaccess.h b/arch/c6x/include/asm/uaccess.h
new file mode 100644
index 0000000..acb0405
--- /dev/null
+++ b/arch/c6x/include/asm/uaccess.h
@@ -0,0 +1,103 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_UACCESS_H
+#define _ASM_C6X_UACCESS_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/string.h>
+
+/*
+ * __copy_from_user/copy_to_user are based on ones in asm-generic/uaccess.h
+ *
+ * C6X supports unaligned 32 and 64 bit loads and stores.
+ */
+static inline __must_check long __copy_from_user(void *to,
+		const void __user *from, unsigned long n)
+{
+	u32 tmp32;
+	u64 tmp64;
+
+	if (__builtin_constant_p(n)) {
+		switch (n) {
+		case 1:
+			*(u8 *)to = *(u8 __force *)from;
+			return 0;
+		case 4:
+			asm volatile ("ldnw .d1t1 *%2,%0\n"
+				      "nop  4\n"
+				      "stnw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp32)
+				      : "A"(to), "a"(from)
+				      : "memory");
+			return 0;
+		case 8:
+			asm volatile ("ldndw .d1t1 *%2,%0\n"
+				      "nop   4\n"
+				      "stndw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp64)
+				      : "a"(to), "a"(from)
+				      : "memory");
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	memcpy(to, (const void __force *)from, n);
+	return 0;
+}
+
+static inline __must_check long __copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	u32 tmp32;
+	u64 tmp64;
+
+	if (__builtin_constant_p(n)) {
+		switch (n) {
+		case 1:
+			*(u8 __force *)to = *(u8 *)from;
+			return 0;
+		case 4:
+			asm volatile ("ldnw .d1t1 *%2,%0\n"
+				      "nop  4\n"
+				      "stnw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp32)
+				      : "a"(to), "a"(from)
+				      : "memory");
+			return 0;
+		case 8:
+			asm volatile ("ldndw .d1t1 *%2,%0\n"
+				      "nop   4\n"
+				      "stndw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp64)
+				      : "a"(to), "a"(from)
+				      : "memory");
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	memcpy((void __force *)to, from, n);
+	return 0;
+}
+
+#define __copy_to_user   __copy_to_user
+#define __copy_from_user __copy_from_user
+
+extern int _access_ok(unsigned long addr, unsigned long size);
+#ifdef CONFIG_ACCESS_CHECK
+#define __access_ok _access_ok
+#endif
+
+#include <asm-generic/uaccess.h>
+
+#endif /* _ASM_C6X_UACCESS_H */
diff --git a/arch/c6x/include/asm/ucontext.h b/arch/c6x/include/asm/ucontext.h
new file mode 100644
index 0000000..026bc0a
--- /dev/null
+++ b/arch/c6x/include/asm/ucontext.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_UCONTEXT_H
+#define _ASM_C6X_UCONTEXT_H
+
+#include <asm-generic/ucontext.h>
+
+#endif /* _ASM_C6X_UCONTEXT_H */
diff --git a/arch/c6x/include/asm/unaligned.h b/arch/c6x/include/asm/unaligned.h
new file mode 100644
index 0000000..a9fa06c
--- /dev/null
+++ b/arch/c6x/include/asm/unaligned.h
@@ -0,0 +1,290 @@
+/*
+ *  arch/c6x/include/asm/unaligned.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *  Rewritten for 2.6.3x: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_UNALIGNED_H
+#define _ASM_C6X_UNALIGNED_H
+
+/*
+ * The C64x+ can do unaligned word and dword accesses in hardware
+ * using special load/store instructions.
+ */
+
+static inline u16 __get_unaligned_le16(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u16 __get_unaligned_be16(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline void __put_unaligned_le16(u16 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_be16(u16 val, u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline u32 __get_unaligned32_swab(const u8 *p)
+{
+	u32 val = (u32) p;
+	asm volatile (" ldnw	.d1t1	*%0,%0\n"
+		      " nop	4\n"
+		      " swap2	.s1	%0,%0\n"
+		      " swap4	.l1	%0,%0\n"
+		      : "+a"(val));
+	return val;
+}
+
+static inline u32 __get_unaligned32(const u8 *p)
+{
+	u32 val = (u32) p;
+	asm volatile (" ldnw	.d1t1	*%0,%0\n"
+		      " nop     4\n"
+		      : "+a"(val));
+	return val;
+}
+
+static inline void __put_unaligned32_swab(u32 val, u8 *p)
+{
+	asm volatile (" swap2	.s1	%0,%0\n"
+		      " swap4	.l1	%0,%0\n"
+		      " stnw	.d2t1	%0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+static inline void __put_unaligned32(u32 val, u8 *p)
+{
+	asm volatile (" stnw	.d2t1	%0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+static inline u64 __get_unaligned64_swab(const u8 *p)
+{
+	u64 val;
+
+	asm volatile ("    ldndw   .d2t1  *%1,%0\n"
+		      "    nop	   4\n"
+		      "    swap2   .s1	  %p0,%P0\n"
+		      " || swap2   .l1    %P0,%p0\n"
+		      "    swap4   .l1    %p0,%p0\n"
+		      "    swap4   .l1    %P0,%P0\n"
+		      : "=a"(val) : "b"(p));
+	return val;
+}
+
+static inline u64 __get_unaligned64(const u8 *p)
+{
+	u64 val;
+	asm volatile (" ldndw	.d1t1	*%1,%0\n"
+		      " nop     4\n"
+		      : "=a"(val) : "a"(p));
+	return val;
+}
+
+static inline void __put_unaligned64_swab(u64 val, u8 *p)
+{
+	asm volatile ("    swap2  .s1     %p0,%P0\n"
+		      " || swap2  .l1	  %P0,%p0\n"
+		      "	   swap4  .l1	  %p0,%p0\n"
+		      "	   swap4  .l1	  %P0,%P0\n"
+		      "	   stndw  .d2t1	  %0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+static inline void __put_unaligned64(u64 val, u8 *p)
+{
+	asm volatile (" stndw	.d2t1	%0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned32_swab((const u8 *)p);
+#else
+	return __get_unaligned32((const u8 *)p);
+#endif
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned32((const u8 *)p);
+#else
+	return __get_unaligned32_swab((const u8 *)p);
+#endif
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned32_swab(val, p);
+#else
+	__put_unaligned32(val, p);
+#endif
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned32(val, p);
+#else
+	__put_unaligned32_swab(val, p);
+#endif
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned64_swab((const u8 *)p);
+#else
+	return __get_unaligned64((const u8 *)p);
+#endif
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned64((const u8 *)p);
+#else
+	return __get_unaligned64_swab((const u8 *)p);
+#endif
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned64_swab(val, p);
+#else
+	__put_unaligned64(val, p);
+#endif
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned64(val, p);
+#else
+	__put_unaligned64_swab(val, p);
+#endif
+}
+
+/*
+ * Cause a link-time error if we try an unaligned access other than
+ * 1,2,4 or 8 bytes long
+ */
+extern int __bad_unaligned_access_size(void);
+
+#define __get_unaligned_le(ptr) (typeof(*(ptr)))({			\
+	sizeof(*(ptr)) == 1 ? *(ptr) :					\
+	  (sizeof(*(ptr)) == 2 ? get_unaligned_le16((ptr)) :		\
+	     (sizeof(*(ptr)) == 4 ? get_unaligned_le32((ptr)) :		\
+		(sizeof(*(ptr)) == 8 ? get_unaligned_le64((ptr)) :	\
+		   __bad_unaligned_access_size())));			\
+	})
+
+#define __get_unaligned_be(ptr) (__force typeof(*(ptr)))({	\
+	sizeof(*(ptr)) == 1 ? *(ptr) :					\
+	  (sizeof(*(ptr)) == 2 ? get_unaligned_be16((ptr)) :		\
+	     (sizeof(*(ptr)) == 4 ? get_unaligned_be32((ptr)) :		\
+		(sizeof(*(ptr)) == 8 ? get_unaligned_be64((ptr)) :	\
+		   __bad_unaligned_access_size())));			\
+	})
+
+#define __put_unaligned_le(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_le16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_le32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_le64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#define __put_unaligned_be(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_be16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_be32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_be64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+
+#ifdef _BIG_ENDIAN
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
+#define get_unaligned16	get_unaligned_be16
+#define get_unaligned32	get_unaligned_be32
+#define get_unaligned64	get_unaligned_be64
+#else
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
+#define get_unaligned16	get_unaligned_le16
+#define get_unaligned32	get_unaligned_le32
+#define get_unaligned64	get_unaligned_le64
+#endif
+
+#endif /* _ASM_C6X_UNALIGNED_H */
diff --git a/arch/c6x/include/asm/unistd.h b/arch/c6x/include/asm/unistd.h
new file mode 100644
index 0000000..9064c6b
--- /dev/null
+++ b/arch/c6x/include/asm/unistd.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Incorporated
+ *
+ * Based on arch/tile version.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.	See the GNU General Public License for
+ *   more details.
+ */
+#if !defined(_ASM_C6X_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_C6X_UNISTD_H
+
+#define __ARCH_WANT_SYSCALL_DEPRECATED
+#define __ARCH_WANT_SYSCALL_NO_AT
+#define __ARCH_WANT_SYSCALL_NO_FLAGS
+#define __ARCH_WANT_SYSCALL_OFF_T
+#define __ARCH_WANT_IPC_PARSE_VERSION
+
+/* Use the standard ABI for syscalls. */
+#include <asm-generic/unistd.h>
+
+/* C6X-specific syscalls. */
+#define __NR_cache_sync	(__NR_arch_specific_syscall + 0)
+__SYSCALL(__NR_cache_sync, sys_cache_sync)
+
+#endif /* _ASM_C6X_UNISTD_H */
diff --git a/arch/c6x/include/asm/user.h b/arch/c6x/include/asm/user.h
new file mode 100644
index 0000000..4792a60
--- /dev/null
+++ b/arch/c6x/include/asm/user.h
@@ -0,0 +1 @@
+#include <asm-generic/user.h>
diff --git a/arch/c6x/include/asm/vga.h b/arch/c6x/include/asm/vga.h
new file mode 100644
index 0000000..d924655
--- /dev/null
+++ b/arch/c6x/include/asm/vga.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_VGA_H
+#define _ASM_C6X_VGA_H
+
+#include <asm-generic/vga.h>
+
+#endif /* _ASM_C6X_VGA_H */
-- 
1.6.2.5

