Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2APIzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:55:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab2APIzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:55:37 -0500
Date: Mon, 16 Jan 2012 09:55:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, "Ted Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [lttng-dev] Perf ABI (was: Re: [PATCH 09/11] sched: export
 task_prio to GPL modules)
Message-ID: <20120116085507.GA759@elte.hu>
References: <20111219153053.GA21548@Krystal>
 <20111220110813.GA19105@elte.hu>
 <20111223164629.GA30474@Krystal>
 <20111223172155.GA14117@thunk.org>
 <20111223181641.GA12681@Krystal>
 <20111225174613.GA12732@thunk.org>
 <20120112140905.GA30377@Krystal>
 <1326380042.7642.73.camel@gandalf.stny.rr.com>
 <20120112153957.GA20514@Krystal>
 <20120112200003.GC28100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112200003.GC28100@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> So I think udev actually is a good example of how to do it 
> right, we provide proper backwards compatibility in the kernel 
> to keep userspace working.

I agree, i still have a udev system that i installed 5 years 
ago, and it's working mostly fine with current kernels.

Compatibility is a desirable property, it is something that 
preserves our users - and if done right it's almost never a big 
issue technically. If it is hindering someone then there must be 
other problems.

Of course to developers the simplest approach is always to just 
develop without regard for compatibility. The simplest form of 
that is that people write patches that work fine on their own 
systems but crash the kernel on other systems. We fix those 
bugs. Another, subtler form is when the patches work fine on 
their systems but break apps on other systems. We fix those bugs 
too.

That's why we have testing, regression tracking and maintainers, 
to control that - compatibility is just another dimension to 
'correctness', in the typical case with no inherent restrictions 
on future features and possibilities.

Thanks,

	Ingo
