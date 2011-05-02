Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab1EBWFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:01 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:42963 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759177Ab1EBWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:57 -0400
Message-Id: <20110502213214.872566459@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC patch 22/32] trace event workqueue remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-workqueue-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Tejun Heo <tj@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Arjan van de Ven <arjan@linux.intel.com>
---
 include/trace/events/workqueue.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/trace/events/workqueue.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/workqueue.h
+++ linux-2.6-lttng/include/trace/events/workqueue.h
@@ -22,7 +22,7 @@ DECLARE_EVENT_CLASS(workqueue_work,
 	),
 
 	TP_printk("work struct %p", __entry->work)
-);
+)
 
 /**
  * workqueue_queue_work - called when a work gets queued
@@ -60,7 +60,7 @@ TRACE_EVENT(workqueue_queue_work,
 	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
 		  __entry->work, __entry->function, __entry->workqueue,
 		  __entry->req_cpu, __entry->cpu)
-);
+)
 
 /**
  * workqueue_activate_work - called when a work gets activated
@@ -75,7 +75,7 @@ DEFINE_EVENT(workqueue_work, workqueue_a
 	TP_PROTO(struct work_struct *work),
 
 	TP_ARGS(work)
-);
+)
 
 /**
  * workqueue_execute_start - called immediately before the workqueue callback
@@ -100,7 +100,7 @@ TRACE_EVENT(workqueue_execute_start,
 	),
 
 	TP_printk("work struct %p: function %pf", __entry->work, __entry->function)
-);
+)
 
 /**
  * workqueue_execute_end - called immediately before the workqueue callback
@@ -113,7 +113,7 @@ DEFINE_EVENT(workqueue_work, workqueue_e
 	TP_PROTO(struct work_struct *work),
 
 	TP_ARGS(work)
-);
+)
 
 #endif /*  _TRACE_WORKQUEUE_H */
 

