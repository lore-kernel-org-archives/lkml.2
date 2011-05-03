Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1ECLsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:48:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab1ECLsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:48:46 -0400
Date: Tue, 3 May 2011 13:48:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20110503114837.GA22701@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Geert Uytterhoeven (1):
      genirq: Fix typo CONFIG_GENIRC_IRQ_SHOW_LEVEL


 kernel/irq/proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index dd201bd..834899f 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -419,7 +419,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	} else {
 		seq_printf(p, " %8s", "None");
 	}
-#ifdef CONFIG_GENIRC_IRQ_SHOW_LEVEL
+#ifdef CONFIG_GENERIC_IRQ_SHOW_LEVEL
 	seq_printf(p, " %-8s", irqd_is_level_type(&desc->irq_data) ? "Level" : "Edge");
 #endif
 	if (desc->name)
