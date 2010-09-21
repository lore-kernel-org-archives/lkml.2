Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0IUPby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:31:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0IUPbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:31:53 -0400
Date: Tue, 21 Sep 2010 17:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH][GIT PULL] tracing/sched: Add sched_pi_setprio tracepoint
Message-ID: <20100921153134.GB23380@elte.hu>
References: <1285081349.23122.1907.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285081349.23122.1907.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> I rebased this against tip/sched/core, and removed the push/pull
> tracepoint. I made the change that Peter suggested and got his Acked-by.
> 
> Please pull the latest tip/sched/rt tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/sched/rt
> 
> 
> Steven Rostedt (1):
>       tracing/sched: Add sched_pi_setprio tracepoint
> 
> ----
>  include/trace/events/sched.h |   29 +++++++++++++++++++++++++++++
>  kernel/sched.c               |    1 +
>  2 files changed, 30 insertions(+), 0 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
