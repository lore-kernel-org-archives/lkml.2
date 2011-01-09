Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AIWGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:06:48 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33945 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab1AIWGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:06:46 -0500
Message-Id: <20110109220511.548391005@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [RFC patch 21/28] trace event timer remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-timer-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:11 +0000
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
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Arjan van de Ven <arjan@linux.intel.com>
---
 include/trace/events/timer.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6-lttng/include/trace/events/timer.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/timer.h
+++ linux-2.6-lttng/include/trace/events/timer.h
@@ -23,7 +23,7 @@ DECLARE_EVENT_CLASS(timer_class,
 	),
 
 	TP_printk("timer=%p", __entry->timer)
-);
+)
 
 /**
  * timer_init - called when the timer is initialized
@@ -34,7 +34,7 @@ DEFINE_EVENT(timer_class, timer_init,
 	TP_PROTO(struct timer_list *timer),
 
 	TP_ARGS(timer)
-);
+)
 
 /**
  * timer_start - called when the timer is started
@@ -64,7 +64,7 @@ TRACE_EVENT(timer_start,
 	TP_printk("timer=%p function=%pf expires=%lu [timeout=%ld]",
 		  __entry->timer, __entry->function, __entry->expires,
 		  (long)__entry->expires - __entry->now)
-);
+)
 
 /**
  * timer_expire_entry - called immediately before the timer callback
@@ -91,7 +91,7 @@ TRACE_EVENT(timer_expire_entry,
 	),
 
 	TP_printk("timer=%p function=%pf now=%lu", __entry->timer, __entry->function,__entry->now)
-);
+)
 
 /**
  * timer_expire_exit - called immediately after the timer callback returns
@@ -108,7 +108,7 @@ DEFINE_EVENT(timer_class, timer_expire_e
 	TP_PROTO(struct timer_list *timer),
 
 	TP_ARGS(timer)
-);
+)
 
 /**
  * timer_cancel - called when the timer is canceled
@@ -119,7 +119,7 @@ DEFINE_EVENT(timer_class, timer_cancel,
 	TP_PROTO(struct timer_list *timer),
 
 	TP_ARGS(timer)
-);
+)
 
 /**
  * hrtimer_init - called when the hrtimer is initialized
@@ -151,7 +151,7 @@ TRACE_EVENT(hrtimer_init,
 			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
 		  __entry->mode == HRTIMER_MODE_ABS ?
 			"HRTIMER_MODE_ABS" : "HRTIMER_MODE_REL")
-);
+)
 
 /**
  * hrtimer_start - called when the hrtimer is started
@@ -183,7 +183,7 @@ TRACE_EVENT(hrtimer_start,
 				  .tv64 = __entry->expires }),
 		  (unsigned long long)ktime_to_ns((ktime_t) {
 				  .tv64 = __entry->softexpires }))
-);
+)
 
 /**
  * htimmer_expire_entry - called immediately before the hrtimer callback
@@ -213,7 +213,7 @@ TRACE_EVENT(hrtimer_expire_entry,
 
 	TP_printk("hrtimer=%p function=%pf now=%llu", __entry->hrtimer, __entry->function,
 		  (unsigned long long)ktime_to_ns((ktime_t) { .tv64 = __entry->now }))
- );
+)
 
 DECLARE_EVENT_CLASS(hrtimer_class,
 
@@ -230,7 +230,7 @@ DECLARE_EVENT_CLASS(hrtimer_class,
 	),
 
 	TP_printk("hrtimer=%p", __entry->hrtimer)
-);
+)
 
 /**
  * hrtimer_expire_exit - called immediately after the hrtimer callback returns
@@ -244,7 +244,7 @@ DEFINE_EVENT(hrtimer_class, hrtimer_expi
 	TP_PROTO(struct hrtimer *hrtimer),
 
 	TP_ARGS(hrtimer)
-);
+)
 
 /**
  * hrtimer_cancel - called when the hrtimer is canceled
@@ -255,7 +255,7 @@ DEFINE_EVENT(hrtimer_class, hrtimer_canc
 	TP_PROTO(struct hrtimer *hrtimer),
 
 	TP_ARGS(hrtimer)
-);
+)
 
 /**
  * itimer_state - called when itimer is started or canceled
@@ -293,7 +293,7 @@ TRACE_EVENT(itimer_state,
 		  __entry->which, (unsigned long long)__entry->expires,
 		  __entry->value_sec, __entry->value_usec,
 		  __entry->interval_sec, __entry->interval_usec)
-);
+)
 
 /**
  * itimer_expire - called when itimer expires
@@ -321,7 +321,7 @@ TRACE_EVENT(itimer_expire,
 
 	TP_printk("which=%d pid=%d now=%llu", __entry->which,
 		  (int) __entry->pid, (unsigned long long)__entry->now)
-);
+)
 
 #endif /*  _TRACE_TIMER_H */
 

