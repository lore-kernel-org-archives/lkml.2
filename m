Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab2GIEkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 00:40:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57383 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2GIEkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 00:40:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA6023.4060806@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 13:37:55 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: replace inexistence move_lock_page_cgroup()
 by move_lock_mem_cgroup() in comment
References: <a> <1341469733-12104-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1341469733-12104-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 15:28), Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>   mm/memcontrol.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3d318f6..63e36e7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1899,7 +1899,7 @@ again:
>   		return;
>   	/*
>   	 * If this memory cgroup is not under account moving, we don't
> -	 * need to take move_lock_page_cgroup(). Because we already hold
> +	 * need to take move_lock_mem_cgroup(). Because we already hold
>   	 * rcu_read_lock(), any calls to move_account will be delayed until
>   	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
>   	 */
> @@ -1921,7 +1921,7 @@ void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
>   	/*
>   	 * It's guaranteed that pc->mem_cgroup never changes while
>   	 * lock is held because a routine modifies pc->mem_cgroup
> -	 * should take move_lock_page_cgroup().
> +	 * should take move_lock_mem_cgroup().
>   	 */
>   	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
>   }
> 



