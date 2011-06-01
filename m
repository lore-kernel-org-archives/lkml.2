Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab1FAPbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914Ab1FAPbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:31:20 -0400
Message-ID: <4DE65B3A.9070706@redhat.com>
Date: Wed, 01 Jun 2011 11:31:06 -0400
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
Subject: Re: [PATCH v2 02/10] compaction: trivial clean up acct_isolated
References: <cover.1306689214.git.minchan.kim@gmail.com> <d2a446699fd72bf439b0e538f798e3d600314d92.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <d2a446699fd72bf439b0e538f798e3d600314d92.1306689214.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2011 02:13 PM, Minchan Kim wrote:
> acct_isolated of compaction uses page_lru_base_type which returns only
> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
> In addtion, cc->nr_[anon|file] is used in only acct_isolated so it doesn't have
> fields in conpact_control.
> This patch removes fields from compact_control and makes clear function of
> acct_issolated which counts the number of anon|file pages isolated.
>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>
