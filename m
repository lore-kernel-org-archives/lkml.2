Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab2GLHDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:03:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:64768 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GLHDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:03:48 -0400
From: Ying Xue <ying.xue0@gmail.com>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Fix spacing issues in coding style
Date: Thu, 12 Jul 2012 15:03:42 +0800
Message-Id: <1342076622-6606-1-git-send-email-ying.xue0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete redudant spaces between type name and data name or
operators.

Signed-off-by: Ying Xue <ying.xue0@gmail.com>
---
 kernel/sched/cpupri.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index d72586f..23aa789 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -65,8 +65,8 @@ static int convert_prio(int prio)
 int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		struct cpumask *lowest_mask)
 {
-	int                  idx      = 0;
-	int                  task_pri = convert_prio(p->prio);
+	int idx = 0;
+	int task_pri = convert_prio(p->prio);
 
 	if (task_pri >= MAX_RT_PRIO)
 		return 0;
@@ -137,9 +137,9 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
  */
 void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 {
-	int                 *currpri = &cp->cpu_to_pri[cpu];
-	int                  oldpri  = *currpri;
-	int                  do_mb = 0;
+	int *currpri = &cp->cpu_to_pri[cpu];
+	int oldpri = *currpri;
+	int do_mb = 0;
 
 	newpri = convert_prio(newpri);
 
-- 
1.7.1

