Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0IJN2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab0IJN2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:28:23 -0400
Date: Fri, 10 Sep 2010 09:27:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
Message-ID: <20100910132741.GB4879@redhat.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284118900.402.35.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 01:41:40PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
> > Fixes to allow unknown nmis to pass through the perf nmi handler instead
> > of being swallowed.  Contains patches that are already in Ingo's tree.  Added
> > here for completeness.  Based on ingo/tip
> > 
> > Tested on intel/amd
> > 
> > v2: patch cleanups and consolidation, no code changes
> > 
> > Don Zickus (1):
> >   perf, x86: Fix accidentally ack'ing a second event on intel perf
> >     counter
> > 
> > Peter Zijlstra (1):
> >   perf, x86: Fix handle_irq return values
> > 
> > Robert Richter (1):
> >   perf, x86: Try to handle unknown nmis with an enabled PMU
> > 
> >  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
> >  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
> >  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
> >  3 files changed, 56 insertions(+), 20 deletions(-)
> 
> Both Ingo and I are getting Dazed and confused on our AMD machines, it
> started before yesterday (that is, after backing out all my recent
> changes it still gets dazed), so I suspect this set.
> 
> I'll look at getting a trace of the thing, but if any of you has a
> bright idea...

What are you running to create the problem?  I can try and duplicate it
here.

Cheers,
Don

