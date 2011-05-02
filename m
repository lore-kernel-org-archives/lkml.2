Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab1EBWEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40560 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab1EBWEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:22 -0400
Message-Id: <20110502213216.383361752@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC patch 31/32] trace event regulator remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-regulator-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:16 +0000
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
 

