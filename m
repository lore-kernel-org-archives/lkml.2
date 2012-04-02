Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2DBICI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:02:08 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62512 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBICG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:02:06 -0400
Message-ID: <4F795CAC.9080206@ct.jp.nec.com>
Date: Mon, 02 Apr 2012 17:00:44 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Update document and comment
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Change sched_*.c to sched/*.c in document and comment.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 Documentation/scheduler/sched-design-CFS.txt |    6 +++---
 include/linux/sched.h                        |    2 +-
 kernel/sched/idle_task.c                     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 91ecff0..d529e02d 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -130,7 +130,7 @@ CFS implements three scheduling policies:
     idle timer scheduler in order to avoid to get into priority
     inversion problems which would deadlock the machine.
 
-SCHED_FIFO/_RR are implemented in sched_rt.c and are as specified by
+SCHED_FIFO/_RR are implemented in sched/rt.c and are as specified by
 POSIX.
 
 The command chrt from util-linux-ng 2.13.1.1 can set all of these except
@@ -145,9 +145,9 @@ Classes," an extensible hierarchy of scheduler modules.  These modules
 encapsulate scheduling policy details and are handled by the scheduler core
 without the core code assuming too much about them.
 
-sched_fair.c implements the CFS scheduler described above.
+sched/fair.c implements the CFS scheduler described above.
 
-sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler way than
+sched/rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler way than
 the previous vanilla scheduler did.  It uses 100 runqueues (for all 100 RT
 priority levels, instead of 140 in the previous scheduler) and it needs no
 expired array.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cff94cd..714fa99 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1954,7 +1954,7 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
  */
 extern unsigned long long notrace sched_clock(void);
 /*
- * See the comment in kernel/sched_clock.c
+ * See the comment in kernel/sched/clock.c
  */
 extern u64 cpu_clock(int cpu);
 extern u64 local_clock(void);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 91b4c95..b44d604 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -4,7 +4,7 @@
  * idle-task scheduling class.
  *
  * (NOTE: these are not related to SCHED_IDLE tasks which are
- *  handled in sched_fair.c)
+ *  handled in sched/fair.c)
  */
 
 #ifdef CONFIG_SMP
-- 
1.7.7.6

