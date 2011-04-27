Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab1D0LMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:12:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab1D0LMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:12:42 -0400
Date: Wed, 27 Apr 2011 13:12:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 0/6] [GIT PULL][v2.6.40] tracing: updates and jump label
 rebase
Message-ID: <20110427111228.GC28993@elte.hu>
References: <20110420155838.640017971@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420155838.640017971@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> [ Resend, as due to a cut and paste error, Ingo's and Andrew's email
>   was chopped off the Cc list ]
> 
> This includes minor updates to ftrace as well as the patchset
> for jump labels. I took out the debug printk patch that had caused
> earlier conflicts. We can add that one later.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Jan Glauber (1):
>       jump label: Add s390 support
> 
> Jason Baron (2):
>       jump label: Introduce static_branch() interface
>       jump label: Add _ASM_ALIGN for x86 and x86_64
> 
> Jiri Olsa (1):
>       tracing: Avoid soft lockup in trace_pipe
> 
> Steven Rostedt (2):
>       tracing: Convert trace_printk() formats for module to const char *
>       tracing: Print trace_bprintk() formats for modules too
> 
> ----
>  arch/mips/include/asm/jump_label.h  |   22 +-
>  arch/s390/Kconfig                   |    1 +
>  arch/s390/include/asm/jump_label.h  |   37 +++
>  arch/s390/kernel/Makefile           |    2 +-
>  arch/s390/kernel/jump_label.c       |   59 ++++
>  arch/sparc/include/asm/jump_label.h |   25 +-
>  arch/x86/include/asm/alternative.h  |    3 +-
>  arch/x86/include/asm/jump_label.h   |   27 +-
>  arch/x86/kernel/alternative.c       |    2 +-
>  arch/x86/kernel/module.c            |    1 +
>  include/asm-generic/vmlinux.lds.h   |   14 +-
>  include/linux/dynamic_debug.h       |    2 -
>  include/linux/jump_label.h          |   89 ++++---
>  include/linux/jump_label_ref.h      |   44 ---
>  include/linux/perf_event.h          |   26 +-
>  include/linux/tracepoint.h          |   22 +-
>  kernel/jump_label.c                 |  539 ++++++++++++++---------------------
>  kernel/perf_event.c                 |    4 +-
>  kernel/trace/trace.c                |   15 +-
>  kernel/trace/trace_output.c         |    3 +
>  kernel/trace/trace_printk.c         |  120 +++++++-
>  kernel/tracepoint.c                 |   23 +-
>  22 files changed, 578 insertions(+), 502 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
