Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2ALQ2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:28:00 -0500
Received: from mail.openrapids.net ([64.15.138.104]:47940 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752600Ab2ALQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:27:59 -0500
Date: Thu, 12 Jan 2012 11:27:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: devel@driverdev.osuosl.org, "Ted Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [lttng-dev] Perf ABI (was: Re: [PATCH 09/11] sched: export
	task_prio to GPL modules)
Message-ID: <20120112162756.GA2540@Krystal>
References: <20111219153053.GA21548@Krystal> <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal> <20111223172155.GA14117@thunk.org> <20111223181641.GA12681@Krystal> <20111225174613.GA12732@thunk.org> <20120112140905.GA30377@Krystal> <1326380042.7642.73.camel@gandalf.stny.rr.com> <20120112153957.GA20514@Krystal> <1326383629.7642.85.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326383629.7642.85.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:25:10 up 414 days, 21:28,  6 users,  load average: 0.05, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2012-01-12 at 10:39 -0500, Mathieu Desnoyers wrote:
> 
> > pipe()/pipe2()
> > dup()/dup2()/dup3()
> > umount()/umount2()
> > mmap()/mmap2()
> > madvise()/madvise1()
> > eventfd()/eventfd2()
> > 
> > Those look very much like major version numbers to me. And these are
> > entirely compatible with your statement above about using -ENOSYS to
> > detect if the major version number is implemented or not.
> 
> That's a stretch in calling version numbers. All but the madvise case
> above are how many parameters it takes, not really a "version" number.
> 
> It's adding a new syscall, not updating a version and then deprecating
> the old one. As I believe all the above are still supported.
> 
> > 
> > If your only concern is that the major version number should be part of
> > the ABI name (as in the examples above), that can be arranged.
> 
> > > 
> > > We've done this without version numbers. Just look at all the udev
> > > changes.
> > 
> > Are you seriously refering to udev as an example of how to handle
> > changes, or as one of the worse ABI breakage mess that happened in the
> > Linux kernel history ? My own experience as a Linux users (in the
> > era around 2.6.12 kernels if my memory serves me right) lead me to think
> > it's the latter. And because udev is part of the runtime support, that
> > indeed led to non-bootable systems and lots of frustrated users.
> 
> Yeah, I know it sucked, as I got burned by it too. But having "version"
> numbers wouldn't have helped at all. In fact, it should have kept both
> ways working much longer, or at least had the new udev support both. 
> 
> What udev did is more like what you want to do than what I did with
> trace-cmd.

OK. Then how can trace-cmd support the LTTng features ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
