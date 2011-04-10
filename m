Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1DJJCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 05:02:11 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:45411 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab1DJJCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 05:02:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 2/3] genirq: irqdesc - preflow_handler and affinity_hint are not documented?
Date: Sun, 10 Apr 2011 11:01:52 +0200
Message-Id: <1302426113-13808-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302426113-13808-1-git-send-email-geert@linux-m68k.org>
References: <1302426113-13808-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/irqdesc.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 8e1dc8e..1ccfa11 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -17,6 +17,7 @@ struct timer_rand_state;
  * @timer_rand_state:	pointer to timer rand state struct
  * @kstat_irqs:		irq stats per cpu
  * @handle_irq:		highlevel irq-events handler [if NULL, __do_IRQ()]
+ * @preflow_handler:	FIXME
  * @action:		the irq action chain
  * @status:		status information
  * @core_internal_state__do_not_mess_with_it: core internal status information
@@ -26,6 +27,7 @@ struct timer_rand_state;
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @lock:		locking for SMP
+ * @affinity_hint:	FIXME
  * @affinity_notify:	context for notification of affinity changes
  * @pending_mask:	pending rebalanced interrupts
  * @threads_oneshot:	bitfield to handle shared oneshot threads
-- 
1.7.0.4

