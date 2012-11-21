Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2KVV3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:29:54 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63520 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2KVV3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:29:51 -0500
Date: Thu, 22 Nov 2012 00:27:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
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
Message-ID: <20121121232715.GA4638@gmail.com>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <20121121165342.GH8218@suse.de>
 <20121121170306.GA28811@gmail.com>
 <20121121172011.GI8218@suse.de>
 <20121121173316.GA29311@gmail.com>
 <20121121180200.GK8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121180200.GK8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> > I did a quick SPECjbb 32-warehouses run as well:
> > 
> >                                 numa/core      balancenuma-v4
> >       SPECjbb  +THP:               655 k/sec      607 k/sec
> > 
> 
> Cool. Lets see what we have here. I have some questions;
> 
> You say you ran with 32 warehouses. Was this a single run with 
> just 32 warehouses or you did a specjbb run up to 32 
> warehouses and use the figure specjbb spits out? [...]

"32 warehouses" obviously means single instance...

Any multi-instance configuration is explicitly referred to as 
multi-instance. In my numbers I sometimes tabulate them as "4x8 
multi-JVM", that means the obvious as well: 4 instances, 8 
warehouses each.

Thanks,

	Ingo
