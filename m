Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1DUMLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:11:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:37126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab1DUMLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:11:22 -0400
Date: Thu, 21 Apr 2011 12:11:07 GMT
From: tip-bot for Rakib Mullick <rakib.mullick@gmail.com>
Message-ID: <tip-d3bf52e998056a6002b2aecfe1d25486376382ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rakib.mullick@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rakib.mullick@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <BANLkTimO4iGP0QpaHO1HHF1QOnVcQpc0cw@mail.gmail.com>
References: <BANLkTimO4iGP0QpaHO1HHF1QOnVcQpc0cw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove obsolete comment from scheduler_tick()
Git-Commit-ID: d3bf52e998056a6002b2aecfe1d25486376382ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 12:11:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3bf52e998056a6002b2aecfe1d25486376382ac
Gitweb:     http://git.kernel.org/tip/d3bf52e998056a6002b2aecfe1d25486376382ac
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Wed, 20 Apr 2011 21:27:32 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Apr 2011 11:41:36 +0200

sched: Remove obsolete comment from scheduler_tick()

scheduler_tick() is no longer called by fork code - this got discarded
a long time ago by commit bc947631d1d532 ("sched: improve efficiency
of sched_fork()").

So, remove the comment which still claims otherwise.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/BANLkTimO4iGP0QpaHO1HHF1QOnVcQpc0cw@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 30a29ad..8cb0a57 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4002,9 +4002,6 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
- *
- * It also gets called by the fork code, when changing the parent's
- * timeslices.
  */
 void scheduler_tick(void)
 {
