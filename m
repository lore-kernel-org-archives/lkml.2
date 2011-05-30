Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1E3Br6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:47:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55324 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1E3Br4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:47:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE2F741.7060109@jp.fujitsu.com>
Date: Mon, 30 May 2011 10:47:45 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mgorman@suse.de, riel@redhat.com, aarcange@redhat.com,
        hannes@cmpxchg.org
Subject: Re: [PATCH v2 00/10] Prevent LRU churning
References: <cover.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Minchan Kim (10):
>   [1/10] Make clear description of isolate/putback functions
>   [2/10] compaction: trivial clean up acct_isolated
>   [3/10] Change int mode for isolate mode with enum ISOLATE_PAGE_MODE
>   [4/10] Add additional isolation mode
>   [5/10] compaction: make isolate_lru_page with filter aware
>   [6/10] vmscan: make isolate_lru_page with filter aware
>   [7/10] In order putback lru core
>   [8/10] migration: make in-order-putback aware
>   [9/10] compaction: make compaction use in-order putback
>   [10/10] add tracepoints

Minchan,

I'm sorry I have no chance to review this patch in this week. I'm getting
stuck for LinuxCon. ;)
That doesn't mean I dislike this series.

Thanks.



