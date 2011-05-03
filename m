Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1ECXWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:22:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44244 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab1ECXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:44 -0400
Message-Id: <20110503231429.245222720@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC patch 31/32] trace event regulator remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-regulator-remove-semicolons.patch
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
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/trace/events/regulator.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6-lttng/include/trace/events/regulator.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/regulator.h
+++ linux-2.6-lttng/include/trace/events/regulator.h
@@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(regulator_basic,
 
 	TP_printk("name=%s", __get_str(name))
 
-);
+)
 
 DEFINE_EVENT(regulator_basic, regulator_enable,
 
@@ -35,7 +35,7 @@ DEFINE_EVENT(regulator_basic, regulator_
 
 	TP_ARGS(name)
 
-);
+)
 
 DEFINE_EVENT(regulator_basic, regulator_enable_delay,
 
@@ -43,7 +43,7 @@ DEFINE_EVENT(regulator_basic, regulator_
 
 	TP_ARGS(name)
 
-);
+)
 
 DEFINE_EVENT(regulator_basic, regulator_enable_complete,
 
@@ -51,7 +51,7 @@ DEFINE_EVENT(regulator_basic, regulator_
 
 	TP_ARGS(name)
 
-);
+)
 
 DEFINE_EVENT(regulator_basic, regulator_disable,
 
@@ -59,7 +59,7 @@ DEFINE_EVENT(regulator_basic, regulator_
 
 	TP_ARGS(name)
 
-);
+)
 
 DEFINE_EVENT(regulator_basic, regulator_disable_complete,
 
@@ -67,7 +67,7 @@ DEFINE_EVENT(regulator_basic, regulator_
 
 	TP_ARGS(name)
 
-);
+)
 
 /*
  * Events that take a range of numerical values, mostly for voltages
@@ -93,7 +93,7 @@ DECLARE_EVENT_CLASS(regulator_range,
 
 	TP_printk("name=%s (%d-%d)", __get_str(name),
 		  (int)__entry->min, (int)__entry->max)
-);
+)
 
 DEFINE_EVENT(regulator_range, regulator_set_voltage,
 
@@ -101,7 +101,7 @@ DEFINE_EVENT(regulator_range, regulator_
 
 	TP_ARGS(name, min, max)
 
-);
+)
 
 
 /*
@@ -125,7 +125,7 @@ DECLARE_EVENT_CLASS(regulator_value,
 
 	TP_printk("name=%s, val=%u", __get_str(name),
 		  (int)__entry->val)
-);
+)
 
 DEFINE_EVENT(regulator_value, regulator_set_voltage_complete,
 
@@ -133,7 +133,7 @@ DEFINE_EVENT(regulator_value, regulator_
 
 	TP_ARGS(name, value)
 
-);
+)
 
 #endif /* _TRACE_POWER_H */
 

