Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0IMST2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:19:28 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49997 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752618Ab0IMST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:19:27 -0400
Date: Mon, 13 Sep 2010 14:19:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC PATCH] check_preempt_tick should not compare vruntime
	with wall time
Message-ID: <20100913181925.GA15107@Krystal>
References: <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop> <20100913161641.GA28707@Krystal> <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com> <20100913174533.GA15653@Krystal> <20100913180348.GA20171@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913180348.GA20171@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:17:50 up 233 days, 20:54,  4 users,  load average: 0.14, 0.06,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > > On Mon, Sep 13, 2010 at 9:16 AM, Mathieu Desnoyers
> > > <mathieu.desnoyers@efficios.com> wrote:
> > > >
> > > > OK, the long IRC discussions we just had convinced me that the current scheme
> > > > takes things into account by adapting the granularity dynamically, but also got
> > > > me to notice that check_preempt seems to compare vruntime with wall time, which
> > > > is utterly incorrect. So maybe all my patch was doing was to expose this bug:
> > > 
> > > Do you have latency numbers for this patch?
> > 
> > Sure, see below,
> > 
> > In addition to this patch, [...]
> 
> Note, which is a NOP for your latency workload.
> 
> > [...] I also used Peter's approach of reducing the minimum granularity
> 
> Ok, that's the very first patch i sent yesterday morning - so we also 
> have my numbers that it reduces latencies.
> 
> To move things along i'll apply it with your Reported-by and Acked-by 
> line, ok?
> 
> We can also work on the other, more complex things after that, but first 
> lets make some progress on the latency front ...

Yep, that's fine with me.

Thanks!

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
