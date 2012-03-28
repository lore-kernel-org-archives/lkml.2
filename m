Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2C1L64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:58:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1L6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:58:55 -0400
Date: Wed, 28 Mar 2012 04:58:30 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-160594e99dbbb0a5600ad922c630952c7c1c14bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, paul@paulmenage.org, tglx@linutronix.de,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, paul@paulmenage.org,
        dan.carpenter@oracle.com
In-Reply-To: <20120328104608.GD29022@elgon.mountain>
References: <20120328104608.GD29022@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] cpusets: Remove an unused variable
Git-Commit-ID: 160594e99dbbb0a5600ad922c630952c7c1c14bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 28 Mar 2012 04:58:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  160594e99dbbb0a5600ad922c630952c7c1c14bf
Gitweb:     http://git.kernel.org/tip/160594e99dbbb0a5600ad922c630952c7c1c14bf
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Wed, 28 Mar 2012 13:46:09 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Mar 2012 13:40:44 +0200

cpusets: Remove an unused variable

We don't use "cpu" any more after 2baab4e904 "sched: Fix
select_fallback_rq() vs cpu_active/cpu_online".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120328104608.GD29022@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpuset.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c9837b7..4ef4d7e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2198,7 +2198,6 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	const struct cpuset *cs;
-	int cpu;
 
 	rcu_read_lock();
 	cs = task_cs(tsk);
