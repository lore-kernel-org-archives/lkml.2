Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0IOI31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:29:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0IOI3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:29:25 -0400
Date: Wed, 15 Sep 2010 10:29:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: ftrace features and clean ups
Message-ID: <20100915082902.GD16593@elte.hu>
References: <20100915030139.444219083@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915030139.444219083@goodmis.org>
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
> This series is based off of your tip/perf/core and does not contain 
> the changes in the previous git pull request (does not include my 
> repo's tip/perf/core). This is a separate pull.
> 
> Please pull the latest tip/perf/core-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core-2
> 
> 
> Jiri Olsa (1):
>       tracing: Add funcgraph-irq option for function graph tracer.
> 
> Steven Rostedt (2):
>       tracing: Do not trace in irq when funcgraph-irq option is zero
>       tracing: Remove leftover FTRACE_ENABLE/DISABLE_MCOUNT enums
> 
> ----
>  kernel/trace/ftrace.c                |   18 +----
>  kernel/trace/trace_functions_graph.c |  124 +++++++++++++++++++++++++++++++++-
>  2 files changed, 126 insertions(+), 16 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
