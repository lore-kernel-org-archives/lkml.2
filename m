Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1KRX3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:29:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53260 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab1KRX3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:29:30 -0500
Date: Fri, 18 Nov 2011 15:29:10 -0800
From: tip-bot for Hui Kang <hkang.sunysb@gmail.com>
Message-ID: <tip-461819ac8ee950ce027c72a066156a3df9e60c7e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, hkang.sunysb@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hkang.sunysb@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1318388459-4427-1-git-send-email-hkang.sunysb@gmail.com>
References: <1318388459-4427-1-git-send-email-hkang.sunysb@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched_fair: Fix a typo in the comment describing update_sd_lb_stats
Git-Commit-ID: 461819ac8ee950ce027c72a066156a3df9e60c7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:29:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  461819ac8ee950ce027c72a066156a3df9e60c7e
Gitweb:     http://git.kernel.org/tip/461819ac8ee950ce027c72a066156a3df9e60c7e
Author:     Hui Kang <hkang.sunysb@gmail.com>
AuthorDate: Tue, 11 Oct 2011 23:00:59 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 12:50:34 +0100

sched_fair: Fix a typo in the comment describing update_sd_lb_stats

Signed-off-by: Hui Kang <hkang.sunysb@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1318388459-4427-1-git-send-email-hkang.sunysb@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index aba20f4..7e51b5b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3588,7 +3588,7 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
 }
 
 /**
- * update_sd_lb_stats - Update sched_group's statistics for load balancing.
+ * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @sd: sched_domain whose statistics are to be updated.
  * @this_cpu: Cpu for which load balance is currently performed.
  * @idle: Idle status of this_cpu
