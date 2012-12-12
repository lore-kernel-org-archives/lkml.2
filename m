Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2LLWRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:17:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab2LLWRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:17:10 -0500
Date: Wed, 12 Dec 2012 22:17:03 +0000
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Automatic NUMA Balancing V11
Message-ID: <20121212221703.GU1009@suse.de>
References: <20121212100338.GS1009@suse.de>
 <20121213082741.fac1b3fa361a0746bcbe1040@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121213082741.fac1b3fa361a0746bcbe1040@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 08:27:41AM +1100, Stephen Rothwell wrote:
> Hi,
> 
> On Wed, 12 Dec 2012 10:03:38 +0000 Mel Gorman <mgorman@suse.de> wrote:
> >
> > This is a pull request for "Automatic NUMA Balancing V11". The list
> > of changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:
> > 
> >   Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git balancenuma-v11
> > 
> > for you to fetch changes up to 4fc3f1d66b1ef0d7b8dc11f4ff1cc510f78b37d6:
> > 
> >   mm/rmap, migration: Make rmap_walk_anon() and try_to_unmap_anon() more scalable (2012-12-11 14:43:00 +0000)
> > 
> > <SNIP>
> > These reports were quite late in the cycle so I/we would like to start
> > with this tree as it contains much of the code we can agree on and has
> > not changed significantly over the last 2-3 weeks.
> 
> It has, however all been rebased from what still exists in the linux-next
> tree (as part of the tip tree).
> 

What's in the tip tree is not the same even though there are
similarities. I know that bypassing linux-next like this is not the done
thing but it was not possible to have this tree in linux-next before
now. After this mail https://lkml.org/lkml/2012/12/11/62 my expectation
is that that the numacore bits from tip that were included in linux-next
will not be pulled this time. However, due to some of the similarities
I'm hoping that the collisions due to pulling this tree will not be too
severe.

-- 
Mel Gorman
SUSE Labs
