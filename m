Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1G2GTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:19:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53150 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1G2GTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:19:34 -0400
Date: Fri, 29 Jul 2011 16:19:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729161931.a9c9108c233640f3c2d7b24e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (powerpc
allnoconfig) failed like this:

arch/powerpc/mm/mmu_context_hash32.c:76:1: error: data definition has no type or storage class
arch/powerpc/mm/mmu_context_hash32.c:76:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/powerpc/mm/mmu_context_hash32.c:76:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/mmu_context_hash32.c:95:1: error: data definition has no type or storage class
arch/powerpc/mm/mmu_context_hash32.c:95:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/powerpc/mm/mmu_context_hash32.c:95:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/mm/tlb_hash32.c:48:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_hash32.c:48:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_hash32.c:48:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_hash32.c:128:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_hash32.c:128:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_hash32.c:128:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_hash32.c:151:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_hash32.c:151:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_hash32.c:151:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_hash32.c:167:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_hash32.c:167:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_hash32.c:167:1: error: parameter names (without types) in function declaration
arch/powerpc/mm/tlb_hash32.c:179:1: error: data definition has no type or storage class
arch/powerpc/mm/tlb_hash32.c:179:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/mm/tlb_hash32.c:179:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/kernel/pci_32.c:51:1: error: data definition has no type or storage class
arch/powerpc/kernel/pci_32.c:51:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/powerpc/kernel/pci_32.c:51:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/pci_32.c:190:1: error: data definition has no type or storage class
arch/powerpc/kernel/pci_32.c:190:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/pci_32.c:190:1: error: parameter names (without types) in function declaration
cc1: warnings being treated as errors
arch/powerpc/kernel/iomap.c:36:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:36:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:36:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:37:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:37:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:37:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:38:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:38:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:38:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:39:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:39:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:39:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:40:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:40:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:40:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:62:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:62:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:62:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:63:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:63:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:63:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:64:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:64:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:64:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:65:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:65:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:65:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:66:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:66:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:66:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:88:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:88:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:88:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:89:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:89:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:89:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:90:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:90:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:90:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:104:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:104:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:104:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:105:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:105:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:105:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:106:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:106:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:106:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:117:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:117:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:117:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:118:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:118:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:118:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:147:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:147:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:147:1: error: parameter names (without types) in function declaration
arch/powerpc/kernel/iomap.c:148:1: error: data definition has no type or storage class
arch/powerpc/kernel/iomap.c:148:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/powerpc/kernel/iomap.c:148:1: error: parameter names (without types) in function declaration

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jul 2011 16:15:26 +1000
Subject: [PATCH] powerpc32: include export.h for EXPORT_SYMBOL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/iomap.c          |    1 +
 arch/powerpc/kernel/pci_32.c         |    1 +
 arch/powerpc/mm/mmu_context_hash32.c |    1 +
 arch/powerpc/mm/tlb_hash32.c         |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap.c
index 1577434..2735872 100644
--- a/arch/powerpc/kernel/iomap.c
+++ b/arch/powerpc/kernel/iomap.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/mm.h>
+#include <linux/export.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
 
diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
index bb15451..fdd1a3d 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/slab.h>
+#include <linux/export.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/mm/mmu_context_hash32.c b/arch/powerpc/mm/mmu_context_hash32.c
index d0ee554..78fef67 100644
--- a/arch/powerpc/mm/mmu_context_hash32.c
+++ b/arch/powerpc/mm/mmu_context_hash32.c
@@ -24,6 +24,7 @@
 
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/export.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
diff --git a/arch/powerpc/mm/tlb_hash32.c b/arch/powerpc/mm/tlb_hash32.c
index 9a445f6..558e30c 100644
--- a/arch/powerpc/mm/tlb_hash32.c
+++ b/arch/powerpc/mm/tlb_hash32.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/export.h>
 
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
