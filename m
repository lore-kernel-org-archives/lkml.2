Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab1FAQDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab1FAQDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:03:22 -0400
Message-ID: <4DE662BF.3000309@redhat.com>
Date: Wed, 01 Jun 2011 12:03:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 05/10] compaction: make isolate_lru_page with filter
 aware
References: <cover.1306689214.git.minchan.kim@gmail.com> <4feb21bdac4c00a30f3c0d9361bd3565e6afa72f.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <4feb21bdac4c00a30f3c0d9361bd3565e6afa72f.1306689214.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2011 02:13 PM, Minchan Kim wrote:
> In async mode, compaction doesn't migrate dirty or writeback pages.
> So, it's meaningless to pick the page and re-add it to lru list.
>
> Of course, when we isolate the page in compaction, the page might
> be dirty or writeback but when we try to migrate the page, the page
> would be not dirty, writeback. So it could be migrated. But it's
> very unlikely as isolate and migration cycle is much faster than
> writeout.
>
> So, this patch helps cpu and prevent unnecessary LRU churning.
>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Johannes Weiner<hannes@cmpxchg.org>
> Acked-by: Mel Gorman<mgorman@suse.de>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

ACked-by: Rik van Riel <riel@redhat.com>
