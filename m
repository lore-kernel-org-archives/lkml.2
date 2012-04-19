Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2DSQOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:14:35 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40490 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2DSQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:14:34 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] irqdomain: fix typo in IRQ_BITMAP_BITS definition
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
X-Yow: I HAVE to buy a new ``DODGE MISER'' and two dozen JORDACHE
 JEANS because my viewscreen is ``USER-FRIENDLY''!!
Date: Thu, 19 Apr 2012 18:14:31 +0200
Message-ID: <m2pqb31yxk.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8196 is an odd number, change it to the intended 8192.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
Shouldn't it actually be just 8192 or maybe max(NR_IRQS, 8192)?

 kernel/irq/internals.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 8e5c56b..6430d0f 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -8,7 +8,7 @@
 #include <linux/irqdesc.h>
 
 #ifdef CONFIG_SPARSE_IRQ
-# define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
+# define IRQ_BITMAP_BITS	(NR_IRQS + 8192)
 #else
 # define IRQ_BITMAP_BITS	NR_IRQS
 #endif
-- 
1.7.10


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
