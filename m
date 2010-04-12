Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0DLHj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 03:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0DLHj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 03:39:58 -0400
Date: Mon, 12 Apr 2010 09:39:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 0/4] tracing: function graph output for
 preempt/irqs-off tracers
Message-ID: <20100412073947.GE3430@jolsa.lab.eng.brq.redhat.com>
References: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270227683-14631-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
any feedback?

thanks,
jirka

On Fri, Apr 02, 2010 at 07:01:19PM +0200, Jiri Olsa wrote:
> hi,
> 
> updates based on comments by Frederic Weisbecker,
> also rebase to latest master.
> 
> I'm sending reworked version of the graph output support for
> preemptirqsoff/preemptoff/irqsoff tracers.
> 
> v6:
> - using stubs instead of ifdef in trace_irqsoff for graph
>   tracer's calls
> 
> v5:
> - function graph events are back in game
> - changed function graph tracer interface to be able to
>   pass custom tracer flags
> - changed calls to trace_function to trace graph records
>   when the display-graph otion is enabled.  As function tracer
>   and graph tracer have different spacing during the record
>   output, this way it looks better, and the info stays.
> 
>   This could be also done via TRACE_PRINT, then it'd be displayed
>   as comment.. I chose the first way, though it could be easily
>   changed.
> 
> v4:
> - fixed header to display all the info as for
>   current irqsoff tracer
> - fixed reset of the max_tr buffer during the
>   display-graph switch
> 
> v3:
> - the function_graph tracer should have the same output
>   as current version even with events enabled,
>   unless I missed something again ;)
> - I gave up the idea of function_graph events,
>   since it was unsuitable for outputing other
>   events as comments "/* */"
> - I'm not including the raw function_graph for now
> 
> 
> attached patches:
> - 1/4 adding ftrace events for graph tracer
> - 2/4 graph tracer - adding support for passing flags to ouput functions
> - 3/4 graph output support for irqsoff tracer
> - 4/4 graph output support for preemptirqsoff/preemptoff tracers
> 
> 
> plz let me know what you think
> 
> wbr,
> jirka
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
