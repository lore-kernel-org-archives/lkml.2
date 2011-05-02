Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab1EBWFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:40 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40684 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758787Ab1EBWFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:05:38 -0400
Message-Id: <20110502213213.212097030@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: [RFC patch 12/32] trace event napi remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-napi-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:13 +0000
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
CC: Neil Horman <nhorman@tuxdriver.com>
CC: David S. Miller <davem@davemloft.net>
CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
---
 include/trace/events/napi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/include/trace/events/napi.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/napi.h
+++ linux-2.6-lttng/include/trace/events/napi.h
@@ -28,7 +28,7 @@ TRACE_EVENT(napi_poll,
 
 	TP_printk("napi poll on napi struct %p for device %s",
 		__entry->napi, __get_str(dev_name))
-);
+)
 
 #undef NO_DEV
 

