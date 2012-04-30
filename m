Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2D3UQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:16:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:35819 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab2D3UQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:08 -0400
Message-Id: <20120430194847.362452894@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org
Subject: [patch 29/29] init_task: Remove CONFIG_HAVE_GENERIC_INIT_TASK
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=init-task-remove-config.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all archs are converted, remove the config and compile
kernel/sched/init_task.c unconditionally.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/Kconfig            |    3 ---
 arch/alpha/Kconfig      |    1 -
 arch/arm/Kconfig        |    1 -
 arch/avr32/Kconfig      |    1 -
 arch/blackfin/Kconfig   |    1 -
 arch/c6x/Kconfig        |    1 -
 arch/cris/Kconfig       |    1 -
 arch/frv/Kconfig        |    1 -
 arch/h8300/Kconfig      |    1 -
 arch/hexagon/Kconfig    |    1 -
 arch/ia64/Kconfig       |    1 -
 arch/m32r/Kconfig       |    1 -
 arch/m68k/Kconfig       |    1 -
 arch/microblaze/Kconfig |    1 -
 arch/mips/Kconfig       |    1 -
 arch/mn10300/Kconfig    |    1 -
 arch/openrisc/Kconfig   |    1 -
 arch/parisc/Kconfig     |    1 -
 arch/powerpc/Kconfig    |    1 -
 arch/s390/Kconfig       |    1 -
 arch/score/Kconfig      |    1 -
 arch/sh/Kconfig         |    1 -
 arch/sparc/Kconfig      |    1 -
 arch/tile/Kconfig       |    1 -
 arch/um/Kconfig.common  |    1 -
 arch/unicore32/Kconfig  |    1 -
 arch/x86/Kconfig        |    1 -
 arch/xtensa/Kconfig     |    1 -
 kernel/sched/Makefile   |    3 +--
 29 files changed, 1 insertion(+), 32 deletions(-)

Index: tip/arch/Kconfig
===================================================================
--- tip.orig/arch/Kconfig
+++ tip/arch/Kconfig
@@ -148,9 +148,6 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
-config HAVE_GENERIC_INIT_TASK
-       bool
-
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
Index: tip/arch/alpha/Kconfig
===================================================================
--- tip.orig/arch/alpha/Kconfig
+++ tip/arch/alpha/Kconfig
@@ -16,7 +16,6 @@ config ALPHA
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: tip/arch/arm/Kconfig
===================================================================
--- tip.orig/arch/arm/Kconfig
+++ tip/arch/arm/Kconfig
@@ -35,7 +35,6 @@ config ARM
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
Index: tip/arch/avr32/Kconfig
===================================================================
--- tip.orig/arch/avr32/Kconfig
+++ tip/arch/avr32/Kconfig
@@ -12,7 +12,6 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: tip/arch/blackfin/Kconfig
===================================================================
--- tip.orig/arch/blackfin/Kconfig
+++ tip/arch/blackfin/Kconfig
@@ -38,7 +38,6 @@ config BLACKFIN
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config GENERIC_CSUM
 	def_bool y
Index: tip/arch/c6x/Kconfig
===================================================================
--- tip.orig/arch/c6x/Kconfig
+++ tip/arch/c6x/Kconfig
@@ -15,7 +15,6 @@ config TMS320C6X
 	select IRQ_DOMAIN
 	select OF
 	select OF_EARLY_FLATTREE
-	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	def_bool n
Index: tip/arch/cris/Kconfig
===================================================================
--- tip.orig/arch/cris/Kconfig
+++ tip/arch/cris/Kconfig
@@ -50,7 +50,6 @@ config CRIS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
-	select HAVE_GENERIC_INIT_TASK
 
 config HZ
 	int
Index: tip/arch/frv/Kconfig
===================================================================
--- tip.orig/arch/frv/Kconfig
+++ tip/arch/frv/Kconfig
@@ -9,7 +9,6 @@ config FRV
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
-	select HAVE_GENERIC_INIT_TASK
 
 config ZONE_DMA
 	bool
Index: tip/arch/h8300/Kconfig
===================================================================
--- tip.orig/arch/h8300/Kconfig
+++ tip/arch/h8300/Kconfig
@@ -5,7 +5,6 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
-	select HAVE_GENERIC_INIT_TASK
 
 config SYMBOL_PREFIX
 	string
