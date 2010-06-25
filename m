Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0FYJd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:33:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0FYJdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:33:24 -0400
Date: Fri, 25 Jun 2010 11:33:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perf events and breakpoints updates
Message-ID: <20100625093302.GA26253@elte.hu>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
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
>       hw_breakpoints: Fix per task breakpoint tracking
>       x86: Set resume bit before returning from breakpoint exception
>       x86: Support for instruction breakpoints
>       perf: Don't use 4 bytes as a default instruction breakpoint length
>       perf: Don't print traces when debugging ordering
>       perf: Report lost events in perf trace debug mode
> 
> Nobuhiro Iwamatsu (1):
>       perf: Fix argument of perf_arch_fetch_caller_regs
> 
> 
>  arch/x86/include/asm/hw_breakpoint.h |    2 +-
>  arch/x86/kernel/hw_breakpoint.c      |   51 ++++++++++++++++-------
>  include/linux/perf_event.h           |    8 ++-
>  kernel/hw_breakpoint.c               |   78 ++++++++++++++++++----------------
>  tools/perf/builtin-trace.c           |   32 ++++++++++++--
>  tools/perf/util/parse-events.c       |   11 ++++-
>  6 files changed, 119 insertions(+), 63 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
