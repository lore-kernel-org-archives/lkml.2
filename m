Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1AIWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:09:27 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38750 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1AIWFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:32 -0500
Message-Id: <20110109220511.060022904@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [RFC patch 18/28] trace event signal remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-signal-remove-semicolons.patch
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
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/signal.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/include/trace/events/signal.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/signal.h
+++ linux-2.6-lttng/include/trace/events/signal.h
@@ -59,7 +59,7 @@ TRACE_EVENT(signal_generate,
 	TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
 		  __entry->sig, __entry->errno, __entry->code,
 		  __entry->comm, __entry->pid)
-);
+)
 
 /**
  * signal_deliver - called when a signal is delivered
@@ -99,7 +99,7 @@ TRACE_EVENT(signal_deliver,
 	TP_printk("sig=%d errno=%d code=%d sa_handler=%lx sa_flags=%lx",
 		  __entry->sig, __entry->errno, __entry->code,
 		  __entry->sa_handler, __entry->sa_flags)
-);
+)
 
 DECLARE_EVENT_CLASS(signal_queue_overflow,
 
@@ -122,7 +122,7 @@ DECLARE_EVENT_CLASS(signal_queue_overflo
 
 	TP_printk("sig=%d group=%d errno=%d code=%d",
 		  __entry->sig, __entry->group, __entry->errno, __entry->code)
-);
+)
 
 /**
  * signal_overflow_fail - called when signal queue is overflow
@@ -140,7 +140,7 @@ DEFINE_EVENT(signal_queue_overflow, sign
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
 	TP_ARGS(sig, group, info)
-);
+)
 
 /**
  * signal_lose_info - called when siginfo is lost
@@ -158,7 +158,7 @@ DEFINE_EVENT(signal_queue_overflow, sign
 	TP_PROTO(int sig, int group, struct siginfo *info),
 
 	TP_ARGS(sig, group, info)
-);
+)
 
 #endif /* _TRACE_SIGNAL_H */
 

