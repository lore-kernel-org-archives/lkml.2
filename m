Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0DBQkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:40:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab0DBQkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:40:16 -0400
Date: Fri, 2 Apr 2010 18:39:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL] tracing: updates
Message-ID: <20100402163946.GC20963@elte.hu>
References: <20100401031735.683626160@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401031735.683626160@goodmis.org>
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
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Li Zefan (3):
>       tracing: Convert some signal events to DEFINE_TRACE
>       tracing: Update comments
>       tracing: Remove side effect from module tracepoints that caused a GPF
> 
> Steven Rostedt (4):
>       tracing: Fix compile error in module tracepoints when MODULE_UNLOAD not set
>       ring-buffer: Add place holder recording of dropped events
>       tracing: Show the lost events in the trace_pipe output
>       ring-buffer: Add lost event count to end of sub buffer
> 
> ----
>  drivers/oprofile/cpu_buffer.c        |    4 +-
>  include/linux/ftrace_event.h         |    1 +
>  include/linux/module.h               |    6 +-
>  include/linux/ring_buffer.h          |    6 +-
>  include/trace/events/module.h        |   18 ++++--
>  include/trace/events/signal.h        |   52 +++++++----------
>  include/trace/ftrace.h               |   33 ++++++-----
>  kernel/module.c                      |    8 +-
>  kernel/trace/ring_buffer.c           |  101 ++++++++++++++++++++++++++++++++--
>  kernel/trace/ring_buffer_benchmark.c |    2 +-
>  kernel/trace/trace.c                 |   30 +++++++---
>  kernel/trace/trace_functions_graph.c |    5 +-
>  kernel/trace/trace_selftest.c        |    2 +-
>  13 files changed, 187 insertions(+), 81 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
