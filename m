Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1JLDBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:01:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51152 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1JLDBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:01:07 -0400
From: hkang.sunysb@gmail.com
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Hui Kang <hkang.sunysb@gmail.com>
Subject: [PATCH 1/1] sched_fair: Fix a typo in the comment describing update_sd_lb_stats
Date: Tue, 11 Oct 2011 23:00:59 -0400
Message-Id: <1318388459-4427-1-git-send-email-hkang.sunysb@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <hkang.sunysb>
References: <hkang.sunysb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hui Kang <hkang.sunysb@gmail.com>


Signed-off-by: Hui Kang <hkang.sunysb@gmail.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..6d49c82 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2854,7 +2854,7 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
 }
 
 /**
- * update_sd_lb_stats - Update sched_group's statistics for load balancing.
+ * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
-- 
1.7.4.4

