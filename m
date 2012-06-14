Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2FNNoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:44:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62114 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2FNNoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:44:16 -0400
Message-ID: <4FD9EAAC.1060100@gmail.com>
Date: Thu, 14 Jun 2012 09:44:12 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] mm: complement page reclaim comment
References: <1339680158-26657-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1339680158-26657-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/14/12 9:22 AM), Wanpeng Li wrote:
> From: Wanpeng Li<liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li<liwp.linux@gmail.com>
> ---
>   mm/vmscan.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ed823df..603c96f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3203,6 +3203,7 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>    * Reasons page might not be evictable:
>    * (1) page's mapping marked unevictable
>    * (2) page is part of an mlocked VMA
> + * (3) page mapped into SHM_LOCK'd shared memory regions

This is one of "marked unevictable".


>    *
>    */
>   int page_evictable(struct page *page, struct vm_area_struct *vma)

