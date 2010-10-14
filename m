Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0JNHIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:08:32 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:58862 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0JNHIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:08:31 -0400
Date: Thu, 14 Oct 2010 16:09:13 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] CFS: comment update: default latency and granularity
Message-Id: <20101014160913.eb24fef4.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

Please update the comments about default values of CFS parameters.

Thanks,
  Takuya

===
Targeted preemption latency and minimal preemption granularity for CPU-bound
tasks have already changed.

This patch updates the comments about these values.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index db3f674..4183f41 100644
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
-- 
1.7.0.4

