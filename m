Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2IDSq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:46:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab2IDSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:46:55 -0400
Date: Tue, 4 Sep 2012 11:46:41 -0700
From: tip-bot for Randy Dunlap <rdunlap@xenotime.net>
Message-ID: <tip-9450d57eab5cad36774c297da123062744472588@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, rdunlap@xenotime.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, rdunlap@xenotime.net
In-Reply-To: <50303714.3090204@xenotime.net>
References: <50303714.3090204@xenotime.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix kernel-doc warnings in kernel/sched/
 fair.c
Git-Commit-ID: 9450d57eab5cad36774c297da123062744472588
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:46:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9450d57eab5cad36774c297da123062744472588
Gitweb:     http://git.kernel.org/tip/9450d57eab5cad36774c297da123062744472588
Author:     Randy Dunlap <rdunlap@xenotime.net>
AuthorDate: Sat, 18 Aug 2012 17:45:08 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 14:30:49 +0200

sched: Fix kernel-doc warnings in kernel/sched/fair.c

Fix two kernel-doc warnings in kernel/sched/fair.c:

  Warning(kernel/sched/fair.c:3660): Excess function parameter 'cpus' description in 'update_sg_lb_stats'
  Warning(kernel/sched/fair.c:3806): Excess function parameter 'cpus' description in 'update_sd_lb_stats'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/50303714.3090204@xenotime.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 86ad83c..42d9df6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3658,7 +3658,6 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * @group: sched_group whose statistics are to be updated.
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
- * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
@@ -3805,7 +3804,6 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @cpus: Set of cpus considered for load balancing.
  * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
