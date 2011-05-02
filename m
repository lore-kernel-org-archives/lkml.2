Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab1EBWIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:08:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40560 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541Ab1EBWER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:17 -0400
Message-Id: <20110502213212.696609579@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC patch 09/32] trace event lock remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-lock-remove-semicolons.patch
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
CC: Peter Zijlstra <peterz@infradead.org>
---
 include/trace/events/lock.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/trace/events/lock.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/lock.h
+++ linux-2.6-lttng/include/trace/events/lock.h
@@ -33,7 +33,7 @@ TRACE_EVENT(lock_acquire,
 		  (__entry->flags & 1) ? "try " : "",
 		  (__entry->flags & 2) ? "read " : "",
 		  __get_str(name))
-);
+)
 
 DECLARE_EVENT_CLASS(lock,
 
@@ -52,14 +52,14 @@ DECLARE_EVENT_CLASS(lock,
 	),
 
 	TP_printk("%p %s",  __entry->lockdep_addr, __get_str(name))
-);
+)
 
 DEFINE_EVENT(lock, lock_release,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
 	TP_ARGS(lock, ip)
-);
+)
 
 #ifdef CONFIG_LOCK_STAT
 
@@ -68,14 +68,14 @@ DEFINE_EVENT(lock, lock_contended,
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
 	TP_ARGS(lock, ip)
-);
+)
 
 DEFINE_EVENT(lock, lock_acquired,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
 	TP_ARGS(lock, ip)
-);
+)
 
 #endif
 #endif

