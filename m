Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab2EYPsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:48:45 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:51487 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab2EYPsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:48:41 -0400
Date: Fri, 25 May 2012 17:48:23 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 3/6] ARM: use the new linux/sizes.h
Message-ID: <178b211f0a8f255dc14488224948384f478c0d2c.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1337959750.git.rubini@gnudd.com>
In-Reply-To: <cover.1337959750.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/memory.h |    2 +-
 arch/arm/mm/dma-mapping.c     |    2 +-
 arch/arm/mm/init.c            |    2 +-
 arch/arm/mm/ioremap.c         |    2 +-
 arch/arm/mm/mmu.c             |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index fcb5757..e965f1b 100644
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
index ea6b431..30a031c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -23,12 +23,12 @@
 #include <linux/slab.h>
 #include <linux/iommu.h>
 #include <linux/vmalloc.h>
+#include <linux/sizes.h>
 
 #include <asm/memory.h>
 #include <asm/highmem.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/sizes.h>
 #include <asm/mach/arch.h>
 #include <asm/dma-iommu.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c21d06c..ad7fd8a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -21,13 +21,13 @@
 #include <linux/gfp.h>
 #include <linux/memblock.h>
 #include <linux/dma-contiguous.h>
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
index 4f55f50..566750f 100644
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
 #include <asm/system_info.h>
 
 #include <asm/mach/map.h>
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e5dad60..2196116 100644
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
