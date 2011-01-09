Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1AIWFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:05:37 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:43614 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab1AIWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:34 -0500
Message-Id: <20110109220511.227847407@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC patch 19/28] trace event skb remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-skb-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:11 +0000
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
 

