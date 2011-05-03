Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1ECM1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:27:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36610 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1ECM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:27:41 -0400
Date: Tue, 3 May 2011 08:27:29 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC patch 18/32] trace event skb remove semicolons
Message-ID: <20110503122729.GC874@hmsreliant.think-freely.org>
References: <20110502211123.163877033@efficios.com>
 <20110502213214.208707024@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213214.208707024@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:11:41PM -0400, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: David S. Miller <davem@davemloft.net>
> ---
Acked-by: Neil Horman <nhorman@tuxdriver.com>

>  include/trace/events/skb.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/include/trace/events/skb.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/skb.h
> +++ linux-2.6-lttng/include/trace/events/skb.h
> @@ -31,7 +31,7 @@ TRACE_EVENT(kfree_skb,
>  
>  	TP_printk("skbaddr=%p protocol=%u location=%p",
>  		__entry->skbaddr, __entry->protocol, __entry->location)
> -);
> +)
>  
>  TRACE_EVENT(consume_skb,
>  
> @@ -48,7 +48,7 @@ TRACE_EVENT(consume_skb,
>  	),
>  
>  	TP_printk("skbaddr=%p", __entry->skbaddr)
> -);
> +)
>  
>  TRACE_EVENT(skb_copy_datagram_iovec,
>  
> @@ -67,7 +67,7 @@ TRACE_EVENT(skb_copy_datagram_iovec,
>  	),
>  
>  	TP_printk("skbaddr=%p len=%d", __entry->skbaddr, __entry->len)
> -);
> +)
>  
>  #endif /* _TRACE_SKB_H */
>  
> 
> 
