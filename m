Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2AJRUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:20:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2AJRUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:20:08 -0500
Date: Tue, 10 Jan 2012 09:19:44 -0800
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Message-ID: <tip-9b9fb610f6800e0db46cccd8618dd7e609c9bb5a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F0B8525.8070901@ct.jp.nec.com>
References: <4F0B8525.8070901@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove empty #ifdefs
Git-Commit-ID: 9b9fb610f6800e0db46cccd8618dd7e609c9bb5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 10 Jan 2012 09:19:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b9fb610f6800e0db46cccd8618dd7e609c9bb5a
Gitweb:     http://git.kernel.org/tip/9b9fb610f6800e0db46cccd8618dd7e609c9bb5a
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Tue, 10 Jan 2012 09:24:05 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Jan 2012 09:57:41 +0100

sched: Remove empty #ifdefs

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F0B8525.8070901@ct.jp.nec.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
