Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab1EBWEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56902 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab1EBWEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:39 -0400
Message-Id: <20110502213216.050459585@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC patch 29/32] trace event asoc remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-asoc-remove-semicolons.patch
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
 include/trace/events/asoc.h |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

Index: linux-2.6-lttng/include/trace/events/asoc.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/asoc.h
+++ linux-2.6-lttng/include/trace/events/asoc.h
@@ -7,11 +7,16 @@
 #include <linux/ktime.h>
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_ASOC_DEF_
+#define _TRACE_ASOC_DEF_
+
 struct snd_soc_jack;
 struct snd_soc_codec;
 struct snd_soc_card;
 struct snd_soc_dapm_widget;
 
+#endif /* _TRACE_ASOC_DEF_ */
+
 /*
  * Log register events
  */
@@ -39,7 +44,7 @@ DECLARE_EVENT_CLASS(snd_soc_reg,
 	TP_printk("codec=%s.%d reg=%x val=%x", __get_str(name),
 		  (int)__entry->id, (unsigned int)__entry->reg,
 		  (unsigned int)__entry->val)
-);
+)
 
 DEFINE_EVENT(snd_soc_reg, snd_soc_reg_write,
 
@@ -48,7 +53,7 @@ DEFINE_EVENT(snd_soc_reg, snd_soc_reg_wr
 
 	TP_ARGS(codec, reg, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_reg, snd_soc_reg_read,
 
@@ -57,7 +62,7 @@ DEFINE_EVENT(snd_soc_reg, snd_soc_reg_re
 
 	TP_ARGS(codec, reg, val)
 
-);
+)
 
 DECLARE_EVENT_CLASS(snd_soc_card,
 
@@ -76,7 +81,7 @@ DECLARE_EVENT_CLASS(snd_soc_card,
 	),
 
 	TP_printk("card=%s val=%d", __get_str(name), (int)__entry->val)
-);
+)
 
 DEFINE_EVENT(snd_soc_card, snd_soc_bias_level_start,
 
@@ -84,7 +89,7 @@ DEFINE_EVENT(snd_soc_card, snd_soc_bias_
 
 	TP_ARGS(card, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_card, snd_soc_bias_level_done,
 
@@ -92,7 +97,7 @@ DEFINE_EVENT(snd_soc_card, snd_soc_bias_
 
 	TP_ARGS(card, val)
 
-);
+)
 
 DECLARE_EVENT_CLASS(snd_soc_dapm_basic,
 
@@ -109,7 +114,7 @@ DECLARE_EVENT_CLASS(snd_soc_dapm_basic,
 	),
 
 	TP_printk("card=%s", __get_str(name))
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_basic, snd_soc_dapm_start,
 
@@ -117,7 +122,7 @@ DEFINE_EVENT(snd_soc_dapm_basic, snd_soc
 
 	TP_ARGS(card)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_basic, snd_soc_dapm_done,
 
@@ -125,7 +130,7 @@ DEFINE_EVENT(snd_soc_dapm_basic, snd_soc
 
 	TP_ARGS(card)
 
-);
+)
 
 DECLARE_EVENT_CLASS(snd_soc_dapm_widget,
 
@@ -145,7 +150,7 @@ DECLARE_EVENT_CLASS(snd_soc_dapm_widget,
 
 	TP_printk("widget=%s val=%d", __get_str(name),
 		  (int)__entry->val)
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_widget, snd_soc_dapm_widget_power,
 
@@ -153,7 +158,7 @@ DEFINE_EVENT(snd_soc_dapm_widget, snd_so
 
 	TP_ARGS(w, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_widget, snd_soc_dapm_widget_event_start,
 
@@ -161,7 +166,7 @@ DEFINE_EVENT(snd_soc_dapm_widget, snd_so
 
 	TP_ARGS(w, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_widget, snd_soc_dapm_widget_event_done,
 
@@ -169,7 +174,7 @@ DEFINE_EVENT(snd_soc_dapm_widget, snd_so
 
 	TP_ARGS(w, val)
 
-);
+)
 
 TRACE_EVENT(snd_soc_jack_irq,
 
@@ -186,7 +191,7 @@ TRACE_EVENT(snd_soc_jack_irq,
 	),
 
 	TP_printk("%s", __get_str(name))
-);
+)
 
 TRACE_EVENT(snd_soc_jack_report,
 
@@ -208,7 +213,7 @@ TRACE_EVENT(snd_soc_jack_report,
 
 	TP_printk("jack=%s %x/%x", __get_str(name), (int)__entry->val,
 		  (int)__entry->mask)
-);
+)
 
 TRACE_EVENT(snd_soc_jack_notify,
 
@@ -227,7 +232,7 @@ TRACE_EVENT(snd_soc_jack_notify,
 	),
 
 	TP_printk("jack=%s %x", __get_str(name), (int)__entry->val)
-);
+)
 
 TRACE_EVENT(snd_soc_cache_sync,
 
@@ -252,7 +257,7 @@ TRACE_EVENT(snd_soc_cache_sync,
 
 	TP_printk("codec=%s.%d type=%s status=%s", __get_str(name),
 		  (int)__entry->id, __get_str(type), __get_str(status))
-);
+)
 
 #endif /* _TRACE_ASOC_H */
 

