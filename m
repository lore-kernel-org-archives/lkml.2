Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1ECXQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:16:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57946 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1ECXPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:15:05 -0400
Message-Id: <20110503231427.071075812@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC patch 18/32] trace event skb remove semicolons
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-skb-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:27 +0000
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
CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
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
 

