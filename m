Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0JRTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:16:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:59241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab0JRTQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:16:26 -0400
Date: Mon, 18 Oct 2010 19:15:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Unindent labels
Message-ID: <tip-4924627423d5e286136ad2520f5be536345ae590@git.kernel.org>
Git-Commit-ID: 4924627423d5e286136ad2520f5be536345ae590
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:16:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4924627423d5e286136ad2520f5be536345ae590
Gitweb:     http://git.kernel.org/tip/4924627423d5e286136ad2520f5be536345ae590
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun, 17 Oct 2010 21:46:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 18:41:56 +0200

sched: Unindent labels

Labels should be on column 0.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c    |   12 ++++++------
 kernel/sched_rt.c |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2111491..7f52283 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4891,7 +4891,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 
 	cpuset_cpus_allowed(p, cpus_allowed);
 	cpumask_and(new_mask, in_mask, cpus_allowed);
- again:
+again:
 	retval = set_cpus_allowed_ptr(p, new_mask);
 
 	if (!retval) {
@@ -8141,9 +8141,9 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	return 1;
 
- err_free_rq:
+err_free_rq:
 	kfree(cfs_rq);
- err:
+err:
 	return 0;
 }
 
@@ -8231,9 +8231,9 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 	return 1;
 
- err_free_rq:
+err_free_rq:
 	kfree(rt_rq);
- err:
+err:
 	return 0;
 }
 
@@ -8591,7 +8591,7 @@ static int tg_set_bandwidth(struct task_group *tg,
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
- unlock:
+unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index baef30f..ab77aa0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1140,7 +1140,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 	for_each_leaf_rt_rq(rt_rq, rq) {
 		array = &rt_rq->active;
 		idx = sched_find_first_bit(array->bitmap);
- next_idx:
+next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
 		if (next && next->prio < idx)
@@ -1316,7 +1316,7 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
- retry:
+retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
 		return 0;
@@ -1464,7 +1464,7 @@ static int pull_rt_task(struct rq *this_rq)
 			 * but possible)
 			 */
 		}
- skip:
+skip:
 		double_unlock_balance(this_rq, src_rq);
 	}
 
