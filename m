Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1ECM1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:27:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36585 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1ECM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:27:03 -0400
Date: Tue, 3 May 2011 08:26:45 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Subject: Re: [RFC patch 12/32] trace event napi remove semicolons
Message-ID: <20110503122645.GA874@hmsreliant.think-freely.org>
References: <20110502211123.163877033@efficios.com>
 <20110502213213.212097030@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502213213.212097030@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.5 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:11:35PM -0400, Mathieu Desnoyers wrote:
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
>  include/trace/events/napi.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> Index: linux-2.6-lttng/include/trace/events/napi.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/trace/events/napi.h
> +++ linux-2.6-lttng/include/trace/events/napi.h
> @@ -28,7 +28,7 @@ TRACE_EVENT(napi_poll,
>  
>  	TP_printk("napi poll on napi struct %p for device %s",
>  		__entry->napi, __get_str(dev_name))
> -);
> +)
>  
>  #undef NO_DEV
>  
> 
> 
