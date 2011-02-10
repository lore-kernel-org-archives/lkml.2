Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1BJMZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37675 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1BJMZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:21 -0500
From: stable-bot for Ingo Molnar <mingo@elte.hu>
Date: Thu, 10 Feb 2011 10:23:28 +0100
Subject: [PATCH 22/28] sched: Export account_system_vtime()
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: b7dadc38797584f6203386da1947ed5edf516646 upstream
Author: Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon Oct 18 20:00:37 2010 +0200

KVM uses it for example:

 ERROR: "account_system_vtime" [arch/x86/kvm/kvm.ko] undefined!

Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c7f69fe..c8272e7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1889,6 +1889,7 @@ void account_system_vtime(struct task_struct *curr)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(account_system_vtime);
 
 static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
 {
-- 
1.7.4


