Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab2GZPJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:09:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2GZPJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:09:33 -0400
Date: Thu, 26 Jul 2012 08:09:20 -0700
From: tip-bot for Ying Xue <ying.xue0@gmail.com>
Message-ID: <tip-014acbf0d5c8445e0ff88ae60edd676dd9cc461c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ying.xue0@gmail.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ying.xue0@gmail.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1342076622-6606-1-git-send-email-ying.xue0@gmail.com>
References: <1342076622-6606-1-git-send-email-ying.xue0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix minor code style issues
Git-Commit-ID: 014acbf0d5c8445e0ff88ae60edd676dd9cc461c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:09:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  014acbf0d5c8445e0ff88ae60edd676dd9cc461c
Gitweb:     http://git.kernel.org/tip/014acbf0d5c8445e0ff88ae60edd676dd9cc461c
Author:     Ying Xue <ying.xue0@gmail.com>
AuthorDate: Thu, 12 Jul 2012 15:03:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 11:47:00 +0200

sched: Fix minor code style issues

Delete redudant spaces between type name and data name or operators.

Signed-off-by: Ying Xue <ying.xue0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1342076622-6606-1-git-send-email-ying.xue0@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
