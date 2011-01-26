Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1AZU7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:59:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab1AZU7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:59:13 -0500
Date: Wed, 26 Jan 2011 21:59:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/3] [GIT PULL][v2.6.38] tracing: fix unaligned event
 arrays
Message-ID: <20110126205903.GC14361@elte.hu>
References: <20110126040459.289776311@goodmis.org>
 <20110126064723.GA15752@elte.hu>
 <1296068107.10144.71.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296068107.10144.71.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2011-01-26 at 07:47 +0100, Ingo Molnar wrote:
> 
> > > Mathieu Desnoyers (3):
> > >       Introduce __u64_aligned and U64_ALIGN() for structure alignment in custom sections
> > >       tracing: Fix sparc64 alignment crash with __u64_aligned/U64_ALIGN()
> > >       tracepoints: Use __u64_aligned/U64_ALIGN()
> > > 
> 
> > Pulled, thanks a lot Steve!
> > 
> > 	Ingo
> 
> 
> Hi Ingo,
> 
> We (well Peter really) just discovered that this can cause alignment
> issues with gcc 4.4.4 and 4.4.5 (I unfortunately only tested it with gcc
> 4.5.1). We are currently looking into fixing it.
> 
> Letting you know so that you don't push this off to Linus ;-)

Well, i found and reported that 'perf stat -e irq:irq_handler_entry -a sleep 1' 
crash to Peter (i first thought it's due to his patch) so yes i know about it :-)

Thanks,

	Ingo
