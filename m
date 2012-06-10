Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2FJCvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:51:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36015 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2FJCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:51:08 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] arch/x86/mm: fix some kernel-doc warnings
Date: Sun, 10 Jun 2012 10:50:52 +0800
Message-Id: <1339296652-2935-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Fix kernel-doc warnings in arch/x86/mm/ioremap.c and
arch/x86/mm/pageattr.c, just like this one:

Warning(arch/x86/mm/ioremap.c:204): No description found for parameter 'phys_addr'
Warning(arch/x86/mm/ioremap.c:204): Excess function parameter 'offset' description in 'ioremap_nocache'

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 arch/x86/mm/ioremap.c  |    4 ++--
 arch/x86/mm/pageattr.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index be1ef57..78fe3f1 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -180,7 +180,7 @@ err_free_memtype:
 
 /**
  * ioremap_nocache     -   map bus memory into CPU space
- * @offset:    bus address of the memory
+ * @phys_addr:    bus address of the memory
  * @size:      size of the resource to map
  *
  * ioremap_nocache performs a platform specific sequence of operations to
@@ -217,7 +217,7 @@ EXPORT_SYMBOL(ioremap_nocache);
 
 /**
  * ioremap_wc	-	map memory into CPU space write combined
- * @offset:	bus address of the memory
+ * @phys_addr:	bus address of the memory
  * @size:	size of the resource to map
  *
  * This version of ioremap ensures that the memory is marked write combining.
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..a718e0d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -122,7 +122,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 
 /**
  * clflush_cache_range - flush a cache range with clflush
- * @addr:	virtual start address
+ * @vaddr:	virtual start address
  * @size:	number of bytes to flush
  *
  * clflush is an unordered instruction which needs fencing with mfence
-- 
1.7.9.5

