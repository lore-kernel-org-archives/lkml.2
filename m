Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161176Ab2KNLgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:36:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161052Ab2KNLgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:36:41 -0500
Date: Wed, 14 Nov 2012 11:36:36 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/31] Latest numa/core patches, v15
Message-ID: <20121114113636.GK8218@suse.de>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
 <20121113175428.GF8218@suse.de>
 <20121114075222.GA3522@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121114075222.GA3522@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 08:52:22AM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > On Tue, Nov 13, 2012 at 06:13:23PM +0100, Ingo Molnar wrote:
> > > Hi,
> > > 
> > > This is the latest iteration of our numa/core tree, which
> > > implements adaptive NUMA affinity balancing.
> > > 
> > > Changes in this version:
> > > 
> > >     https://lkml.org/lkml/2012/11/12/315
> > > 
> > > Performance figures:
> > > 
> > >     https://lkml.org/lkml/2012/11/12/330
> > > 
> > > Any review feedback, comments and test results are welcome!
> > > 
> > 
> > For the purposes of review and testing, this is going to be 
> > hard to pick apart and compare. It doesn't apply against 
> > 3.7-rc5 [...]
> 
> Because the scheduler changes are highly non-trivial it's on top 
> of the scheduler tree:
> 
>    git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
> 
> I just tested the patches, they all apply cleanly, with zero 
> fuzz and offsets.
> 

The actual numa patches don't apply on top of that but at least the
conflicts are obvious to resolve. I'll queue up a test to run overnight
but in the meantime, does the current implementation of the NUMA patches
*depend* on any of those scheduler patches? Normally I would say it'd be
obvious from the series except in this case it just isn't because of the
monolithic nature of some of the patches.

-- 
Mel Gorman
SUSE Labs
