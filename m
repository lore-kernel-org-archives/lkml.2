Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1BFWpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:45:42 -0500
Received: from www.tglx.de ([62.245.132.106]:59972 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab1BFWpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:45:41 -0500
Message-Id: <20110206224515.135703209@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:45:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 1/4] um: Remove stale irq_chip.end
References: <20110206224358.096841291@linutronix.de>
Content-Disposition: inline; filename=um-remove-stale-irq_chip-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip.end got obsolete with the remnoval of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110203004210.627778423@linutronix.de>
---
 arch/um/kernel/irq.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-next/arch/um/kernel/irq.c
===================================================================
--- linux-next.orig/arch/um/kernel/irq.c
+++ linux-next/arch/um/kernel/irq.c
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


