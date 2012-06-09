Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2FILXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:23:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59867 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2FILXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:23:21 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH] mm/memory.c:fix the coding format of memory.c
Date: Sat,  9 Jun 2012 19:22:53 +0800
Message-Id: <1339240973-5649-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Fix the line longer than 80 of cow_user_page function.

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
---
 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1b7dc66..195d6e1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2447,7 +2447,8 @@ static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 	return same;
 }
 
-static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
+static inline void cow_user_page(struct page *dst, struct page *src,
+		unsigned long va, struct vm_area_struct *vma)
 {
 	/*
 	 * If the source page was a PFN mapping, we don't have
-- 
1.7.9.5

