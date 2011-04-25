Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1DYJiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:38:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45718 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab1DYJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:38:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/3] m32r: remove redundant declaration
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
In-Reply-To: <20110425183810.268B.A69D9226@jp.fujitsu.com>
References: <20110425183810.268B.A69D9226@jp.fujitsu.com>
Message-Id: <20110425183943.2693.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 18:38:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They has no meanings.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org
---
 arch/m32r/kernel/smp.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index f758100..092d40a 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -30,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/m32r.h>
+#include <asm/tlbflush.h>
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 /* Data structures and variables                                             */
@@ -61,27 +62,17 @@ extern spinlock_t ipi_lock[];
 /* Function Prototypes                                                       */
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
 
-void smp_send_reschedule(int);
 void smp_reschedule_interrupt(void);
-
-void smp_flush_cache_all(void);
 void smp_flush_cache_all_interrupt(void);
 
-void smp_flush_tlb_all(void);
 static void flush_tlb_all_ipi(void *);
-
-void smp_flush_tlb_mm(struct mm_struct *);
-void smp_flush_tlb_range(struct vm_area_struct *, unsigned long, \
-	unsigned long);
-void smp_flush_tlb_page(struct vm_area_struct *, unsigned long);
 static void flush_tlb_others(cpumask_t, struct mm_struct *,
 	struct vm_area_struct *, unsigned long);
+
 void smp_invalidate_interrupt(void);
 
-void smp_send_stop(void);
 static void stop_this_cpu(void *);
 
-void smp_send_timer(void);
 void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
 
-- 
1.7.3.1



