Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1AIWHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:07:10 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:55223 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1AIWGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:06:53 -0500
Message-Id: <20110109220510.554585997@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jean Pihet <j-pihet@ti.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: [RFC patch 15/28] trace event power remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-power-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:10 +0000
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
 include/trace/events/power.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng/include/trace/events/power.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/power.h
+++ linux-2.6-lttng/include/trace/events/power.h
@@ -41,21 +41,21 @@ DECLARE_EVENT_CLASS(power,
 
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
 
@@ -73,7 +73,7 @@ TRACE_EVENT(power_end,
 
 	TP_printk("cpu_id=%lu", (unsigned long)__entry->cpu_id)
 
-);
+)
 
 /*
  * The clock events are used for clock enable/disable and for
@@ -99,28 +99,28 @@ DECLARE_EVENT_CLASS(clock,
 
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
@@ -145,14 +145,14 @@ DECLARE_EVENT_CLASS(power_domain,
 
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
 

