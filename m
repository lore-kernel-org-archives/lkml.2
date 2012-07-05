Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2GEG32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:29:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53657 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2GEG31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:29:27 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: replace inexistence move_lock_page_cgroup() by move_lock_mem_cgroup() in comment
Date: Thu,  5 Jul 2012 14:28:53 +0800
Message-Id: <1341469733-12104-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <a>
References: <a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d318f6..63e36e7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1899,7 +1899,7 @@ again:
 		return;
 	/*
 	 * If this memory cgroup is not under account moving, we don't
-	 * need to take move_lock_page_cgroup(). Because we already hold
+	 * need to take move_lock_mem_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
 	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
 	 */
@@ -1921,7 +1921,7 @@ void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
 	/*
 	 * It's guaranteed that pc->mem_cgroup never changes while
 	 * lock is held because a routine modifies pc->mem_cgroup
-	 * should take move_lock_page_cgroup().
+	 * should take move_lock_mem_cgroup().
 	 */
 	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
 }
-- 
1.7.5.4

