Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab1EBWFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40684 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758787Ab1EBWFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:05:41 -0400
Message-Id: <20110502213214.208707024@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC patch 18/32] trace event skb remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-skb-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:14 +0000
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
CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
CC: Neil Horman <nhorman@tuxdriver.com>
CC: David S. Miller <davem@davemloft.net>
---
 include/trace/events/skb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/trace/events/skb.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/skb.h
+++ linux-2.6-lttng/include/trace/events/skb.h
@@ -31,7 +31,7 @@ TRACE_EVENT(kfree_skb,
 
 	TP_printk("skbaddr=%p protocol=%u location=%p",
 		__entry->skbaddr, __entry->protocol, __entry->location)
-);
+)
 
 TRACE_EVENT(consume_skb,
 
@@ -48,7 +48,7 @@ TRACE_EVENT(consume_skb,
 	),
 
 	TP_printk("skbaddr=%p", __entry->skbaddr)
-);
+)
 
 TRACE_EVENT(skb_copy_datagram_iovec,
 
@@ -67,7 +67,7 @@ TRACE_EVENT(skb_copy_datagram_iovec,
 	),
 
 	TP_printk("skbaddr=%p len=%d", __entry->skbaddr, __entry->len)
-);
+)
 
 #endif /* _TRACE_SKB_H */
 

