Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab1EBWFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:05:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52170 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758787Ab1EBWFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:05:49 -0400
Message-Id: <20110502213213.377937157@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: [RFC patch 13/32] trace event net remove semicolons
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-net-remove-semicolons.patch
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
 include/trace/events/net.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/trace/events/net.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/net.h
+++ linux-2.6-lttng/include/trace/events/net.h
@@ -32,7 +32,7 @@ TRACE_EVENT(net_dev_xmit,
 
 	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
 		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
-);
+)
 
 DECLARE_EVENT_CLASS(net_dev_template,
 
@@ -61,21 +61,21 @@ DEFINE_EVENT(net_dev_template, net_dev_q
 	TP_PROTO(struct sk_buff *skb),
 
 	TP_ARGS(skb)
-);
+)
 
 DEFINE_EVENT(net_dev_template, netif_receive_skb,
 
 	TP_PROTO(struct sk_buff *skb),
 
 	TP_ARGS(skb)
-);
+)
 
 DEFINE_EVENT(net_dev_template, netif_rx,
 
 	TP_PROTO(struct sk_buff *skb),
 
 	TP_ARGS(skb)
-);
+)
 #endif /* _TRACE_NET_H */
 
 /* This part must be outside protection */

