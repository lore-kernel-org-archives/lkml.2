Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966323Ab2CANbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:31:20 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62288 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966258Ab2CANbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:31:17 -0500
Date: Thu, 1 Mar 2012 14:29:08 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 4/4] ARM: use the new linux/sizes.h
Message-ID: <2ec6cf32ff4e5dbdf7fa6ad58bac5dc959d0c875.1330607068.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1330607068.git.rubini@gnudd.com>
In-Reply-To: <cover.1330607068.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/arm/include/asm/memory.h |    2 +-
 arch/arm/mm/dma-mapping.c     |    2 +-
 arch/arm/mm/init.c            |    2 +-
 arch/arm/mm/ioremap.c         |    2 +-
 arch/arm/mm/mmu.c             |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index a8997d7..5848eba 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -16,7 +16,7 @@
 #include <linux/compiler.h>
 #include <linux/const.h>
 #include <linux/types.h>
-#include <asm/sizes.h>
+#include <linux/sizes.h>
 
 #ifdef CONFIG_NEED_MACH_MEMORY_H
 #include <mach/memory.h>
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index db23ae4..364defd 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -19,12 +19,12 @@
 #include <linux/dma-mapping.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
+#include <linux/sizes.h>
 
 #include <asm/memory.h>
 #include <asm/highmem.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/sizes.h>
 #include <asm/mach/arch.h>
 
 #include "mm.h"
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 595079f..288b77d 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -20,13 +20,13 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/sizes.h>
 
 #include <asm/mach-types.h>
 #include <asm/memblock.h>
 #include <asm/prom.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
-#include <asm/sizes.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 66daf17..1d24bef 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/sizes.h>
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
@@ -32,7 +33,6 @@
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
-#include <asm/sizes.h>
 
 #include <asm/mach/map.h>
 #include "mm.h"
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index f77f1db..f3ee2b8 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -16,13 +16,13 @@
 #include <linux/memblock.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
+#include <linux/sizes.h>
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 #include <asm/sections.h>
 #include <asm/cachetype.h>
 #include <asm/setup.h>
-#include <asm/sizes.h>
 #include <asm/smp_plat.h>
 #include <asm/tlb.h>
 #include <asm/highmem.h>
-- 
1.7.7.2
