Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0KRCEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0KRCEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:04:23 -0500
Message-ID: <4CE4897F.4020107@redhat.com>
Date: Wed, 17 Nov 2010 21:03:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim during
 high-order allocations
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie> <20101117154641.51fd7ce5.akpm@linux-foundation.org>
In-Reply-To: <20101117154641.51fd7ce5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 06:46 PM, Andrew Morton wrote:
> On Wed, 17 Nov 2010 16:22:41 +0000
> Mel Gorman<mel@csn.ul.ie>  wrote:

>> I'm hoping that this series also removes the
>> necessity for the "delete lumpy reclaim" patch from the THP tree.
>
> Now I'm sad.  I read all that and was thinking "oh goody, we get to
> delete something for once".  But no :(
>
> If you can get this stuff to work nicely, why can't we remove lumpy
> reclaim?

I seem to remember there being some resistance against
removing lumpy reclaim, but I do not remember from
where or why.

IMHO some code deletion would be nice :)

-- 
All rights reversed
