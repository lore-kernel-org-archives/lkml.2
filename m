Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0JNHnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:43:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:37761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0JNHnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:43:12 -0400
Date: Thu, 14 Oct 2010 07:42:37 GMT
From: tip-bot for Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yoshikawa.takuya@oss.ntt.co.jp, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yoshikawa.takuya@oss.ntt.co.jp, mingo@elte.hu
In-Reply-To: <20101014160913.eb24fef4.yoshikawa.takuya@oss.ntt.co.jp>
References: <20101014160913.eb24fef4.yoshikawa.takuya@oss.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Comment updates: fix default latency and granularity numbers
Message-ID: <tip-864616ee6785d9fac7a2cd80c01a2da89579f2e4@git.kernel.org>
Git-Commit-ID: 864616ee6785d9fac7a2cd80c01a2da89579f2e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:42:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  864616ee6785d9fac7a2cd80c01a2da89579f2e4
Gitweb:     http://git.kernel.org/tip/864616ee6785d9fac7a2cd80c01a2da89579f2e4
Author:     Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
AuthorDate: Thu, 14 Oct 2010 16:09:13 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 09:13:35 +0200

sched: Comment updates: fix default latency and granularity numbers

Targeted preemption latency and minimal preemption granularity
for CPU-bound tasks have been changed.

This patch updates the comments about these values.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20101014160913.eb24fef4.yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 623e9ac..bf87192 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -25,7 +25,7 @@
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
- * (default: 5ms * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 6ms * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * NOTE: this latency value is not the same as the concept of
  * 'timeslice length' - timeslices in CFS are of variable length
@@ -52,7 +52,7 @@ enum sched_tunable_scaling sysctl_sched_tunable_scaling
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 0.75 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
 unsigned int sysctl_sched_min_granularity = 750000ULL;
 unsigned int normalized_sysctl_sched_min_granularity = 750000ULL;
