Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1ECXOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55034 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab1ECXOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:41 -0400
Message-Id: <20110503231424.317227650@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: [RFC patch 02/32] trace event sample remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-sample-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:24 +0000
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
---
 samples/trace_events/trace-events-sample.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/samples/trace_events/trace-events-sample.h
===================================================================
--- linux-2.6-lttng.orig/samples/trace_events/trace-events-sample.h
+++ linux-2.6-lttng/samples/trace_events/trace-events-sample.h
@@ -91,7 +91,7 @@ TRACE_EVENT(foo_bar,
 	),
 
 	TP_printk("foo %s %d", __entry->foo, __entry->bar)
-);
+)
 #endif
 
 /***** NOTICE! The #if protection ends here. *****/

