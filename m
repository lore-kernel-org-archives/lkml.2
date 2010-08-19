Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0HSKQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 06:16:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53622 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab0HSKQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 06:16:38 -0400
Date: Thu, 19 Aug 2010 12:16:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perf callchains updates
Message-ID: <20100819101628.GA29666@elte.hu>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       perf: Drop unappropriate tests on arch callchains
>       perf: Generalize callchain_store()
>       perf: Generalize some arch callchain code
>       perf: Factorize callchain context handling
>       perf: Fix race in callchains
>       perf: Humanize the number of contexts
> 
> Namhyung Kim (1):
>       perf, tracing: add missing __percpu markups
> 
> 
>  arch/arm/kernel/perf_event.c         |   62 +--------
>  arch/powerpc/kernel/perf_callchain.c |   86 ++++--------
>  arch/sh/kernel/perf_callchain.c      |   50 +------
>  arch/sparc/kernel/perf_event.c       |   69 +++------
>  arch/x86/kernel/cpu/perf_event.c     |   82 +++--------
>  include/linux/ftrace_event.h         |    4 +-
>  include/linux/perf_event.h           |   30 +++-
>  kernel/perf_event.c                  |  259 ++++++++++++++++++++++++++++++----
>  kernel/trace/trace_event_perf.c      |   21 ++--
>  kernel/trace/trace_functions_graph.c |    2 +-
>  10 files changed, 342 insertions(+), 323 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
