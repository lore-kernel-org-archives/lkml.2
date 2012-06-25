Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2FYLPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:15:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2FYLPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:15:43 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH v4 1/2] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Mon, 25 Jun 2012 19:15:34 +0800
Message-Id: <1340622934-13091-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since LRU_ALL_EVICTABLE is useless, just remove it.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68c569f..8b10c35 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -209,7 +209,6 @@ struct lruvec {
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate clean file */
-- 
1.7.9.5

