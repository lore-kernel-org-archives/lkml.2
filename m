Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1AHURv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:17:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1AHUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:48 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=UlzxW1C2IrgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=khPLatPM9w2-CMB4tNEA:9 a=UK1hIFNzuPhK7VAU1zv-T8GkfDEA:4 a=D6-X0JM3zdQA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201644.872641429@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:16:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/7] tracing/trivial: Add missing comma in TRACE_EVENT comment
References: <20110108201559.130182944@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-trivial-Add-missing-comma-in-TRACE_EVENT-com.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Add missing comma within the TRACE_EVENT() example in tracepoint.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20110106184532.GA2526@Krystal>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d3e4f87..899103c 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -326,7 +326,7 @@ do_trace:								\
  *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
  *		__entry->next_pid	= next->pid;
  *		__entry->next_prio	= next->prio;
- *	)
+ *	),
  *
  *	*
  *	* Formatted output of a trace record via TP_printk().
-- 
1.7.2.3


