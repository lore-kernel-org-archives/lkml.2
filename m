Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1BFTXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:23:16 -0500
Received: from www.tglx.de ([62.245.132.106]:45163 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab1BFTWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:22:05 -0500
Message-Id: <20110206192106.109992056@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 19:21:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 2/7] frv: Fix typo from __do_IRQ overhaul
References: <20110206192032.393682621@linutronix.de>
Content-Disposition: inline; filename=frv-fix-do-irq-fallout.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiles way better.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/irq-mb93093.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-next.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-next/arch/frv/kernel/irq-mb93093.c
@@ -93,7 +93,7 @@ static irqreturn_t fpga_interrupt(int ir
 		irq = 31 - irq;
 		mask &= ~(1 << irq);
 
-		generic_irq_handle(IRQ_BASE_FPGA + irq);
+		generic_handle_irq(IRQ_BASE_FPGA + irq);
 	}
 
 	return IRQ_HANDLED;


