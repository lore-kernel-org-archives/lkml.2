Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2KNRFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:05:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab2KNRFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:05:32 -0500
Message-ID: <50A3CF4B.8020806@redhat.com>
Date: Wed, 14 Nov 2012 12:05:15 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: linux-next: Tree for Nov 14
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au> <20121113213742.292f3ace.akpm@linux-foundation.org> <20121114064726.GA2537@gmail.com> <20121113225635.a848fd6c.akpm@linux-foundation.org> <20121114073929.GA3130@gmail.com> <alpine.LNX.2.00.1211132346120.19216@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1211132346120.19216@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 03:13 AM, Hugh Dickins wrote:

> Please, Ingo, stop trying to force this in ahead of time, yet again.
>
> People are still reviewing and comparing competing solutions.
> Maybe this latest will prove to be closest to the right answer,
> maybe it will not.  It's, what, about two days old right now?
>
> If we had wanted to push in a good solution a little prematurely,
> we would surely have chosen Andrea's AutoNUMA months ago, despite
> efforts to block it; and maybe we shall still want to go that way.

As much as I would like to see NUMA stuff going upstream
the day before yesterday, I have to agree with Hugh that
we need to do things right.

Having unreviewed (some of it NAKed) code sitting in
tip.git and you trying to force it upstream is not the
right way to go.

> Please, forget about v3.8, cut this branch out of linux-next,
> and seek consensus around getting it right for v3.9.

I suspect that no matter how long we delay merging the
NUMA placement code, we will always run into some kind
of regression. I am not sure if a delay will buy us much.

On the mm/ bits, there appears to be consensus already.
Mel Gorman's patch series contains the nicest mm/ bits
from autonuma and sched/numa, plus further improvements.
Andrea has supported Mel's series, and Ingo is pulling
code from it.

That leads me to believe Mel's NUMA bits may be worth
considering for 3.8.

On top of that, we could place the policy code by
Peter and Ingo, but as a nice reviewable patch series,
not hidden away through various tip.git branches.

Does a combination of Mel's NUMA mm/ bits and the
policy code from Peter and Ingo sound reasonable?

Mel, is that reasonable to you?

Peter & Ingo, are you willing to rebase your policy
code on top of Mel's mm/ patches?

-- 
All rights reversed
