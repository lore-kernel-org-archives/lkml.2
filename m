Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2KPRt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:49:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50046 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2KPRtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:49:25 -0500
Date: Fri, 16 Nov 2012 18:49:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Benchmark results: "Enhanced NUMA scheduling with adaptive
 affinity"
Message-ID: <20121116174918.GA4723@gmail.com>
References: <20121112160451.189715188@chello.nl>
 <20121112184833.GA17503@gmail.com>
 <20121115100805.GS8218@suse.de>
 <20121116155626.GA4271@gmail.com>
 <20121116162556.GD8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116162556.GD8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> On Fri, Nov 16, 2012 at 04:56:26PM +0100, Ingo Molnar wrote:
> > 
> > * Mel Gorman <mgorman@suse.de> wrote:
> > 
> > > It is important to know how this was configured. I was running 
> > > one JVM per node and the JVMs were sized that they should fit 
> > > in the node. [...]
> > 
> > That is not what I tested: as I described it in the mail I 
> > tested 32 warehouses: i.e. spanning the whole system.
> > 
> 
> Good (sortof) [...]

Not just 'sortof' good but it appears it's unconditionally good: 
meanwhile other testers have reproduced the single-JVM speedup 
with the latest numa/core code as well, so the speedup is not 
just on my system.

Please post your kernel .config so I can check why the 4x JVM 
test does not perform so well on your system. Maybe there's 
something special to your system.

Thanks,

	Ingo
