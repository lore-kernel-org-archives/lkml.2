Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab2AJA0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:26:11 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50052 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab2AJA0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:26:09 -0500
Message-ID: <4F0B8525.8070901@ct.jp.nec.com>
Date: Tue, 10 Jan 2012 09:24:05 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: Remove empty #ifdef
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Just remove empty #ifdef directive part.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/sched/core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4dbfd04..457c881 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7136,10 +7136,6 @@ void set_curr_task(int cpu, struct task_struct *p)
 
 #endif
 
-#ifdef CONFIG_RT_GROUP_SCHED
-#else /* !CONFIG_RT_GROUP_SCHED */
-#endif /* CONFIG_RT_GROUP_SCHED */
-
 #ifdef CONFIG_CGROUP_SCHED
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
@@ -7248,9 +7244,6 @@ void sched_move_task(struct task_struct *tsk)
 }
 #endif /* CONFIG_CGROUP_SCHED */
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-#endif
-
 #if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
-- 
1.7.7.5