Index: tip/arch/hexagon/Kconfig
===================================================================
--- tip.orig/arch/hexagon/Kconfig
+++ tip/arch/hexagon/Kconfig
@@ -28,7 +28,6 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	# mostly generic routines, with some accelerated ones
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
Index: tip/arch/ia64/Kconfig
===================================================================
--- tip.orig/arch/ia64/Kconfig
+++ tip/arch/ia64/Kconfig
@@ -34,7 +34,6 @@ config IA64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: tip/arch/m32r/Kconfig
===================================================================
--- tip.orig/arch/m32r/Kconfig
+++ tip/arch/m32r/Kconfig
@@ -11,7 +11,6 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_INIT_TASK
 
 config SBUS
 	bool
Index: tip/arch/m68k/Kconfig
===================================================================
--- tip.orig/arch/m68k/Kconfig
+++ tip/arch/m68k/Kconfig
@@ -8,7 +8,6 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
-	select HAVE_GENERIC_INIT_TASK
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
Index: tip/arch/microblaze/Kconfig
===================================================================
--- tip.orig/arch/microblaze/Kconfig
+++ tip/arch/microblaze/Kconfig
@@ -22,7 +22,6 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_INIT_TASK
 
 config SWAP
 	def_bool n
Index: tip/arch/mips/Kconfig
===================================================================
--- tip.orig/arch/mips/Kconfig
+++ tip/arch/mips/Kconfig
@@ -30,7 +30,6 @@ config MIPS
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 menu "Machine selection"
 
Index: tip/arch/mn10300/Kconfig
===================================================================
--- tip.orig/arch/mn10300/Kconfig
+++ tip/arch/mn10300/Kconfig
@@ -6,7 +6,6 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
-	select HAVE_GENERIC_INIT_TASK
 
 config AM33_2
 	def_bool n
Index: tip/arch/openrisc/Kconfig
===================================================================
--- tip.orig/arch/openrisc/Kconfig
+++ tip/arch/openrisc/Kconfig
@@ -17,7 +17,6 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
-	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	def_bool y
Index: tip/arch/parisc/Kconfig
===================================================================
--- tip.orig/arch/parisc/Kconfig
+++ tip/arch/parisc/Kconfig
@@ -18,7 +18,6 @@ config PARISC
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
Index: tip/arch/powerpc/Kconfig
===================================================================
--- tip.orig/arch/powerpc/Kconfig
+++ tip/arch/powerpc/Kconfig
@@ -145,7 +145,6 @@ config PPC
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config EARLY_PRINTK
 	bool
Index: tip/arch/s390/Kconfig
===================================================================
--- tip.orig/arch/s390/Kconfig
+++ tip/arch/s390/Kconfig
@@ -123,7 +123,6 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
Index: tip/arch/score/Kconfig
===================================================================
--- tip.orig/arch/score/Kconfig
+++ tip/arch/score/Kconfig
@@ -9,7 +9,6 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
-       select HAVE_GENERIC_INIT_TASK
 
 choice
 	prompt "System type"
Index: tip/arch/sh/Kconfig
===================================================================
--- tip.orig/arch/sh/Kconfig
+++ tip/arch/sh/Kconfig
@@ -29,7 +29,6 @@ config SUPERH
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
Index: tip/arch/sparc/Kconfig
===================================================================
--- tip.orig/arch/sparc/Kconfig
+++ tip/arch/sparc/Kconfig
@@ -31,7 +31,6 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config SPARC32
 	def_bool !64BIT
Index: tip/arch/tile/Kconfig
===================================================================
--- tip.orig/arch/tile/Kconfig
+++ tip/arch/tile/Kconfig
@@ -13,7 +13,6 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select HAVE_GENERIC_INIT_TASK
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
Index: tip/arch/um/Kconfig.common
===================================================================
--- tip.orig/arch/um/Kconfig.common
+++ tip/arch/um/Kconfig.common
@@ -10,7 +10,6 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
-	select HAVE_GENERIC_INIT_TASK
 
 config MMU
 	bool
Index: tip/arch/unicore32/Kconfig
===================================================================
--- tip.orig/arch/unicore32/Kconfig
+++ tip/arch/unicore32/Kconfig
@@ -13,7 +13,6 @@ config UNICORE32
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -83,7 +83,6 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
 	select GENERIC_SMP_IDLE_THREAD
-	select HAVE_GENERIC_INIT_TASK
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
Index: tip/arch/xtensa/Kconfig
===================================================================
--- tip.orig/arch/xtensa/Kconfig
+++ tip/arch/xtensa/Kconfig
@@ -10,7 +10,6 @@ config XTENSA
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
-	select HAVE_GENERIC_INIT_TASK
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
Index: tip/kernel/sched/Makefile
===================================================================
--- tip.orig/kernel/sched/Makefile
+++ tip/kernel/sched/Makefile
@@ -11,9 +11,8 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER
 CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
-obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o
+obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o init_task.o
 obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
-obj-$(CONFIG_HAVE_GENERIC_INIT_TASK) += init_task.o


