Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2FNNXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:23:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40401 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2FNNXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:23:05 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm: complement page reclaim comment
Date: Thu, 14 Jun 2012 21:22:38 +0800
Message-Id: <1339680158-26657-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ed823df..603c96f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3203,6 +3203,7 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
  * Reasons page might not be evictable:
  * (1) page's mapping marked unevictable
  * (2) page is part of an mlocked VMA
+ * (3) page mapped into SHM_LOCK'd shared memory regions
  *
  */
 int page_evictable(struct page *page, struct vm_area_struct *vma)
-- 
1.7.9.5

