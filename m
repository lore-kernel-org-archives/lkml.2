Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0HBG2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:28:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0HBG2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:28:35 -0400
Date: Mon, 2 Aug 2010 08:28:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] instrumentation updates
Message-ID: <20100802062827.GC2320@elte.hu>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
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
> 
> A large part is about the new "perf sched migration". It still needs
> improvements, like fixing some zoom issues, handling sched policies
> and nice levels, etc...
> 
> But at least it's usable for general overviews of CPUs load
> distribution.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (9):
>       perf: Use tracepoint_synchronize_unregister() to flush any pending tracepoint call
>       tracing: Drop cpparg() macro
>       perf: New migration tool overview
>       perf, sched migration: Handle ignored migrate out events
>       perf, sched migration: Ignore unhandled task states
>       perf, sched migration: Make it vertically scrollable
>       perf, sched migration: Make the GUI class client agnostic
>       perf, sched migration: Librarize the GUI class
>       perf, sched migration: Librarize task states and event headers helpers
> 
> Nikhil Rao (2):
>       perf, sched migration: Fix key bindings
>       perf, sched migration: Parameterize cpu height and spacing
> 
> Marcin Slusarz (1):
>       x86,mmiotrace: Add support for tracing STOS instruction
> 
> 
>  arch/x86/mm/pf_in.c                                |   30 +-
>  include/trace/ftrace.h                             |    7 +-
>  kernel/trace/trace_event_perf.c                    |    6 +-
>  .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   30 ++
>  .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |  184 ++++++++
>  .../perf/scripts/python/bin/sched-migration-record |    2 +
>  .../perf/scripts/python/bin/sched-migration-report |    3 +
>  tools/perf/scripts/python/sched-migration.py       |  461 ++++++++++++++++++++
>  8 files changed, 702 insertions(+), 21 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
