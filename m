Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1KRXoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:44:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1KRXox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:44:53 -0500
Date: Fri, 18 Nov 2011 15:44:27 -0800
From: tip-bot for Richard Weinberger <richard@nod.at>
Message-ID: <tip-60686317da05049385eae86e44c710cde535f95f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, richard@nod.at, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, richard@nod.at, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1321117677-3282-1-git-send-email-richard@nod.at>
References: <1321117677-3282-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix comment for requeue_rt_entity
Git-Commit-ID: 60686317da05049385eae86e44c710cde535f95f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:44:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60686317da05049385eae86e44c710cde535f95f
Gitweb:     http://git.kernel.org/tip/60686317da05049385eae86e44c710cde535f95f
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Sat, 12 Nov 2011 18:07:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 08:48:27 +0100

sched: Fix comment for requeue_rt_entity

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1321117677-3282-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 583a136..d95e861 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -957,8 +957,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 }
 
 /*
- * Put task to the end of the run list without the overhead of dequeue
- * followed by enqueue.
+ * Put task to the head or the end of the run list without the overhead of
+ * dequeue followed by enqueue.
  */
 static void
 requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
