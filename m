Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1G2Gsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:48:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37578 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab1G2Gs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:48:29 -0400
Date: Fri, 29 Jul 2011 16:48:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729164825.4bccf9a2924de6d4fedabd6b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
ppx44x_defconfig) failed like this:

cc1: warnings being treated as errors
arch/powerpc/mm/tlb_nohash.c:137:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_nohash.c:137:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_nohash.c:137:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_nohash.c:156:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_nohash.c:156:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_nohash.c:156:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_nohash.c:301:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_nohash.c:301:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_nohash.c:301:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_nohash.c:315:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_nohash.c:315:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_nohash.c:315:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/platforms/44x/sam440ep.c:59:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/sam440ep.c:59:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/sam440ep.c:59:1: error: parameter names (without types) in function declaration
arch/powerpc/sysdev/ppc4xx_msi.c:265:15: error: 'THIS_MODULE' undeclared here (not in a function)
cc1: warnings being treated as errors
arch/powerpc/platforms/44x/ppc44x_simple.c:83:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/ppc44x_simple.c:83:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/ppc44x_simple.c:83:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/dma-noncoherent.c:250:1: error: data definition has no type or storage class
arch/powerpc/mm/dma-noncoherent.c:250:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/dma-noncoherent.c:250:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/dma-noncoherent.c:312:1: error: data definition has no type or storage class
arch/powerpc/mm/dma-noncoherent.c:312:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/dma-noncoherent.c:312:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/dma-noncoherent.c:343:1: error: data definition has no type or storage class
arch/powerpc/mm/dma-noncoherent.c:343:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/dma-noncoherent.c:343:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/dma-noncoherent.c:401:1: error: data definition has no type or storage class
arch/powerpc/mm/dma-noncoherent.c:401:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/dma-noncoherent.c:401:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/platforms/44x/warp.c:57:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/warp.c:57:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/warp.c:57:1: error: parameter names (without types) in function declaration
arch/powerpc/platforms/44x/warp.c:318:1: error: data definition has no type or storage classcc1: warnings being treated as errors
arch/powerpc/platforms/44x/virtex.c:54:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/virtex.c:54:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/virtex.c:54:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/platforms/44x/ebony.c:62:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/ebony.c:62:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/ebony.c:62:1: error: parameter names (without types) in function declaration
arch/powerpc/platforms/44x/warp.c:318:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/warp.c:318:1: error: parameter names (without types) in function declaration
arch/powerpc/platforms/44x/warp.c:319:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/warp.c:319:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/warp.c:319:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/platforms/44x/canyonlands.c:126:1: error: data definition has no type or storage class
arch/powerpc/platforms/44x/canyonlands.c:126:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/platforms/44x/canyonlands.c:126:1: error: parameter names (without types) in function declaration
arch/powerpc/kvm/44x.c: In function 'kvmppc_44x_init':
arch/powerpc/kvm/44x.c:168:59: error: 'THIS_MODULE' undeclared (first use in this function)
arch/powerpc/kvm/44x.c:169:1: error: control reaches end of non-void function

I have added this patch for today:

>From a2af733fcb26084a9a79e16d127e84900c9094e4 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 16:42:37 +1000
Subject: [PATCH] powerpc/44x: include export.h for EXPORT_SYMBOL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/machdep.h |    1 +
 arch/powerpc/kvm/44x.c             |    1 +
 arch/powerpc/mm/dma-noncoherent.c  |    1 +
 arch/powerpc/mm/tlb_nohash.c       |    1 +
 arch/powerpc/platforms/44x/warp.c  |    1 +
 arch/powerpc/sysdev/ppc4xx_msi.c   |    1 +
 6 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 47cacdd..7fa31ce 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -12,6 +12,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/export.h>
 
 #include <asm/setup.h>
 
diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index da3a122..94fc29c 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -20,6 +20,7 @@
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/export.h>
 
 #include <asm/reg.h>
 #include <asm/cputable.h>
diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index b42f76c..329be36 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -30,6 +30,7 @@
 #include <linux/types.h>
 #include <linux/highmem.h>
 #include <linux/dma-mapping.h>
+#include <linux/export.h>
 
 #include <asm/tlbflush.h>
 
diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
index d32ec64..ea9309e 100644
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
+#include <linux/export.h>
 
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
index 8f77139..4cfa499 100644
--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -18,6 +18,7 @@
 #include <linux/of_gpio.h>
 #include <linux/of_i2c.h>
 #include <linux/slab.h>
+#include <linux/export.h>
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
index 367af02..1c2d7af 100644
--- a/arch/powerpc/sysdev/ppc4xx_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_msi.c
@@ -27,6 +27,7 @@
 #include <linux/msi.h>
 #include <linux/of_platform.h>
 #include <linux/interrupt.h>
+#include <linux/export.h>
 #include <asm/prom.h>
 #include <asm/hw_irq.h>
 #include <asm/ppc-pci.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
