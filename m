Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2E3Nna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:43:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38493 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2E3Nn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:43:29 -0400
Date: Wed, 30 May 2012 06:43:12 -0700
From: tip-bot for Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <tip-6a4c96eef42f835734a82c6b512abf9881b7c55d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <20120523091411.GG5005@linux.vnet.ibm.com>
References: <20120523091411.GG5005@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove NULL assignment of dattr_cur
Git-Commit-ID: 6a4c96eef42f835734a82c6b512abf9881b7c55d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:43:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a4c96eef42f835734a82c6b512abf9881b7c55d
Gitweb:     http://git.kernel.org/tip/6a4c96eef42f835734a82c6b512abf9881b7c55d
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Wed, 23 May 2012 14:44:11 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:27 +0200

sched: Remove NULL assignment of dattr_cur

Remove explicit NULL assignment of static pointer
dattr_cur from init_sched_domains().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120523091411.GG5005@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 94d598a..c46958e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6726,7 +6726,6 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
-	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();
 
