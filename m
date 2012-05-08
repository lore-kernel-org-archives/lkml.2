Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2EHEVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:21:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2EHEVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:21:52 -0400
Date: Mon, 7 May 2012 21:21:37 -0700
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-489a71b029cd94e3b0132795146e8be3a87bf3fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <4F795CAC.9080206@ct.jp.nec.com>
References: <4F795CAC.9080206@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Update documentation and comments
Git-Commit-ID: 489a71b029cd94e3b0132795146e8be3a87bf3fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:21:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  489a71b029cd94e3b0132795146e8be3a87bf3fa
Gitweb:     http://git.kernel.org/tip/489a71b029cd94e3b0132795146e8be3a87bf3fa
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Mon, 2 Apr 2012 17:00:44 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 15:04:18 +0200

sched: Update documentation and comments

Change sched_*.c to sched/*.c in documentation and comments.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F795CAC.9080206@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 81a173c..4a559bf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1950,7 +1950,7 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
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
