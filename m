Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab2ESLGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:06:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64155 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397Ab2ESLF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:05:58 -0400
Date: Sat, 19 May 2012 13:05:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched: Make find_busiest_queue a method
Message-ID: <20120519110552.GA2012@gmail.com>
References: <tip-3n9wqw2rdmhtu7qjhpoegh7u@git.kernel.org>
 <1337353008.573.49.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337353008.573.49.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2012-05-18 at 03:36 -0700, tip-bot for Peter Zijlstra wrote:
> 
> > sched: Make find_busiest_queue a method
> > 
> > Its a bit awkward but it was the least painful means of modifying the
> > queue selection. Used in a later patch to conditionally use a random
> > queue.
> > 
> 
> > ---
> >  include/linux/mm_types.h |    8 +
> >  include/linux/sched.h    |   14 +
> >  init/Kconfig             |    2 +-
> >  kernel/fork.c            |    2 +
> >  kernel/sched/Makefile    |    1 +
> >  kernel/sched/core.c      |   22 ++-
> >  kernel/sched/debug.c     |    3 +
> >  kernel/sched/fair.c      |  257 +++++++++++++++--
> >  kernel/sched/features.h  |   12 +
> >  kernel/sched/numa.c      |  741 ++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/sched/sched.h     |   34 +++
> >  mm/init-mm.c             |   10 +
> >  12 files changed, 1079 insertions(+), 27 deletions(-)
> 
> 
> Something went wrong here.. this were 3 patches:
> 
> Subject: sched: Make find_busiest_queue a method
> Subject: sched: Implement home-node awareness
> Subject: sched, numa: Numa balancer

Oops, indeed, good spotting - that was the victim of a 
post-review, post-commit backmerge of a fixlet workflow hickup 
so it went unnoticed by me. I Hate Rebases (tm).

Will push it out shortly, after some testing.

Thanks,

	Ingo
