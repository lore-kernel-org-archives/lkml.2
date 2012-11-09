Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2KIItx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:49:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab2KIItw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:49:52 -0500
Message-ID: <509CC42E.1040200@redhat.com>
Date: Fri, 09 Nov 2012 03:51:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/31] numa/core patches
References: <20121025121617.617683848@chello.nl> <20121030122032.GC3888@suse.de>
In-Reply-To: <20121030122032.GC3888@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 08:20 AM, Mel Gorman wrote:
> On Thu, Oct 25, 2012 at 02:16:17PM +0200, Peter Zijlstra wrote:
>> Hi all,
>>
>> Here's a re-post of the NUMA scheduling and migration improvement
>> patches that we are working on. These include techniques from
>> AutoNUMA and the sched/numa tree and form a unified basis - it
>> has got all the bits that look good and mergeable.
>>
>
> Thanks for the repost. I have not even started a review yet as I was
> travelling and just online today. It will be another day or two before I can
> start but I was at least able to do a comparison test between autonuma and
> schednuma today to see which actually performs the best. Even without the
> review I was able to stick on similar vmstats as was applied to autonuma
> to give a rough estimate of the relative overhead of both implementations.

Peter, Ingo,

do you have any comments on the performance measurements
by Mel?

Any ideas on how to fix sched/numa or numa/core?

At this point, I suspect the easiest way forward might be
to merge the basic infrastructure from Mel's combined
tree (in -mm? in -tip?), so we can experiment with different
NUMA placement policies on top.

That way we can do apples to apples comparison of the
policies, and figure out what works best, and why.


