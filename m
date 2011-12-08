Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab1LHFm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 00:42:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab1LHFm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 00:42:27 -0500
Date: Thu, 8 Dec 2011 06:40:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg KH <greg@kroah.com>, Peter Zijlstra <peterz@infradead.org>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111208054036.GA6636@elte.hu>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111207225758.GA6541@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207225758.GA6541@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Hi Ingo,
> 
> * Ingo Molnar (mingo@elte.hu) wrote:
> [...]
> > Mathieu, please work with the tracing folks who DO care about 
> > this stuff. It's not like there's a lack of interest in this 
> > area, nor is there a lack of willingness to take patches. What 
> > there is a lack of is your willingness to actually work on 
> > getting something unified, integrated to users...
> > 
> > LTTNG has been going on for how many years? I havent seen many 
> > steps towards actually *merging* its functionality - you insist 
> > on doing your own random thing, which is different in random 
> > ways. Yes, some of those random ways may in fact be better than 
> > what we have upstream - would you be interested in filtering 
> > those out and pushing them upstream? I certainly would like to 
> > see that happen.
> >
> > We want to pick the best features, and throw away current 
> > upstream code in favor of superior out of tree code - this 
> > concept of letting crap sit alongside each other when people do 
> > care i cannot agree with.
> 
> LTTng 2.0, today, offers a unified interface for kernel and 
> userspace tracing, in the form of libraries and git-alike 
> command line user interface. [...]

Note that Arnaldo is working on such a perf-alike tracing tool 
workflow with the new 'trace' utility that we announced and 
prototyped a couple of months ago.

The perf.data data format is now extensible as well and 
tightened for transportability. Tools such as PowerTop or 
sysprof have standardized around the perf ABI.

So there's a *lot* of overlap with existing upstream efforts and 
the last thing we need is the parallel LTTNG ABI.

Are you willing to merge LTTNG into our existing kernel and 
userspace infrastructure and ABIs, with the possible end result 
that LTTNG ceases to be a separately named entity?

Mind hooking up with Arnaldo and with Steve regarding how we 
could best split up the LTTNG bits and move them upstream?

Frankly, i've seen a *lot* of talk from you but unfortunately 
*very* little action on that front, so i think my healthy 
scepticism is justified.

Thanks,

	Ingo
