Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2HHOQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:16:14 -0400
Received: from mail.x86-64.org ([217.9.48.20]:41729 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab2HHOQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:16:09 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] sched: Fix __sched_period comment
Date: Wed,  8 Aug 2012 16:16:04 +0200
Message-Id: <1344435364-18632-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

It should be sched_nr_latency so fix it before it annoys me more.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d0cc03b3e70b..67ac0b1abf7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -597,7 +597,7 @@ calc_delta_fair(unsigned long delta, struct sched_entity *se)
 /*
  * The idea is to set a period in which each task runs once.
  *
- * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
+ * When there are too many tasks (sched_nr_latency) we have to stretch
  * this period because otherwise the slices get too small.
  *
  * p = (nr <= nl) ? l : l*nr/nl
-- 
1.7.11.rc1

