Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1EBVjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:39:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44687 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1EBVhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:37:45 -0400
Message-Id: <20110502213213.543282864@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jean Pihet <j-pihet@ti.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: [RFC patch 14/32] trace event power remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-power-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:13 +0000
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
CC: Jean Pihet <j-pihet@ti.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Thomas Renninger <trenn@suse.de>
CC: Len Brown <len.brown@intel.com>
---
 include/trace/events/power.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6-lttng/include/trace/events/power.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/power.h
+++ linux-2.6-lttng/include/trace/events/power.h
@@ -25,14 +25,14 @@ DECLARE_EVENT_CLASS(cpu,
 
 	TP_printk("state=%lu cpu_id=%lu", (unsigned long)__entry->state,
 		  (unsigned long)__entry->cpu_id)
-);
+)
 
 DEFINE_EVENT(cpu, cpu_idle,
 
 	TP_PROTO(unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(state, cpu_id)
-);
+)
 
 /* This file can get included multiple times, TRACE_HEADER_MULTI_READ at top */
 #ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING
@@ -46,7 +46,7 @@ DEFINE_EVENT(cpu, cpu_frequency,
 	TP_PROTO(unsigned int frequency, unsigned int cpu_id),
 
 	TP_ARGS(frequency, cpu_id)
-);
+)
 
 TRACE_EVENT(machine_suspend,
 
@@ -63,7 +63,7 @@ TRACE_EVENT(machine_suspend,
 	),
 
 	TP_printk("state=%lu", (unsigned long)__entry->state)
-);
+)
 
 /* This code will be removed after deprecation time exceeded (2.6.41) */
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
@@ -92,21 +92,21 @@ DECLARE_EVENT_CLASS(power,
 
 	TP_printk("type=%lu state=%lu cpu_id=%lu", (unsigned long)__entry->type,
 		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
-);
+)
 
 DEFINE_EVENT(power, power_start,
 
 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(type, state, cpu_id)
-);
+)
 
 DEFINE_EVENT(power, power_frequency,
 
 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(type, state, cpu_id)
-);
+)
 
 TRACE_EVENT(power_end,
 
@@ -124,7 +124,7 @@ TRACE_EVENT(power_end,
 
 	TP_printk("cpu_id=%lu", (unsigned long)__entry->cpu_id)
 
-);
+)
 
 /* Deprecated dummy functions must be protected against multi-declartion */
 #ifndef _PWR_EVENT_AVOID_DOUBLE_DEFINING_DEPRECATED
@@ -180,28 +180,28 @@ DECLARE_EVENT_CLASS(clock,
 
 	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
 		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
-);
+)
 
 DEFINE_EVENT(clock, clock_enable,
 
 	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(name, state, cpu_id)
-);
+)
 
 DEFINE_EVENT(clock, clock_disable,
 
 	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(name, state, cpu_id)
-);
+)
 
 DEFINE_EVENT(clock, clock_set_rate,
 
 	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(name, state, cpu_id)
-);
+)
 
 /*
  * The power domain events are used for power domains transitions
@@ -226,14 +226,14 @@ DECLARE_EVENT_CLASS(power_domain,
 
 	TP_printk("%s state=%lu cpu_id=%lu", __get_str(name),
 		(unsigned long)__entry->state, (unsigned long)__entry->cpu_id)
-);
+)
 
 DEFINE_EVENT(power_domain, power_domain_target,
 
 	TP_PROTO(const char *name, unsigned int state, unsigned int cpu_id),
 
 	TP_ARGS(name, state, cpu_id)
-);
+)
 #endif /* _TRACE_POWER_H */
 
 /* This part must be outside protection */

