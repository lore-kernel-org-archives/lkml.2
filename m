Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2KPUFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:05:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab2KPUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:05:19 -0500
Date: Fri, 16 Nov 2012 20:05:15 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Benchmark results: "Enhanced NUMA scheduling with adaptive
 affinity"
Message-ID: <20121116200514.GJ8218@suse.de>
References: <20121112160451.189715188@chello.nl>
 <20121112184833.GA17503@gmail.com>
 <20121115100805.GS8218@suse.de>
 <CA+55aFyEJwRvQezg3oKg71Nk9+1QU7qwvo0BH4ykReKxNhFJRg@mail.gmail.com>
 <50A566FA.2090306@redhat.com>
 <20121116141428.GZ8218@suse.de>
 <20121116195018.GA8908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121116195018.GA8908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 08:50:18PM +0100, Andrea Arcangeli wrote:
> Hi,
> 
> On Fri, Nov 16, 2012 at 02:14:28PM +0000, Mel Gorman wrote:
> > With some shuffling the question on what to consider for merging
> > becomes
> > 
> >
> > 1. TLB optimisation patches 1-3?	 	Patches  1-3
> 
> I assume you mean simply reshuffling 33-35 as 1-3.
> 

Yes.

> > 2. Stats for migration?				Patches  4-6
> > 3. Common NUMA infrastructure?			Patches  7-21
> > 4. Basic fault-driven policy, stats, ratelimits	Patches 22-35
> > 
> > Patches 36-43 are complete cabbage and should not be considered at this
> > stage. It should be possible to build the placement policies and the
> > scheduling decisions from schednuma, autonuma, some combination of the
> > above or something completely different on top of patches 1-35.
> > 
> > Peter, Ingo, Andrea?
> 
> The patches 1-35 looks a great foundation so I think they'd be an
> ideal candidate for a first upstream inclusion.
> 

Thanks.

-- 
Mel Gorman
SUSE Labs
