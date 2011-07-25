Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1GYUU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab1GYUUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:20:25 -0400
From: Johannes Weiner <jweiner@redhat.com>
To: linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/5] mm: writeback: remove seriously stale comment on dirty limits
Date: Mon, 25 Jul 2011 22:19:17 +0200
Message-Id: <1311625159-13771-4-git-send-email-jweiner@redhat.com>
In-Reply-To: <1311625159-13771-1-git-send-email-jweiner@redhat.com>
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page-writeback.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a4de005..41dc871 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -379,24 +379,6 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
 /*
- * Work out the current dirty-memory clamping and background writeout
- * thresholds.
- *
- * The main aim here is to lower them aggressively if there is a lot of mapped
- * memory around.  To avoid stressing page reclaim with lots of unreclaimable
- * pages.  It is better to clamp down on writers than to start swapping, and
- * performing lots of scanning.
- *
- * We only allow 1/2 of the currently-unmapped memory to be dirtied.
- *
- * We don't permit the clamping level to fall below 5% - that is getting rather
- * excessive.
- *
- * We make sure that the background writeout level is below the adjusted
- * clamping level.
- */
-
-/*
  * global_dirty_limits - background-writeback and dirty-throttling thresholds
  *
  * Calculate the dirty thresholds based on sysctl parameters
-- 
1.7.6

