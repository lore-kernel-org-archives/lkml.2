Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab1CYLNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:13:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:38580 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934536Ab1CYLMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:31 -0400
Message-Id: <20110325111218.152663507@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 06/10] mfd: mx8925: Remove irq_desc leftovers
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-max.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/max8925-core.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/drivers/mfd/max8925-core.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/max8925-core.c
+++ linux-2.6-tip/drivers/mfd/max8925-core.c
@@ -517,7 +517,6 @@ static int max8925_irq_init(struct max89
 			    struct max8925_platform_data *pdata)
 {
 	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
-	struct irq_desc *desc;
 	int i, ret;
 	int __irq;
 
@@ -544,7 +543,6 @@ static int max8925_irq_init(struct max89
 	mutex_init(&chip->irq_lock);
 	chip->core_irq = irq;
 	chip->irq_base = pdata->irq_base;
-	desc = irq_to_desc(chip->core_irq);
 
 	/* register with genirq */
 	for (i = 0; i < ARRAY_SIZE(max8925_irqs); i++) {


