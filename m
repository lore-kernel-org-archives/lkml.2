Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1ECXTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:19:18 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:33183 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1ECXOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:51 -0400
Message-Id: <20110503231426.068413624@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: [RFC patch 12/32] trace event napi remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-napi-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
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
 

