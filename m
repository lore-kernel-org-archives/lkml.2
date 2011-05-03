Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1ECXRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:17:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55774 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab1ECXPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:15:03 -0400
Message-Id: <20110503231429.079545919@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [RFC patch 30/32] trace event compaction remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-compaction-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:29 +0000
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
CC: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/compaction.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/trace/events/compaction.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/compaction.h
+++ linux-2.6-lttng/include/trace/events/compaction.h
@@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(mm_compaction_isolat
 	TP_printk("nr_scanned=%lu nr_taken=%lu",
 		__entry->nr_scanned,
 		__entry->nr_taken)
-);
+)
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_migratepages,
 
@@ -36,14 +36,14 @@ DEFINE_EVENT(mm_compaction_isolate_templ
 		unsigned long nr_taken),
 
 	TP_ARGS(nr_scanned, nr_taken)
-);
+)
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_freepages,
 	TP_PROTO(unsigned long nr_scanned,
 		unsigned long nr_taken),
 
 	TP_ARGS(nr_scanned, nr_taken)
-);
+)
 
 TRACE_EVENT(mm_compaction_migratepages,
 
@@ -65,7 +65,7 @@ TRACE_EVENT(mm_compaction_migratepages,
 	TP_printk("nr_migrated=%lu nr_failed=%lu",
 		__entry->nr_migrated,
 		__entry->nr_failed)
-);
+)
 
 
 #endif /* _TRACE_COMPACTION_H */

