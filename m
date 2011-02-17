Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1BQOzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:55:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab1BQOzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:55:36 -0500
Date: Thu, 17 Feb 2011 15:55:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/10] [GIT PULL][v2.6.39] tracing: updates
Message-ID: <20110217145509.GA10112@elte.hu>
References: <20110208221612.084294240@goodmis.org>
 <20110217135023.GA5235@elte.hu>
 <20110217140442.GA8326@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217140442.GA8326@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> > > Please pull the latest tip/perf/core tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > tip/perf/core
> 
> Note that these changes caused a new build failure on arch/m32r:

powerpc and parisc is showing similar build failures. The other architectures are 
fine.

So i suspect it relates to !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK architectures and the 
fact that sched_clock_stable is not uniformly available. The right fix would be to 
provide that flag in a Kconfig-invariant fashion.

Thanks,

	Ingo
