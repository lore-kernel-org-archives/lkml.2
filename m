Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1ECXOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52778 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab1ECXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:46 -0400
Message-Id: <20110503231427.238824689@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Stone <jistone@redhat.com>
Subject: [RFC patch 19/32] trace event syscalls remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-syscalls-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:27 +0000
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
CC: Josh Stone <jistone@redhat.com>
---
 include/trace/events/syscalls.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/trace/events/syscalls.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/syscalls.h
+++ linux-2.6-lttng/include/trace/events/syscalls.h
@@ -38,7 +38,7 @@ TRACE_EVENT_FN(sys_enter,
 		  __entry->args[3], __entry->args[4], __entry->args[5]),
 
 	syscall_regfunc, syscall_unregfunc
-);
+)
 
 TRACE_EVENT_FLAGS(sys_enter, TRACE_EVENT_FL_CAP_ANY)
 
@@ -62,7 +62,7 @@ TRACE_EVENT_FN(sys_exit,
 		  __entry->id, __entry->ret),
 
 	syscall_regfunc, syscall_unregfunc
-);
+)
 
 TRACE_EVENT_FLAGS(sys_exit, TRACE_EVENT_FL_CAP_ANY)
 

