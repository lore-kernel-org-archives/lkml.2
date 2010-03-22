Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0CVIsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0CVIs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:48:29 -0400
Date: Mon, 22 Mar 2010 09:48:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/4] tracing: function graph output for
 preempt/irqs-off tracers
Message-ID: <20100322084825.GC1851@jolsa.sde>
References: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 08:51:06AM +0100, Jiri Olsa wrote:
> hi,
> 
> I'm sending reworked version of the graph output support for
> preemptirqsoff/preemptoff/irqsoff tracers.
> 
> I made the graph output as an output event, so it could be shared
> within tracers - patch 1/4.
> 
> I also added raw trace output for graph tracer. I have this one around
> for long time and it was quite handy for investigating graph tracer issues.
> (patch 4/4)
> 
> attached patches:
> - 1/4 adding ftrace events for graph tracer
> - 2/4 graph output support for irqsoff tracer
> - 3/4 graph output support for preemptirqsoff/preemptoff tracers
> - 4/4 raw output for graph tracer
> 
> v2 changes:
> - keeping the current function graph output format
> 
> 
> wbr,
> jirka
> ---
>  kernel/trace/trace.c                 |    2 +-
>  kernel/trace/trace.h                 |   15 ++--
>  kernel/trace/trace_functions_graph.c |  124 +++++++++++++++++++++----
>  kernel/trace/trace_irqsoff.c         |  174 ++++++++++++++++++++++++++++++++--
>  4 files changed, 283 insertions(+), 32 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


hi,

any feedback for the new version?

thanks,
jirka
