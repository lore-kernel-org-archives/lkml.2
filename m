Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2ALUAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:00:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42966 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164Ab2ALUAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:00:13 -0500
X-Sasl-enc: paCW/vpz2L/U78XE3dlICdUp3cOUBdx0CIz+hMf45FmP 1326398412
Date: Thu, 12 Jan 2012 12:00:03 -0800
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, "Ted Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [lttng-dev] Perf ABI (was: Re: [PATCH 09/11] sched: export
 task_prio to GPL modules)
Message-ID: <20120112200003.GC28100@kroah.com>
References: <20111219104915.GA19861@elte.hu>
 <20111219153053.GA21548@Krystal>
 <20111220110813.GA19105@elte.hu>
 <20111223164629.GA30474@Krystal>
 <20111223172155.GA14117@thunk.org>
 <20111223181641.GA12681@Krystal>
 <20111225174613.GA12732@thunk.org>
 <20120112140905.GA30377@Krystal>
 <1326380042.7642.73.camel@gandalf.stny.rr.com>
 <20120112153957.GA20514@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112153957.GA20514@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:39:57AM -0500, Mathieu Desnoyers wrote:
> > We've done this without version numbers. Just look at all the udev
> > changes.
> 
> Are you seriously refering to udev as an example of how to handle
> changes, or as one of the worse ABI breakage mess that happened in the
> Linux kernel history ? My own experience as a Linux users (in the
> era around 2.6.12 kernels if my memory serves me right) lead me to think
> it's the latter. And because udev is part of the runtime support, that
> indeed led to non-bootable systems and lots of frustrated users.

Really?  You fail to remember the fact that we _fixed_ those
non-bootable systems by putting the userspace bits back, and symlinks,
and all other sorts of gyrations in order to prevent userspace from
breaking again.

And it worked, and people's machines worked again, and no one since then
has reported a problem.

So I think udev actually is a good example of how to do it right, we
provide proper backwards compatibility in the kernel to keep userspace
working.

thanks,

greg k-h
