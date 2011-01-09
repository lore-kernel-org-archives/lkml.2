Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1AIWIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:08:36 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58554 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab1AIWIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:08:35 -0500
Message-Id: <20110109220511.867823199@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC patch 23/28] trace event workqueue remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-workqueue-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:12 +0000
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
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Tejun Heo <tj@kernel.org>
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
 

