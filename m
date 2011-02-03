Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1BCArf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:47:35 -0500
Received: from www.tglx.de ([62.245.132.106]:37646 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab1BCAra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:30 -0500
Message-Id: <20110203004210.627778423@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:47:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 7/8] um: Remove stale irq_chip.end
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=um-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the remnoval of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/kernel/irq.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/arch/um/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/um/kernel/irq.c
+++ linux-2.6-tip/arch/um/kernel/irq.c
@@ -374,7 +374,6 @@ static struct irq_chip normal_irq_type =
 	.disable = dummy,
 	.enable = dummy,
 	.ack = dummy,
-	.end = dummy
 };
 
 static struct irq_chip SIGVTALRM_irq_type = {
@@ -384,7 +383,6 @@ static struct irq_chip SIGVTALRM_irq_typ
 	.disable = dummy,
 	.enable = dummy,
 	.ack = dummy,
-	.end = dummy
 };
 
 void __init init_IRQ(void)


