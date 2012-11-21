Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2KURUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:20:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab2KURUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:20:18 -0500
Date: Wed, 21 Nov 2012 17:20:11 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/46] Automatic NUMA Balancing V4
Message-ID: <20121121172011.GI8218@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <20121121165342.GH8218@suse.de>
 <20121121170306.GA28811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121121170306.GA28811@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 06:03:06PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > On Wed, Nov 21, 2012 at 10:21:06AM +0000, Mel Gorman wrote:
> > > 
> > > I am not including a benchmark report in this but will be posting one
> > > shortly in the "Latest numa/core release, v16" thread along with the latest
> > > schednuma figures I have available.
> > > 
> > 
> > Report is linked here https://lkml.org/lkml/2012/11/21/202
> > 
> > I ended up cancelling the remaining tests and restarted with
> > 
> > 1. schednuma + patches posted since so that works out as
> 
> Mel, I'd like to ask you to refer to our tree as numa/core or 
> 'numacore' in the future. Would such a courtesy to use the 
> current name of our tree be possible?
> 

Sure, no problem.

> (We dropped sched/numa long ago and that you still keep 
> referring to it is rather confusing to me.)
> 

Understood.

-- 
Mel Gorman
SUSE Labs
