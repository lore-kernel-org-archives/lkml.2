Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2FQB1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 21:27:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36845 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab2FQB13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 21:27:29 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: linux-mm@kvack.org
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/vmscan: cleanup comment error in balance_pgdat
Date: Sun, 17 Jun 2012 09:27:18 +0800
Message-Id: <1339896438-5412-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2fc16cf..375d073 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2539,7 +2539,7 @@ loop_again:
 				 * consider it to be no longer congested. It's
 				 * possible there are dirty pages backed by
 				 * congested BDIs but as pressure is relieved,
-				 * spectulatively avoid congestion waits
+				 * speculatively avoid congestion waits
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
 				if (i <= *classzone_idx)
-- 
1.7.9.5

