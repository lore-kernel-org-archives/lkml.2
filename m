Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab0D3SbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:31:01 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45974 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942Ab0D3S37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:29:59 -0400
Date: Fri, 30 Apr 2010 10:00:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] [GIT PULL] tracing: various updates
Message-ID: <20100430080055.GC20342@elte.hu>
References: <20100428012723.119106602@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428012723.119106602@goodmis.org>
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

> 
> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Chase Douglas (2):
>       tracing: Add documentation for trace commands mod, traceon/traceoff
>       tracing: Show sample std dev in function profiling
> 
> David Miller (1):
>       ring-buffer: Make non-consuming read less expensive with lots of cpus.
> 
> Jiri Olsa (3):
>       tracing: Add ftrace events for graph tracer
>       tracing: Have graph flags passed in to ouput functions
>       tracing: Add graph output support for irqsoff tracer
> 
> Steven Rostedt (2):
>       ring-buffer: Make benchmark handle missed events
>       tracing: Fix sleep time function profiling
> 
> ----
>  Documentation/trace/ftrace.txt       |   44 ++++++
>  include/linux/ftrace.h               |   15 ++-
>  include/linux/ring_buffer.h          |    4 +-
>  kernel/trace/ftrace.c                |   30 ++++-
>  kernel/trace/ring_buffer.c           |   64 +++++++--
>  kernel/trace/ring_buffer_benchmark.c |    3 +-
>  kernel/trace/trace.c                 |   46 ++++--
>  kernel/trace/trace.h                 |   27 +++-
>  kernel/trace/trace_functions_graph.c |  164 +++++++++++++--------
>  kernel/trace/trace_irqsoff.c         |  271 ++++++++++++++++++++++++++++++++--
>  10 files changed, 560 insertions(+), 108 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
