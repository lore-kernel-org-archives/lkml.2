Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab0FHVNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:13:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46475 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab0FHVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:13:46 -0400
Date: Tue, 8 Jun 2010 23:13:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf updates
Message-ID: <20100608211332.GA1154@elte.hu>
References: <1276028023-23122-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276028023-23122-1-git-send-regression-fweisbec@gmail.com>
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
> I'm only posting Oleg's patches as only those are new in my queues.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       x86: Unify dumpstack.h and stacktrace.h
>       perf: Drop the skip argument from perf_arch_fetch_regs_caller
> 
> Oleg Nesterov (2):
>       x86: Make save_stack_address() !CONFIG_FRAME_POINTER friendly
>       x86: Unify save_stack_address() and save_stack_address_nosched()
> 
> Américo Wang (1):
>       tracing: Remove boot tracer
> 
> Li Zefan (1):
>       tracing: Remove kmemtrace ftrace plugin
> 
> 
>  Documentation/ABI/testing/debugfs-kmemtrace |   71 ----
>  Documentation/trace/kmemtrace.txt           |  126 -------
>  MAINTAINERS                                 |    7 -
>  arch/powerpc/include/asm/perf_event.h       |   12 +
>  arch/powerpc/kernel/misc.S                  |   26 --
>  arch/sparc/include/asm/perf_event.h         |    8 +
>  arch/sparc/kernel/helpers.S                 |    6 +-
>  arch/x86/include/asm/perf_event.h           |   13 +
>  arch/x86/include/asm/stacktrace.h           |   49 +++
>  arch/x86/kernel/cpu/perf_event.c            |   18 -
>  arch/x86/kernel/dumpstack.c                 |    1 -
>  arch/x86/kernel/dumpstack.h                 |   56 ---
>  arch/x86/kernel/dumpstack_32.c              |    2 -
>  arch/x86/kernel/dumpstack_64.c              |    1 -
>  arch/x86/kernel/stacktrace.c                |   31 +-
>  include/linux/kmemtrace.h                   |   25 --
>  include/linux/perf_event.h                  |   32 +--
>  include/linux/slab_def.h                    |    3 +-
>  include/linux/slub_def.h                    |    3 +-
>  include/trace/boot.h                        |   60 ---
>  include/trace/ftrace.h                      |    2 +-
>  init/main.c                                 |   29 +-
>  kernel/perf_event.c                         |    5 -
>  kernel/trace/Kconfig                        |   37 --
>  kernel/trace/Makefile                       |    2 -
>  kernel/trace/kmemtrace.c                    |  529 ---------------------------
>  kernel/trace/trace.c                        |    3 -
>  kernel/trace/trace.h                        |   20 -
>  kernel/trace/trace_boot.c                   |  185 ----------
>  kernel/trace/trace_entries.h                |   62 ----
>  kernel/trace/trace_event_perf.c             |    2 -
>  mm/slab.c                                   |    1 -
>  mm/slub.c                                   |    1 -
>  33 files changed, 123 insertions(+), 1305 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
