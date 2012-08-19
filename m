Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2HSApL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 20:45:11 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:34530 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751134Ab2HSApJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 20:45:09 -0400
Message-ID: <50303714.3090204@xenotime.net>
Date: Sat, 18 Aug 2012 17:45:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: fix kernel-doc warnings in kernel/sched/fair.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warnings in kernel/sched/fair.c:

Warning(kernel/sched/fair.c:3660): Excess function parameter 'cpus' description in 'update_sg_lb_stats'
Warning(kernel/sched/fair.c:3806): Excess function parameter 'cpus' description in 'update_sd_lb_stats'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Ingo Molnar <mingo@redhat.com>
Cc:	Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |    2 --
 1 file changed, 2 deletions(-)

--- lnx-36-rc2.orig/kernel/sched/fair.c
+++ lnx-36-rc2/kernel/sched/fair.c
@@ -3650,7 +3650,6 @@ fix_small_capacity(struct sched_domain *
  * @group: sched_group whose statistics are to be updated.
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
- * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
@@ -3797,7 +3796,6 @@ static bool update_sd_pick_busiest(struc
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
