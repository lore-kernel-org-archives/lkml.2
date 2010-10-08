Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0JHIRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:17:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39541 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0JHIRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:17:05 -0400
Date: Fri, 8 Oct 2010 10:16:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/9] [GIT PULL] tracing: updates for 2.6.37
Message-ID: <20101008081655.GC13754@elte.hu>
References: <20101006033445.465428951@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006033445.465428951@goodmis.org>
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
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Jason Baron (1):
>       jump label/x86: Move arch_init_ideal_nop5 later
> 
> Jiri Olsa (3):
>       tracing: Add proper check for irq_depth routines
>       tracing: Make graph related irqs/preemptsoff functions global
>       tracing: Graph support for wakeup tracer
> 
> Steven Rostedt (4):
>       tracing/x86: No need to disable interrupts when calling arch_init_ideal_nop5
>       tracing: Use one prologue for the wakeup tracer function tracers
>       tracing: Use one prologue for the preempt irqs off tracer function tracers
>       tracing: Remove parent recording in latency tracer graph options
> 
> matt mooney (1):
>       tracing/trivial: Remove cast from void*
> 
> ----
>  arch/x86/kernel/alternative.c        |    5 +
>  arch/x86/kernel/setup.c              |    6 -
>  kernel/trace/ftrace.c                |    8 +-
>  kernel/trace/trace.c                 |    2 +-
>  kernel/trace/trace.h                 |    4 +
>  kernel/trace/trace_functions_graph.c |   86 +++++++++++-
>  kernel/trace/trace_irqsoff.c         |  152 +++++++-------------
>  kernel/trace/trace_sched_wakeup.c    |  257 ++++++++++++++++++++++++++++++---
>  8 files changed, 380 insertions(+), 140 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
