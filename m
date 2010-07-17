Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966238Ab0GQKAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 06:00:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762Ab0GQKAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 06:00:01 -0400
Date: Sat, 17 Jul 2010 11:59:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] tracing cleanups
Message-ID: <20100717095952.GD12435@elte.hu>
References: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279231603-30624-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0251]
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
> Frederic Weisbecker (3):
>       tracing: Update tracing branch url
>       tracing: Remove ksym tracer
>       tracing: Remove letfover markers section
> 
> 
>  MAINTAINERS                       |    2 +-
>  include/asm-generic/vmlinux.lds.h |    4 -
>  kernel/trace/Kconfig              |   22 --
>  kernel/trace/Makefile             |    1 -
>  kernel/trace/trace.h              |    6 -
>  kernel/trace/trace_entries.h      |   15 -
>  kernel/trace/trace_ksym.c         |  508 -------------------------------------
>  kernel/trace/trace_selftest.c     |   54 ----
>  8 files changed, 1 insertions(+), 611 deletions(-)

Pulled, thanks Frederic!

	Ingo
