Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1ECXPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:15:05 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54718 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab1ECXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:15:00 -0400
Message-Id: <20110503231428.747097407@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@lst.de>, Jeremy Kerr <jk@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC patch 28/32] trace event powerpc remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-powerpc-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Anton Blanchard <anton@samba.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Hellwig <hch@lst.de>
CC: Jeremy Kerr <jk@ozlabs.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/trace.h             |   12 ++++++------
 arch/powerpc/platforms/cell/spufs/sputrace.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/include/asm/trace.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/include/asm/trace.h
+++ linux-2.6-lttng/arch/powerpc/include/asm/trace.h
@@ -23,7 +23,7 @@ TRACE_EVENT(irq_entry,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 TRACE_EVENT(irq_exit,
 
@@ -40,7 +40,7 @@ TRACE_EVENT(irq_exit,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 TRACE_EVENT(timer_interrupt_entry,
 
@@ -57,7 +57,7 @@ TRACE_EVENT(timer_interrupt_entry,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 TRACE_EVENT(timer_interrupt_exit,
 
@@ -74,7 +74,7 @@ TRACE_EVENT(timer_interrupt_exit,
 	),
 
 	TP_printk("pt_regs=%p", __entry->regs)
-);
+)
 
 #ifdef CONFIG_PPC_PSERIES
 extern void hcall_tracepoint_regfunc(void);
@@ -97,7 +97,7 @@ TRACE_EVENT_FN(hcall_entry,
 	TP_printk("opcode=%lu", __entry->opcode),
 
 	hcall_tracepoint_regfunc, hcall_tracepoint_unregfunc
-);
+)
 
 TRACE_EVENT_FN(hcall_exit,
 
@@ -119,7 +119,7 @@ TRACE_EVENT_FN(hcall_exit,
 	TP_printk("opcode=%lu retval=%lu", __entry->opcode, __entry->retval),
 
 	hcall_tracepoint_regfunc, hcall_tracepoint_unregfunc
-);
+)
 #endif
 
 #endif /* _TRACE_POWERPC_H */
Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/sputrace.h
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.h
@@ -24,7 +24,7 @@ TRACE_EVENT(spufs_context,
 
 	TP_printk("%s (ctxthread = %d, spu = %d)",
 		__entry->name, __entry->owner_tid, __entry->number)
-);
+)
 
 #define spu_context_trace(name, ctx, spu) \
 	trace_spufs_context(ctx, spu, __stringify(name))

