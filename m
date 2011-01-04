Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1ADXuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:50:54 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37879 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab1ADXuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:50:52 -0500
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jan 2011 18:50:38 EST
Message-Id: <20110104232419.441463699@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 18:16:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC patch 3/5] ftrace trace event add missing semicolumn
References: <20110104231629.996422888@efficios.com>
Content-Disposition: inline; filename=ftrace-trace-event-add-missing-semicolumn.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  4 Jan 2011 23:24:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing semicolumn at the end of a ftrace definition.

We currently are not seeing any impact of this missing semicolumn because extra
semicolumns appear all over the place in the code generated from TRACE_EVENT
within ftrace stages.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/trace/ftrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/trace/ftrace.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/ftrace.h
+++ linux-2.6-lttng/include/trace/ftrace.h
@@ -69,7 +69,7 @@
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call	__used		\
-	__attribute__((__aligned__(4))) event_##name
+	__attribute__((__aligned__(4))) event_##name;
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\

