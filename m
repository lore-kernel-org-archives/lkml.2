Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1AIWFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:43 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:54427 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1AIWFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:40 -0500
Message-Id: <20110109220510.235006402@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: [RFC patch 13/28] trace event napi remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-napi-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:10 +0000
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
 

