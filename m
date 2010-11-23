Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab0KWKWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 05:22:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:48372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab0KWKW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 05:22:28 -0500
Date: Tue, 23 Nov 2010 10:21:53 GMT
From: tip-bot for Erik Gilling <konkers@android.com>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, konkers@android.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, konkers@android.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1290218934-8544-3-git-send-email-john.stultz@linaro.org>
References: <1290218934-8544-3-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make task dump print all 15 chars of proc comm
Message-ID: <tip-28d0686cf7b14e30243096bd874d3f80591ed392@git.kernel.org>
Git-Commit-ID: 28d0686cf7b14e30243096bd874d3f80591ed392
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Nov 2010 10:21:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28d0686cf7b14e30243096bd874d3f80591ed392
Gitweb:     http://git.kernel.org/tip/28d0686cf7b14e30243096bd874d3f80591ed392
Author:     Erik Gilling <konkers@android.com>
AuthorDate: Fri, 19 Nov 2010 18:08:51 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Nov 2010 10:29:07 +0100

sched: Make task dump print all 15 chars of proc comm

Signed-off-by: Erik Gilling <konkers@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290218934-8544-3-git-send-email-john.stultz@linaro.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 550cf3a..324afce 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5249,7 +5249,7 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-13.13s %c", p->comm,
+	printk(KERN_INFO "%-15.15s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
