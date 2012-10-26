Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2JZH70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:59:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39069 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab2JZH7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:59:25 -0400
Date: Fri, 26 Oct 2012 09:59:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 10/31] mm/mpol: Remove NUMA_INTERLEAVE_HIT
Message-ID: <20121026075919.GA18211@gmail.com>
References: <20121025121617.617683848@chello.nl>
 <20121025124833.247790041@chello.nl>
 <m2txtiqnef.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2txtiqnef.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > Since the NUMA_INTERLEAVE_HIT statistic is useless on its 
> > own; it wants to be compared to either a total of interleave 
> > allocations or to a miss count, remove it.
> >
> > Fixing it would be possible, but since we've gone years 
> > without these statistics I figure we can continue that way.
> >
> > Also NUMA_HIT fully includes NUMA_INTERLEAVE_HIT so users 
> > might switch to using that.
> >
> > This cleans up some of the weird MPOL_INTERLEAVE allocation 
> > exceptions.
> 
> NACK, as already posted several times.
> 
> This breaks the numactl test suite, which is the only way 
> currently to test interleaving.

This patch is not essential to the NUMA series so I've zapped it 
from the patch queue and fixed up the roll-on effects.

Thanks,

	Ingo
