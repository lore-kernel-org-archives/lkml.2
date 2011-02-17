Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1BQOFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:05:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab1BQOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:05:04 -0500
Date: Thu, 17 Feb 2011 15:04:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/10] [GIT PULL][v2.6.39] tracing: updates
Message-ID: <20110217140442.GA8326@elte.hu>
References: <20110208221612.084294240@goodmis.org>
 <20110217135023.GA5235@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217135023.GA5235@elte.hu>
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


> > Please pull the latest tip/perf/core tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/perf/core

Note that these changes caused a new build failure on arch/m32r:

/home/mingo/tip/drivers/net/smc91x.h:199:1: warning: this is the location of the previous definition
/home/mingo/tip/kernel/trace/ring_buffer.c: In function 'rb_reserve_next_event':
/home/mingo/tip/kernel/trace/ring_buffer.c:2165: error: 'sched_clock_stable' undeclared (first use in this function)
/home/mingo/tip/kernel/trace/ring_buffer.c:2165: error: (Each undeclared identifier is reported only once
/home/mingo/tip/kernel/trace/ring_buffer.c:2165: error: for each function it appears in.)
make[3]: *** [kernel/trace/ring_buffer.o] Error 1
make[2]: *** [kernel/trace] Error 2

Thanks,

	Ingo
