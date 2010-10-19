Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0JSGYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:24:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50186 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933583Ab0JSGYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:24:06 -0400
Date: Tue, 19 Oct 2010 08:23:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL] tracing: various updates
Message-ID: <20101019062359.GB21782@elte.hu>
References: <20101018202939.828061748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018202939.828061748@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I pushed these before, but they had a couple of jump label patches that caused you 
> a build error. Since these patches have nothing to do with jump label, I rebased 
> them without the jump label patches on top of latest tip/perf/core.
> 
> The couple of jump label that were taken out of this patch series now live in the 
> jump label branch of my tree (and were actually in the last jump label push which 
> also needs a rewrite).
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Jiri Olsa (3):
>       tracing: Add proper check for irq_depth routines
>       tracing: Make graph related irqs/preemptsoff functions global
>       tracing: Graph support for wakeup tracer
> 
> Steven Rostedt (3):
>       tracing: Use one prologue for the wakeup tracer function tracers
>       tracing: Use one prologue for the preempt irqs off tracer function tracers
>       tracing: Remove parent recording in latency tracer graph options
> 
> matt mooney (1):
>       tracing/trivial: Remove cast from void*
> 
> ----
>  kernel/trace/ftrace.c                |    4 +-
>  kernel/trace/trace.c                 |    2 +-
>  kernel/trace/trace.h                 |    4 +
>  kernel/trace/trace_functions_graph.c |   86 +++++++++++-
>  kernel/trace/trace_irqsoff.c         |  152 +++++++-------------
>  kernel/trace/trace_sched_wakeup.c    |  257 ++++++++++++++++++++++++++++++---
>  6 files changed, 374 insertions(+), 131 deletions(-)

Pulled, thanks a lot Steve!

Thanks,

	Ingo
