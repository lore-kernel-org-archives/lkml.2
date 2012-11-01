Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2KANOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab2KANOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:14:16 -0400
Message-ID: <5092758C.10309@redhat.com>
Date: Thu, 01 Nov 2012 09:13:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "H. Peter Anvin" <hpa@zytor.com>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 02/31] sched, numa, mm: Describe the NUMA scheduling problem
 formally
References: <20121025121617.617683848@chello.nl> <20121025124832.621452204@chello.nl> <20121101095658.GM3888@suse.de>
In-Reply-To: <20121101095658.GM3888@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 05:56 AM, Mel Gorman wrote:
> On Thu, Oct 25, 2012 at 02:16:19PM +0200, Peter Zijlstra wrote:
>> This is probably a first: formal description of a complex high-level
>> computing problem, within the kernel source.
>>
>
> Who does not love the smell of formal methods first thing in the
> morning?

The only issue I have with this document is that it does not have
any description of how the source code tries to solve the problem
at hand.

A description of how the problem is solved will make the documentation
useful to people trying to figure out why the NUMA code does what
it does.

Of course, since we still do not know what sched-numa needs to do
in order to match autonuma performance, that description would have
to be updated later, anyway.

-- 
All rights reversed
