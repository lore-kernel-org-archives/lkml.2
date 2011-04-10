Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1DJI7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 04:59:12 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:43773 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1DJI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 04:59:10 -0400
Date: Sun, 10 Apr 2011 10:59:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Geoff Levand <geoff@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: ps3 - Update debug message for
 irq_set_chip_data()
Message-ID: <alpine.DEB.2.00.1104101058010.13483@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 7193fcea7af93d57a0fea04efa28bcb5a7412e39 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 10 Apr 2011 10:45:35 +0200
Subject: [PATCH] powerpc: ps3 - Update debug message for irq_set_chip_data()

commit ec775d0e70eb6b7116406b3441cb8501c2849dd2 ("powerpc: Convert to new irq_*
function names") changed a call from set_irq_chip_data() to
irq_set_chip_data(), but forgot to update the corresponding debug message

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/powerpc/platforms/ps3/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index f2f6413..523bd0d 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -197,7 +197,7 @@ static int ps3_virq_setup(enum ps3_cpu_binding cpu, unsigned long outlet,
 	result = irq_set_chip_data(*virq, pd);
 
 	if (result) {
-		pr_debug("%s:%d: set_irq_chip_data failed\n",
+		pr_debug("%s:%d: irq_set_chip_data failed\n",
 			__func__, __LINE__);
 		goto fail_set;
 	}
-- 
1.7.0.4


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
