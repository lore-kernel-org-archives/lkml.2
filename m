Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2C1Kq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:46:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47091 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab2C1KqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:46:24 -0400
Date: Wed, 28 Mar 2012 13:46:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Menage <paul@paulmenage.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [patch] cpuset: remove an unused variable
Message-ID: <20120328104608.GD29022@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F72EBFB.0062,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use "cpu" any more after 2baab4e904 "sched: Fix
select_fallback_rq() vs cpu_active/cpu_online".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index dfceaca..14f7070 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2165,7 +2165,6 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	const struct cpuset *cs;
-	int cpu;
 
 	rcu_read_lock();
 	cs = task_cs(tsk);
