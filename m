Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1AIWFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:59674 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab1AIWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:20 -0500
Message-Id: <20110109220508.578236558@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 03/28] trace event bkl remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-bkl-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:08 +0000
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
 include/trace/events/bkl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/trace/events/bkl.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/bkl.h
+++ linux-2.6-lttng/include/trace/events/bkl.h
@@ -29,7 +29,7 @@ TRACE_EVENT(lock_kernel,
 
 	TP_printk("depth=%d file:line=%s:%d func=%s()", __entry->depth,
 		  __entry->file, __entry->line, __entry->func)
-);
+)
 
 TRACE_EVENT(unlock_kernel,
 
@@ -53,7 +53,7 @@ TRACE_EVENT(unlock_kernel,
 
 	TP_printk("depth=%d file:line=%s:%d func=%s()", __entry->depth,
 		  __entry->file, __entry->line, __entry->func)
-);
+)
 
 #endif /* _TRACE_BKL_H */
 

