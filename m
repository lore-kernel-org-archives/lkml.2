Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1GUS3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:29:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:49881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1GUS3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:29:48 -0400
Date: Thu, 21 Jul 2011 18:29:18 GMT
From: tip-bot for Jan Schoenherr <schnhrr@cs.tu-berlin.de>
Message-ID: <tip-5f817d676b7b7ac4a29f5ed93063ae7a24550c12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, schnhrr@cs.tu-berlin.de, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schnhrr@cs.tu-berlin.de, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'
Git-Commit-ID: 5f817d676b7b7ac4a29f5ed93063ae7a24550c12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:29:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f817d676b7b7ac4a29f5ed93063ae7a24550c12
Gitweb:     http://git.kernel.org/tip/5f817d676b7b7ac4a29f5ed93063ae7a24550c12
Author:     Jan Schoenherr <schnhrr@cs.tu-berlin.de>
AuthorDate: Wed, 13 Jul 2011 20:13:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:48 +0200

sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'

This patch fixes a typo located in a comment.

Signed-off-by: Jan Schoenherr <schnhrr@cs.tu-berlin.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 474f341..3b3826e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8362,7 +8362,7 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
-#else /* !CONFG_FAIR_GROUP_SCHED */
+#else /* !CONFIG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
 {
 }
