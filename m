Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0ECGv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:51:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0ECGv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:51:27 -0400
Date: Mon, 3 May 2010 08:50:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] perf and breakpoints updates
Message-ID: <20100503065032.GC15241@elte.hu>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
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
> Frederic Weisbecker (8):
>       perf: Remove leftover useless options to record trace events from scripts
>       perf: Fix warning while reading ring buffer headers
>       hw-breakpoints: Tag ptrace breakpoint as exclude_kernel
>       hw-breakpoints: Check disabled breakpoints again
>       hw-breakpoints: Change/Enforce some breakpoints policies
>       hw-breakpoints: Separate constraint space for data and instruction breakpoints
>       hw-breakpoints: Handle breakpoint weight in allocation constraints
>       hw-breakpoints: Get the number of available registers on boot dynamically
> 
> 
>  arch/Kconfig                                       |   11 +
>  arch/sh/Kconfig                                    |    1 +
>  arch/sh/include/asm/hw_breakpoint.h                |   10 +-
>  arch/sh/kernel/hw_breakpoint.c                     |   34 +---
>  arch/sh/kernel/ptrace_32.c                         |    2 +-
>  arch/x86/Kconfig                                   |    1 +
>  arch/x86/include/asm/hw_breakpoint.h               |   10 +-
>  arch/x86/kernel/hw_breakpoint.c                    |   41 +----
>  arch/x86/kernel/ptrace.c                           |    2 +-
>  include/linux/hw_breakpoint.h                      |   25 +++-
>  kernel/hw_breakpoint.c                             |  196 +++++++++++++++-----
>  kernel/trace/trace_ksym.c                          |   26 +--
>  tools/perf/Documentation/perf-trace-perl.txt       |    6 +-
>  tools/perf/Documentation/perf-trace-python.txt     |   10 +-
>  .../perf/scripts/perl/bin/check-perf-trace-record  |    2 +-
>  tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
>  tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
>  tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
>  tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
>  .../python/bin/failed-syscalls-by-pid-record       |    2 +-
>  tools/perf/scripts/python/bin/sctop-record         |    2 +-
>  .../python/bin/syscall-counts-by-pid-record        |    2 +-
>  .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
>  tools/perf/util/trace-event-parse.c                |   89 ---------
>  tools/perf/util/trace-event-read.c                 |   12 +-
>  tools/perf/util/trace-event.h                      |    1 -
>  28 files changed, 243 insertions(+), 256 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
