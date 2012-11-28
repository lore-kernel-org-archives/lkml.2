Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2K1Ved (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:34:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47858 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2K1Veb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:34:31 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/13] cpuset: remove unused cpuset_unlock()
Date: Wed, 28 Nov 2012 13:34:08 -0800
Message-Id: <1354138460-19286-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b017887..a423774 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2412,17 +2412,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 }
 
 /**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a file page
  * cpuset_slab_spread_node() - On which node to begin search for a slab page
  *
-- 
1.7.11.7

