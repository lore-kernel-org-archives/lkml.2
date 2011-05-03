Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1ECM1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:27:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36595 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1ECM1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:27:15 -0400
Date: Tue, 3 May 2011 08:27:07 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: Re: [RFC patch 13/32] trace event net remove semicolons
Message-ID: <20110503122706.GB874@hmsreliant.think-freely.org>
References: <20110502211123.163877033@efficios.com>
 <20110502213213.377937157@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213213.377937157@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.5 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:11:36PM -0400, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> ---
>  include/trace/events/net.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> Index: linux-2.6-lttng/include/trace/events/net.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/net.h
> +++ linux-2.6-lttng/include/trace/events/net.h
> @@ -32,7 +32,7 @@ TRACE_EVENT(net_dev_xmit,
>  
>  	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
>  		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
> -);
> +)
>  
>  DECLARE_EVENT_CLASS(net_dev_template,
>  
> @@ -61,21 +61,21 @@ DEFINE_EVENT(net_dev_template, net_dev_q
>  	TP_PROTO(struct sk_buff *skb),
>  
>  	TP_ARGS(skb)
> -);
> +)
>  
>  DEFINE_EVENT(net_dev_template, netif_receive_skb,
>  
>  	TP_PROTO(struct sk_buff *skb),
>  
>  	TP_ARGS(skb)
> -);
> +)
>  
>  DEFINE_EVENT(net_dev_template, netif_rx,
>  
>  	TP_PROTO(struct sk_buff *skb),
>  
>  	TP_ARGS(skb)
> -);
> +)
>  #endif /* _TRACE_NET_H */
>  
>  /* This part must be outside protection */
> 
> 
