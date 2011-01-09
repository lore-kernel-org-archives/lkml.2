Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1AIWFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:33 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48651 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1AIWF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:28 -0500
Message-Id: <20110109220509.753147850@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC patch 10/28] trace event lock remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-lock-remove-semicolons.patch
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

