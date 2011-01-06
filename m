Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1AFSIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:08:31 -0500
Received: from mail.openrapids.net ([64.15.138.104]:49522 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752472Ab1AFSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:08:30 -0500
Date: Thu, 6 Jan 2011 13:08:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
Message-ID: <20110106180827.GB30610@Krystal>
References: <20110104232419.441463699@efficios.com> <20110105000005.GE2911@nowhere> <20110105001837.GA9737@Krystal> <20110105020759.GG2911@nowhere> <20110105023541.GA12950@Krystal> <20110105025848.GH2911@nowhere> <20110105135242.GC31831@Krystal> <20110105150245.GA1692@nowhere> <20110105195612.GA9709@Krystal> <20110105234021.GC1692@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105234021.GC1692@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:53:35 up 43 days, 22:56,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Wed, Jan 05, 2011 at 02:56:12PM -0500, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > [...]
> > > Looks good!
> > > 
> > > I might be missing corner things but it seems this would reduce the code
> > > footprint (one function less) and turn more rw into ro datas.
> > > 
> > > So it seems to be a very valuable reason to change the semicolon requirement
> > > all over the place.
> > > 
> > > If you come up with this feature along the massive semicolon requirement
> > > change, we will probably happily apply the whole.
> > > 
> > > But coming with only the semicolon change is more like an empty shell.
> > 
> > My proposal here is to incrementally improve the tracing code, starting by
> > cleaning up what is already there. I cannot do this if you keep asking me for
> > larger changes to both Ftrace and Perf before any of the prerequisite cleanups
> > can make their way in.
> > 
> > In this thread, I demonstrated that the TRACE_EVENT cleanup I proposed opens a
> > lot of code/data size reduction cleanups for Ftrace and Perf. But let's get the
> > cleanup in there first (it does not break the current way Ftrace and Perf are
> > working), and once all the code-base has moved to the semicolumn-less semantic,
> > then we can start improving Ftrace and Perf.
> 
> Don't be suprised of my reaction. The way the things were presented was:
> 
> 1) A patch with an meaningless changelog, absolutely no idea why that new
> semicolon is useful for.
> 
> 2) Me asking you why
> 
> 3) You explaining me it's actually part of a much bigger cleanup for
> a goal almost completely useless
> 
> 4) Me has a hard time considering the big cleanup useful as is. Expressing
> my worries.
> 
> 5) You detailing much more the semicolon symptoms, and finally dropping an
> evasive reason to do this cleanup, collapsed in the obsure notion of "arrays
> of event"..
> 
> 6) Me still puzzled by the big cleanup just for the sake of unnoticeable
> files.i pollution cleanup. But I try to give some chance by asking to
> expand the "arrays of event" idea.
> 
> 7) You explaining me something that looks like a meaningful, useful reason for
> the big cleanup, but as a possibility. You propose me that I reuse the Lttng code that
> you pick as an example, not suggesting you're planing to handle that part.
> 
> 8) Me: ok for the big cleanup then, if you plan to also handle the useful change
> you detailed, because otherwise it's meaningless.
> 
> See? That meaningful reason came so late in the discussion, and was proposed
> so much under the angle of the possibility rather than something you plan
> that I just thought you would just drop that empty shell and run away.
> 
> Hence my worries.
> 
> But if you plan to do the thing incrementally, this is also perfectly ok.
> 
> And you know what, may be you won't eventually have the time to complete
> with the useful part. And may be someone else will handle that part.
> Whatever, it's ok. We don't always finish everything.
> But at least fill your changelogs with the useful longterm goal so that we
> know we are going somewhere with this.

Fair enough. I clearly see that for you it is tremendousy important to
understand what is the advantage of merging one of my patches, so I'll try to
better outline my motivation in the future. I seem to have misunderstood you
initially, thinking that you wanted me to push a large monster-patchset
- or nothing, which made me reluctant to tell you more about my plans. But if we
agree on working on these things incrementally, then I think we'll automatically
start benefiting from each other's work.

> > As we say in French, "il ne faut pas mettre la charrue devant les boeufs"
> > (roughly: don't put the cart before the horse)
> 
> As we say in French, "oui mais il a fallu te tirer les vers du nez"
> (roughly: right, but still I had to worm it out of you)

Thanks for coping with my attitude here. I might indeed not have been as
straightforward as I should. I'll work on that. Knowing that you are open about
incremental improvements, and that it's not a "all or nothing" policy, makes me
much more inclined to describe my motivation.

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
