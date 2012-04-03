Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2DCOPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:15:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12494 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab2DCOK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:10:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 03 Apr 2012 16:10:06 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv24 01/16] mm: page_alloc: remove trailing whitespace
In-reply-to: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
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
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sandeep Patil <psandeep.s@gmail.com>
Message-id: <1333462221-3987-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.1
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
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
index a712fb9..0922308 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -513,10 +513,10 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
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
@@ -1061,17 +1061,17 @@ retry_reserve:
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
@@ -4301,7 +4301,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
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

