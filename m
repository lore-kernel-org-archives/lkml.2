Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0IJLl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:41:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0IJLl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:41:57 -0400
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, robert.richter@amd.com, gorcunov@gmail.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
In-Reply-To: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 13:41:40 +0200
Message-ID: <1284118900.402.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
> Fixes to allow unknown nmis to pass through the perf nmi handler instead
> of being swallowed.  Contains patches that are already in Ingo's tree.  Added
> here for completeness.  Based on ingo/tip
> 
> Tested on intel/amd
> 
> v2: patch cleanups and consolidation, no code changes
> 
> Don Zickus (1):
>   perf, x86: Fix accidentally ack'ing a second event on intel perf
>     counter
> 
> Peter Zijlstra (1):
>   perf, x86: Fix handle_irq return values
> 
> Robert Richter (1):
>   perf, x86: Try to handle unknown nmis with an enabled PMU
> 
>  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
>  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
>  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
>  3 files changed, 56 insertions(+), 20 deletions(-)

Both Ingo and I are getting Dazed and confused on our AMD machines, it
started before yesterday (that is, after backing out all my recent
changes it still gets dazed), so I suspect this set.

I'll look at getting a trace of the thing, but if any of you has a
bright idea...
