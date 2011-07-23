Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1GWIyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:54:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49391 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1GWIyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:54:31 -0400
Date: Sat, 23 Jul 2011 10:53:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq/core changes for v3.1
Message-ID: <20110723085350.GA15276@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      genirq: Remove unused CHECK_IRQ_PER_CPU()


 include/linux/irq.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8b45384..68258f0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -96,11 +96,6 @@ enum {
 
 #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 
-static inline __deprecated bool CHECK_IRQ_PER_CPU(unsigned int status)
-{
-	return status & IRQ_PER_CPU;
-}
-
 /*
  * Return value for chip->irq_set_affinity()
  *
