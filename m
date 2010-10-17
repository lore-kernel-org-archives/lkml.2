Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0JQSF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:05:59 -0400
Received: from [69.28.251.93] ([69.28.251.93]:56187 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab0JQSF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:05:58 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <ffainelli@freebox.fr>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/9] MIPS: Add BMIPS processor types to Kconfig
Date: Sun, 17 Oct 2010 10:56:53 -0700
Message-Id: <584a8c475b66c7ccdd112fb6afda8491@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[v2: add "VIPER" marketing name for BMIPS4350]

Add processor feature definitions for BMIPS3300, BMIPS4350, BMIPS4380,
and BMIPS5000.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/Kconfig |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5526faa..f161e9f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1332,6 +1332,57 @@ config CPU_CAVIUM_OCTEON
 	  can have up to 16 Mips64v2 cores and 8 integrated gigabit ethernets.
 	  Full details can be found at http://www.caviumnetworks.com.
 
+config CPU_BMIPS3300
+	bool "BMIPS3300"
+	depends on SYS_HAS_CPU_BMIPS3300
+	select DMA_NONCOHERENT
+	select IRQ_CPU
+	select SWAP_IO_SPACE
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select WEAK_ORDERING
+	help
+	  Broadcom BMIPS3300 processors.
+
+config CPU_BMIPS4350
+	bool "BMIPS4350"
+	depends on SYS_HAS_CPU_BMIPS4350
+	select CPU_SUPPORTS_32BIT_KERNEL
+	select DMA_NONCOHERENT
+	select IRQ_CPU
+	select SWAP_IO_SPACE
+	select SYS_SUPPORTS_SMP
+	select SYS_SUPPORTS_HOTPLUG_CPU
+	select WEAK_ORDERING
+	help
+	  Broadcom BMIPS4350 ("VIPER") processors.
+
+config CPU_BMIPS4380
+	bool "BMIPS4380"
+	depends on SYS_HAS_CPU_BMIPS4380
+	select CPU_SUPPORTS_32BIT_KERNEL
+	select DMA_NONCOHERENT
+	select IRQ_CPU
+	select SWAP_IO_SPACE
+	select SYS_SUPPORTS_SMP
+	select SYS_SUPPORTS_HOTPLUG_CPU
+	select WEAK_ORDERING
+	help
+	  Broadcom BMIPS4380 processors.
+
+config CPU_BMIPS5000
+	bool "BMIPS5000"
+	depends on SYS_HAS_CPU_BMIPS5000
+	select CPU_SUPPORTS_32BIT_KERNEL
+	select CPU_SUPPORTS_HIGHMEM
+	select DMA_NONCOHERENT
+	select IRQ_CPU
+	select SWAP_IO_SPACE
+	select SYS_SUPPORTS_SMP
+	select SYS_SUPPORTS_HOTPLUG_CPU
+	select WEAK_ORDERING
+	help
+	  Broadcom BMIPS5000 processors.
+
 endchoice
 
 if CPU_LOONGSON2F
@@ -1450,6 +1501,18 @@ config SYS_HAS_CPU_SB1
 config SYS_HAS_CPU_CAVIUM_OCTEON
 	bool
 
+config SYS_HAS_CPU_BMIPS3300
+	bool
+
+config SYS_HAS_CPU_BMIPS4350
+	bool
+
+config SYS_HAS_CPU_BMIPS4380
+	bool
+
+config SYS_HAS_CPU_BMIPS5000
+	bool
+
 #
 # CPU may reorder R->R, R->W, W->R, W->W
 # Reordering beyond LL and SC is handled in WEAK_REORDERING_BEYOND_LLSC
-- 
1.7.0.4

