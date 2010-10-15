Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0JODNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:13:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57687 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0JODNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:13:24 -0400
Date: Fri, 15 Oct 2010 05:13:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] small instrumentation updates
Message-ID: <20101015031314.GE9640@elte.hu>
References: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
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
> Borislav Petkov (1):
>       tracing: Fix function-graph build warning on 32-bit
> 
> Frederic Weisbecker (1):
>       x86: Barf when vmalloc and kmemcheck faults happen in NMI
> 
> 
>  arch/x86/mm/fault.c                  |    4 ++++
>  arch/x86/mm/kmemcheck/kmemcheck.c    |    2 ++
>  kernel/trace/trace_functions_graph.c |    5 +++--
>  3 files changed, 9 insertions(+), 2 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
