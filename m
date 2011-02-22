Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1BVR3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:29:36 -0500
Received: from Mail.MNSU.EDU ([134.29.1.12]:46470 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1BVR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:29:35 -0500
X-Greylist: delayed 1399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 12:29:35 EST
Message-ID: <4D63EC77.6070208@mnsu.edu>
Date: Tue, 22 Feb 2011 11:03:51 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v6 0/4] fadvise(DONTNEED) support
References: <cover.1298212517.git.minchan.kim@gmail.com> <20110221190713.GM13092@random.random> <AANLkTimOhgK953rmOw4PqnoFq_e7y6j1m+NBDYJehkds@mail.gmail.com> <20110222132804.GQ13092@random.random>
In-Reply-To: <20110222132804.GQ13092@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 07:28 AM, Andrea Arcangeli wrote:
> Hi Minchan,
> That's my point, we should check if the "thrashing horribly" is really
> a "recently" or if it has always happened before with 2.6.18 and previous.

I would bet that "thrashing" isn't what he meant.  He almost certainly 
meant "needless I/O" and nothing to do with swapping.  I've seen this 
similar report before.  This report is almost always gets answered with 
a "set your swappiness to an appropriate value" type answer.  Or a "your 
userspace app needs to get smarter" type answer.  I think they are 
trying to do the latter, but need some help from the kernel, and that's 
what they're trying to do here.

-- 
Jeffrey Hundstad

