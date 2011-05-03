Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1ECXOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60469 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab1ECXOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:47 -0400
Message-Id: <20110503231425.901942419@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC patch 11/32] trace event module remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-module-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:26 +0000
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
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/trace/events/module.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/trace/events/module.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/module.h
+++ linux-2.6-lttng/include/trace/events/module.h
@@ -42,7 +42,7 @@ TRACE_EVENT(module_load,
 	),
 
 	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
-);
+)
 
 TRACE_EVENT(module_free,
 
@@ -59,7 +59,7 @@ TRACE_EVENT(module_free,
 	),
 
 	TP_printk("%s", __get_str(name))
-);
+)
 
 #ifdef CONFIG_MODULE_UNLOAD
 /* trace_module_get/put are only used if CONFIG_MODULE_UNLOAD is defined */
@@ -84,21 +84,21 @@ DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_printk("%s call_site=%pf refcnt=%d",
 		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
-);
+)
 
 DEFINE_EVENT(module_refcnt, module_get,
 
 	TP_PROTO(struct module *mod, unsigned long ip),
 
 	TP_ARGS(mod, ip)
-);
+)
 
 DEFINE_EVENT(module_refcnt, module_put,
 
 	TP_PROTO(struct module *mod, unsigned long ip),
 
 	TP_ARGS(mod, ip)
-);
+)
 #endif /* CONFIG_MODULE_UNLOAD */
 
 TRACE_EVENT(module_request,
@@ -121,7 +121,7 @@ TRACE_EVENT(module_request,
 
 	TP_printk("%s wait=%d call_site=%pf",
 		  __get_str(name), (int)__entry->wait, (void *)__entry->ip)
-);
+)
 
 #endif /* CONFIG_MODULES */
 

