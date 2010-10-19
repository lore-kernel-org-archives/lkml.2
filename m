Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0JSSlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:41:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab0JSSlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:41:19 -0400
Date: Tue, 19 Oct 2010 20:41:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101019184111.GA17266@elte.hu>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287508282.16971.386.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (1):
>       tracing: Fix compile issue for trace_sched_wakeup.c
> ----
>  kernel/trace/trace_sched_wakeup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Pulled, thanks Steve!

	Ingo
