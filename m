Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0HZSPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:15:55 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53688 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab0HZSOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:49 -0400
Message-Id: <20100826181340.329791221@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 04/11] sched: debug cleanup place entity
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-debug-cleanup-place-entity.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extracted from a "sched-misc-bits.patch" patch from
Peter Zijlstra <a.p.zijlstra@chello.nl>.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -749,9 +749,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-	vruntime = max_vruntime(se->vruntime, vruntime);
-
-	se->vruntime = vruntime;
+	se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void

