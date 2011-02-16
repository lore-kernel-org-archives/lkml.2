Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab1BPMM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:12:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab1BPMMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:12:23 -0500
Message-ID: <4D5BBF88.6030103@redhat.com>
Date: Wed, 16 Feb 2011 07:14:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Kent Overstreet <kent.overstreet@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: Stop reclaim/compaction earlier due to	insufficient
 progress if !__GFP_REPEAT
References: <20110209154606.GJ27110@cmpxchg.org> <20110209164656.GA1063@csn.ul.ie> <20110209182846.GN3347@random.random> <20110210102109.GB17873@csn.ul.ie> <20110210124838.GU3347@random.random> <20110210133323.GH17873@csn.ul.ie> <20110210141447.GW3347@random.random> <20110210145813.GK17873@csn.ul.ie> <20110216095048.GA4473@csn.ul.ie>
In-Reply-To: <20110216095048.GA4473@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 04:50 AM, Mel Gorman wrote:

> This patch will stop reclaim/compaction if no pages were reclaimed in the
> last SWAP_CLUSTER_MAX pages that were considered. For allocations such as
> hugetlbfs that use GFP_REPEAT and have fewer fallback options, the full LRU
> list may still be scanned.

> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>
