Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1ECXOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41384 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1ECXOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:41 -0400
Message-Id: <20110503231424.861421960@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 05/32] trace event irq remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-irq-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:25 +0000
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
---
 include/trace/events/irq.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/trace/events/irq.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/irq.h
+++ linux-2.6-lttng/include/trace/events/irq.h
@@ -51,7 +51,7 @@ TRACE_EVENT(irq_handler_entry,
 	),
 
 	TP_printk("irq=%d name=%s", __entry->irq, __get_str(name))
-);
+)
 
 /**
  * irq_handler_exit - called immediately after the irq action handler returns
@@ -82,7 +82,7 @@ TRACE_EVENT(irq_handler_exit,
 
 	TP_printk("irq=%d ret=%s",
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
-);
+)
 
 DECLARE_EVENT_CLASS(softirq,
 
@@ -100,7 +100,7 @@ DECLARE_EVENT_CLASS(softirq,
 
 	TP_printk("vec=%u [action=%s]", __entry->vec,
 		  show_softirq_name(__entry->vec))
-);
+)
 
 /**
  * softirq_entry - called immediately before the softirq handler
@@ -114,7 +114,7 @@ DEFINE_EVENT(softirq, softirq_entry,
 	TP_PROTO(unsigned int vec_nr),
 
 	TP_ARGS(vec_nr)
-);
+)
 
 /**
  * softirq_exit - called immediately after the softirq handler returns
@@ -128,7 +128,7 @@ DEFINE_EVENT(softirq, softirq_exit,
 	TP_PROTO(unsigned int vec_nr),
 
 	TP_ARGS(vec_nr)
-);
+)
 
 /**
  * softirq_raise - called immediately when a softirq is raised
@@ -142,7 +142,7 @@ DEFINE_EVENT(softirq, softirq_raise,
 	TP_PROTO(unsigned int vec_nr),
 
 	TP_ARGS(vec_nr)
-);
+)
 
 #endif /*  _TRACE_IRQ_H */
 

