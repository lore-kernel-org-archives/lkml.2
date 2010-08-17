Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0HQH4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:56:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:47122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab0HQH4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:56:01 -0400
Date: Tue, 17 Aug 2010 07:55:36 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jkacur@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkacur@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1281021054-4228-2-git-send-email-jkacur@redhat.com>
References: <1281021054-4228-2-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockup detector: Fix grammar by adding a missing "to" in the comments
Message-ID: <tip-6a103b0d44e9f97dc430002cf3ac7a7defa3819f@git.kernel.org>
Git-Commit-ID: 6a103b0d44e9f97dc430002cf3ac7a7defa3819f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 07:55:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a103b0d44e9f97dc430002cf3ac7a7defa3819f
Gitweb:     http://git.kernel.org/tip/6a103b0d44e9f97dc430002cf3ac7a7defa3819f
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Thu, 5 Aug 2010 17:10:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Aug 2010 09:11:52 +0200

lockup detector: Fix grammar by adding a missing "to" in the comments

This fixes a minor grammar problem in the comments in
hung_task.c

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1281021054-4228-2-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hung_task.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index bca9423..53ead17 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -111,7 +111,7 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
  * periodically exit the critical section and enter a new one.
  *
  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
- * exit the grace period. For classic RCU, a reschedule is required.
+ * to exit the grace period. For classic RCU, a reschedule is required.
  */
 static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
 {
