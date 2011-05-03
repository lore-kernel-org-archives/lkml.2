Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1ECXTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:19:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44076 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab1ECXOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:51 -0400
Message-Id: <20110503231428.912997744@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@slimlogic.co.uk
Subject: [RFC patch 29/32] trace event asoc: semicolon removal
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-asoc-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes. This is done by removing
the semicolons at the end of the DECLARE_EVENT_CLASS(), DEFINE_EVENT() and
TRACE_EVENT() declarations.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: lrg@slimlogic.co.uk
---
 include/trace/events/asoc.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6-lttng/include/trace/events/asoc.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/asoc.h
+++ linux-2.6-lttng/include/trace/events/asoc.h
@@ -39,7 +39,7 @@ DECLARE_EVENT_CLASS(snd_soc_reg,
 	TP_printk("codec=%s.%d reg=%x val=%x", __get_str(name),
 		  (int)__entry->id, (unsigned int)__entry->reg,
 		  (unsigned int)__entry->val)
-);
+)
 
 DEFINE_EVENT(snd_soc_reg, snd_soc_reg_write,
 
@@ -48,7 +48,7 @@ DEFINE_EVENT(snd_soc_reg, snd_soc_reg_wr
 
 	TP_ARGS(codec, reg, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_reg, snd_soc_reg_read,
 
@@ -57,7 +57,7 @@ DEFINE_EVENT(snd_soc_reg, snd_soc_reg_re
 
 	TP_ARGS(codec, reg, val)
 
-);
+)
 
 DECLARE_EVENT_CLASS(snd_soc_card,
 
@@ -76,7 +76,7 @@ DECLARE_EVENT_CLASS(snd_soc_card,
 	),
 
 	TP_printk("card=%s val=%d", __get_str(name), (int)__entry->val)
-);
+)
 
 DEFINE_EVENT(snd_soc_card, snd_soc_bias_level_start,
 
@@ -84,7 +84,7 @@ DEFINE_EVENT(snd_soc_card, snd_soc_bias_
 
 	TP_ARGS(card, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_card, snd_soc_bias_level_done,
 
@@ -92,7 +92,7 @@ DEFINE_EVENT(snd_soc_card, snd_soc_bias_
 
 	TP_ARGS(card, val)
 
-);
+)
 
 DECLARE_EVENT_CLASS(snd_soc_dapm_basic,
 
@@ -109,7 +109,7 @@ DECLARE_EVENT_CLASS(snd_soc_dapm_basic,
 	),
 
 	TP_printk("card=%s", __get_str(name))
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_basic, snd_soc_dapm_start,
 
@@ -117,7 +117,7 @@ DEFINE_EVENT(snd_soc_dapm_basic, snd_soc
 
 	TP_ARGS(card)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_basic, snd_soc_dapm_done,
 
@@ -125,7 +125,7 @@ DEFINE_EVENT(snd_soc_dapm_basic, snd_soc
 
 	TP_ARGS(card)
 
-);
+)
 
 DECLARE_EVENT_CLASS(snd_soc_dapm_widget,
 
@@ -145,7 +145,7 @@ DECLARE_EVENT_CLASS(snd_soc_dapm_widget,
 
 	TP_printk("widget=%s val=%d", __get_str(name),
 		  (int)__entry->val)
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_widget, snd_soc_dapm_widget_power,
 
@@ -153,7 +153,7 @@ DEFINE_EVENT(snd_soc_dapm_widget, snd_so
 
 	TP_ARGS(w, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_widget, snd_soc_dapm_widget_event_start,
 
@@ -161,7 +161,7 @@ DEFINE_EVENT(snd_soc_dapm_widget, snd_so
 
 	TP_ARGS(w, val)
 
-);
+)
 
 DEFINE_EVENT(snd_soc_dapm_widget, snd_soc_dapm_widget_event_done,
 
@@ -169,7 +169,7 @@ DEFINE_EVENT(snd_soc_dapm_widget, snd_so
 
 	TP_ARGS(w, val)
 
-);
+)
 
 TRACE_EVENT(snd_soc_jack_irq,
 
@@ -186,7 +186,7 @@ TRACE_EVENT(snd_soc_jack_irq,
 	),
 
 	TP_printk("%s", __get_str(name))
-);
+)
 
 TRACE_EVENT(snd_soc_jack_report,
 
@@ -208,7 +208,7 @@ TRACE_EVENT(snd_soc_jack_report,
 
 	TP_printk("jack=%s %x/%x", __get_str(name), (int)__entry->val,
 		  (int)__entry->mask)
-);
+)
 
 TRACE_EVENT(snd_soc_jack_notify,
 
@@ -227,7 +227,7 @@ TRACE_EVENT(snd_soc_jack_notify,
 	),
 
 	TP_printk("jack=%s %x", __get_str(name), (int)__entry->val)
-);
+)
 
 TRACE_EVENT(snd_soc_cache_sync,
 
@@ -252,7 +252,7 @@ TRACE_EVENT(snd_soc_cache_sync,
 
 	TP_printk("codec=%s.%d type=%s status=%s", __get_str(name),
 		  (int)__entry->id, __get_str(type), __get_str(status))
-);
+)
 
 #endif /* _TRACE_ASOC_H */
 

