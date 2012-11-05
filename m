Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab2KEXFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37904 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab2KEXFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:18 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 030/104] arch/mips: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:47 -0800
Message-Id: <1352156701-4038-31-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/Kconfig |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dba9390..e66c2d4 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -169,7 +169,7 @@ config MACH_DECSTATION
 	select SYS_HAS_CPU_R3000
 	select SYS_HAS_CPU_R4X00
 	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_64BIT_KERNEL if EXPERIMENTAL
+	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_128HZ
 	select SYS_SUPPORTS_256HZ
@@ -395,7 +395,6 @@ config PNX8550_STB810
 
 config PMC_MSP
 	bool "PMC-Sierra MSP chipsets"
-	depends on EXPERIMENTAL
 	select CEVT_R4K
 	select CSRC_R4K
 	select DMA_NONCOHERENT
@@ -515,8 +514,7 @@ config SGI_IP27
 	  here.
 
 config SGI_IP28
-	bool "SGI IP28 (Indigo2 R10k) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "SGI IP28 (Indigo2 R10k)"
 	select ARC
 	select ARC64
 	select BOOT_ELF64
@@ -574,7 +572,6 @@ config SGI_IP32
 
 config SIBYTE_CRHINE
 	bool "Sibyte BCM91120C-CRhine"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -585,7 +582,6 @@ config SIBYTE_CRHINE
 
 config SIBYTE_CARMEL
 	bool "Sibyte BCM91120x-Carmel"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1120
@@ -596,7 +592,6 @@ config SIBYTE_CARMEL
 
 config SIBYTE_CRHONE
 	bool "Sibyte BCM91125C-CRhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125
@@ -608,7 +603,6 @@ config SIBYTE_CRHONE
 
 config SIBYTE_RHONE
 	bool "Sibyte BCM91125E-Rhone"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select SIBYTE_BCM1125H
@@ -633,7 +627,6 @@ config SIBYTE_SWARM
 
 config SIBYTE_LITTLESUR
 	bool "Sibyte BCM91250C2-LittleSur"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select HAVE_PATA_PLATFORM
@@ -647,7 +640,6 @@ config SIBYTE_LITTLESUR
 
 config SIBYTE_SENTOSA
 	bool "Sibyte BCM91250E-Sentosa"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select DMA_COHERENT
 	select NR_CPUS_DEFAULT_2
@@ -799,7 +791,6 @@ config CAVIUM_OCTEON_REFERENCE_BOARD
 
 config NLM_XLR_BOARD
 	bool "Netlogic XLR/XLS based systems"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLR
@@ -828,7 +819,6 @@ config NLM_XLR_BOARD
 
 config NLM_XLP_BOARD
 	bool "Netlogic XLP based systems"
-	depends on EXPERIMENTAL
 	select BOOT_ELF32
 	select NLM_COMMON
 	select SYS_HAS_CPU_XLP
@@ -1405,7 +1395,6 @@ config CPU_R5500
 
 config CPU_R6000
 	bool "R6000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R6000
 	select CPU_SUPPORTS_32BIT_KERNEL
 	help
@@ -1422,7 +1411,6 @@ config CPU_NEVADA
 
 config CPU_R8000
 	bool "R8000"
-	depends on EXPERIMENTAL
 	depends on SYS_HAS_CPU_R8000
 	select CPU_HAS_PREFETCH
 	select CPU_SUPPORTS_64BIT_KERNEL
@@ -1831,7 +1819,7 @@ config PAGE_SIZE_32KB
 
 config PAGE_SIZE_64KB
 	bool "64kB"
-	depends on EXPERIMENTAL && !CPU_R3000 && !CPU_TX39XX
+	depends on !CPU_R3000 && !CPU_TX39XX
 	help
 	  Using 64kB page size will result in higher performance kernel at
 	  the price of higher memory consumption.  This option is available on
@@ -2348,8 +2336,7 @@ config HZ
 source "kernel/Kconfig.preempt"
 
 config KEXEC
-	bool "Kexec system call (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Kexec system call"
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
-- 
1.7.9.5

