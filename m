Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab1LPLIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:08:18 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59113 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1LPLIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:08:10 -0500
Message-ID: <4EEB2690.1050401@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 19:08:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: radix_tree: remove radix_tree_indirect_to_ptr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121601-5140-0000-0000-0000006E5799
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used anymore, remove it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/radix-tree.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 9d4539c..07e360b 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -49,9 +49,6 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2

-#define radix_tree_indirect_to_ptr(ptr) \
-	radix_tree_indirect_to_ptr((void __force *)(ptr))
-
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
 	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
-- 
1.7.7.4

