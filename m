Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1KLRIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 12:08:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:33123 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1KLRIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 12:08:12 -0500
From: Richard Weinberger <richard@nod.at>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] sched: Fix comment for requeue_rt_entity
Date: Sat, 12 Nov 2011 18:07:57 +0100
Message-Id: <1321117677-3282-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/sched_rt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 056cbd2..909ba03 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -954,8 +954,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 }
 
 /*
- * Put task to the end of the run list without the overhead of dequeue
- * followed by enqueue.
+ * Put task to the head or the end of the run list without the overhead of
+ * dequeue followed by enqueue.
  */
 static void
 requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
-- 
1.7.7

