Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545Ab1CYLMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:38559 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934508Ab1CYLM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:28 -0400
Message-Id: <20110325111217.768798086@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 02/10] mfd: 88pm860x: Remove unused irq_desc leftovers
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-88pm.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/88pm860x-core.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6-tip/drivers/mfd/88pm860x-core.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/88pm860x-core.c
+++ linux-2.6-tip/drivers/mfd/88pm860x-core.c
@@ -508,7 +508,6 @@ static int __devinit device_irq_init(str
 				: chip->companion;
 	unsigned char status_buf[INT_STATUS_NUM];
 	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
-	struct irq_desc *desc;
 	int i, data, mask, ret = -EINVAL;
 	int __irq;
 
@@ -560,8 +559,6 @@ static int __devinit device_irq_init(str
 	if (!chip->core_irq)
 		goto out;
 
-	desc = irq_to_desc(chip->core_irq);
-
 	/* register IRQ by genirq */
 	for (i = 0; i < ARRAY_SIZE(pm860x_irqs); i++) {
 		__irq = i + chip->irq_base;


