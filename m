Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab0GUToS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:44:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab0GUToR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:44:17 -0400
Date: Wed, 21 Jul 2010 21:44:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] tracing updates
Message-ID: <20100721194405.GC24797@elte.hu>
References: <1279636925-5919-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279636925-5919-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4322]
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
> Frederic Weisbecker (2):
>       tracing: Remove sysprof ftrace plugin
>       tracing: Remove special traces
> 
> Arnd Bergmann (1):
>       tracing: Use generic_file_llseek for debugfs
> 
> 
>  include/linux/kernel.h        |    5 -
>  include/linux/sched.h         |   12 --
>  kernel/trace/Kconfig          |    9 -
>  kernel/trace/Makefile         |    1 -
>  kernel/trace/trace.c          |   73 ++-------
>  kernel/trace/trace.h          |   10 --
>  kernel/trace/trace_entries.h  |   17 --
>  kernel/trace/trace_output.c   |   66 --------
>  kernel/trace/trace_selftest.c |   33 ----
>  kernel/trace/trace_sysprof.c  |  330 -----------------------------------------
>  10 files changed, 15 insertions(+), 541 deletions(-)

Pulled, thanks Frederic!

	Ingo
