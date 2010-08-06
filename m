Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab0HFFPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:15:37 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40344 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689Ab0HFFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:33 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 03/43] memblock: No reason to include asm/memblock.h late
Date: Fri,  6 Aug 2010 15:14:44 +1000
Message-Id: <1281071724-28740-4-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 86e7daf..4b69313 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
+#include <asm/memblock.h>
+
 #define MAX_MEMBLOCK_REGIONS 128
 
 struct memblock_region {
@@ -82,8 +84,6 @@ memblock_end_pfn(struct memblock_type *type, unsigned long region_nr)
 	       memblock_size_pages(type, region_nr);
 }
 
-#include <asm/memblock.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_MEMBLOCK_H */
-- 
1.7.0.4

