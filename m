Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2BVQtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:49:07 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16180 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2BVQtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:49:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 22 Feb 2012 17:48:42 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv23 01/16] mm: page_alloc: remove trailing whitespace
In-reply-to: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1329929337-16648-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 896cd4f..ba50b48 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -526,10 +526,10 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
  * free pages of length of (1 << order) and marked with _mapcount -2. Page's
  * order is recorded in page_private(page) field.
  * So when we are allocating or freeing one, we can derive the state of the
- * other.  That is, if we allocate a small block, and both were   
- * free, the remainder of the region must be split into blocks.   
+ * other.  That is, if we allocate a small block, and both were
+ * free, the remainder of the region must be split into blocks.
  * If a block is freed, and its buddy is also free, then this
- * triggers coalescing into a block of larger size.            
+ * triggers coalescing into a block of larger size.
  *
  * -- wli
  */
@@ -1074,17 +1074,17 @@ retry_reserve:
 	return page;
 }
 
-/* 
+/*
  * Obtain a specified number of elements from the buddy allocator, all under
  * a single hold of the lock, for efficiency.  Add them to the supplied list.
  * Returns the number of new pages which were placed at *list.
  */
-static int rmqueue_bulk(struct zone *zone, unsigned int order, 
+static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
 	int i;
-	
+
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype);
@@ -4309,7 +4309,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	pgdat->kswapd_max_order = 0;
 	pgdat_page_cgroup_init(pgdat);
-	
+
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
-- 
1.7.1.569.g6f426

