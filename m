Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1HEORH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:17:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab1HEORD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:17:03 -0400
Message-ID: <4E3BFB3D.1050405@redhat.com>
Date: Fri, 05 Aug 2011 10:16:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Johannes Weiner <jweiner@redhat.com>
CC: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] mm: page_alloc: increase __GFP_BITS_SHIFT to include
 __GFP_OTHER_NODE
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com> <1311625159-13771-2-git-send-email-jweiner@redhat.com>
In-Reply-To: <1311625159-13771-2-git-send-email-jweiner@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 04:19 PM, Johannes Weiner wrote:
> From: Johannes Weiner<hannes@cmpxchg.org>
>
> __GFP_OTHER_NODE is used for NUMA allocations on behalf of other
> nodes.  It's supposed to be passed through from the page allocator to
> zone_statistics(), but it never gets there as gfp_allowed_mask is not
> wide enough and masks out the flag early in the allocation path.
>
> The result is an accounting glitch where successful NUMA allocations
> by-agent are not properly attributed as local.
>
> Increase __GFP_BITS_SHIFT so that it includes __GFP_OTHER_NODE.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
