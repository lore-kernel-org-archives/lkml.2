Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2LKJvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:51:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42463 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2LKJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:51:30 -0500
Date: Tue, 11 Dec 2012 10:51:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers fixlet for v3.8
Message-ID: <20121211095124.GA24693@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: 351f181f9134d71efd46ddf0c0abca31b58cd79b timers, sched: Correct the comments for tick_sched_timer()

Small comment fixlet left over from the v3.7 cycle.

 Thanks,

	Ingo

------------------>
Chuansheng Liu (1):
      timers, sched: Correct the comments for tick_sched_timer()


 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a402608..2bc73d3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -794,7 +794,7 @@ void tick_check_idle(int cpu)
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * We rearm the timer until we get disabled by the idle code.
- * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ * Called with interrupts disabled.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
