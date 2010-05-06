Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab0EFRiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360Ab0EFRiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:38:03 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/13] mn10300: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:10 +0200
Message-Id: <1273167377-14270-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/mn10300/include/asm/pgtable.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/mn10300/include/asm/pgtable.h b/arch/mn10300/include/asm/pgtable.h
index 16d8857..ace79eb 100644
--- a/arch/mn10300/include/asm/pgtable.h
+++ b/arch/mn10300/include/asm/pgtable.h
@@ -213,8 +213,6 @@ do {							\
 
 #define pages_to_mb(x) ((x) >> (20 - PAGE_SHIFT))
 
-#ifndef __ASSEMBLY__
-
 /*
  * The following only work if pte_present() is true.
  * Undefined behaviour if not..
@@ -468,8 +466,6 @@ static inline int set_kernel_exec(unsigned long vaddr, int enable)
 extern void update_mmu_cache(struct vm_area_struct *vma,
 			     unsigned long address, pte_t *ptep);
 
-#endif /* !__ASSEMBLY__ */
-
 #define kern_addr_valid(addr)	(1)
 
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
-- 
1.6.6.1

