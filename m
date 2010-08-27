Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0H0Sid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:38:33 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60529 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752363Ab0H0Sib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:38:31 -0400
Date: Fri, 27 Aug 2010 14:38:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827183830.GD22679@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <20100826234910.GB4194@Krystal> <1282894960.1975.1666.camel@laptop> <1282897192.7185.28.camel@marge.simson.net> <20100827154334.GE14926@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827154334.GE14926@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:37:55 up 216 days, 21:14,  4 users,  load average: 0.05, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Mike Galbraith (efault@gmx.de) wrote:
> > On Fri, 2010-08-27 at 09:42 +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-08-26 at 19:49 -0400, Mathieu Desnoyers wrote:
> > > > AFAIK, I don't think we would end up starving the system in any possible way.
> > > 
> > > Correct, it does maintain fairness.
> > > 
> > > > So far I cannot see a situation where selecting the next buddy would _not_ make
> > > > sense in any kind of input-driven wakeups (interactive, timer, disk, network,
> > > > etc). But maybe it's just a lack of imagination on my part. 
> > > 
> > > The risk is that you end up with always using next-buddy, and we tried
> > > that a while back and that didn't work well for some, Mike might
> > > remember.
> > 
> > I turned it off because it was ripping spread apart badly, and last
> > buddy did a better job of improving scalability without it.
> 
> Maybe with the dyn min_vruntime feature proposed in this patchset we should
> reconsider this. Spread being ripped apart is exactly what it addresses.

I'm curious: which workload was showing this kind of problem exactly ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
