Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2KOWGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:06:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2KOWGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:09 -0500
Message-ID: <50A566FA.2090306@redhat.com>
Date: Thu, 15 Nov 2012 17:04:42 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Benchmark results: "Enhanced NUMA scheduling with adaptive affinity"
References: <20121112160451.189715188@chello.nl> <20121112184833.GA17503@gmail.com> <20121115100805.GS8218@suse.de> <CA+55aFyEJwRvQezg3oKg71Nk9+1QU7qwvo0BH4ykReKxNhFJRg@mail.gmail.com>
In-Reply-To: <CA+55aFyEJwRvQezg3oKg71Nk9+1QU7qwvo0BH4ykReKxNhFJRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 03:32 PM, Linus Torvalds wrote:
> Ugh.
>
> According to these numbers, the latest sched-numa actually regresses
> against mainline on Specjbb.
>
> No way is this even close to ready for merging in the 3.8 timeframe.
>
> I would ask the invilved people to please come up with a set of
> initial patches that people agree on, so that we can at least start
> merging some of the infrastructure, and see how far we can get on at
> least getting *started*. As I mentioned to Andrew and Mel separately,
> nobody seems to disagree with the TLB optimization patches. What else?
> Is Mel's set of early patches still considered a reasonable starting
> point for everybody?

Mel's infrastructure patches, 1-14 and 17 out
of his latest series, could be a great starting
point.

Ingo is trying to get the mm/ code in his tree
to be mostly the same to Mel's code anyway, so
that is the infrastructure everybody wants.

At that point, we can focus our discussions on
just the policy side, which could help us zoom in
on the issues.

It would also make it possible for us to do apple
to apple comparisons between the various policy
decisions, allowing us to reach a decision based
on data, not just gut feel.

As long as each tree has its own basic infrastructure,
we cannot do apples to apples comparisons; this has
frustrated the discussion for months.

Having all that basic infrastructure upstream should
short-circuit that part of the discussion.

