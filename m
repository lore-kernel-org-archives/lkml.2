Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab0LHFHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:07:35 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33537 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0LHFHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:07:33 -0500
Date: Tue, 7 Dec 2010 20:46:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: Remove unnecessary return
Message-ID: <20101207151642.GK3158@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1291734580-19515-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1291734580-19515-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MinChan Kim <minchan.kim@gmail.com> [2010-12-08 00:09:40]:

> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/memcontrol.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f9435be..55f57e3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -821,7 +821,6 @@ void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
>  		return;
>  	VM_BUG_ON(list_empty(&pc->lru));
>  	list_del_init(&pc->lru);
> -	return;
>  }
> 

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Three Cheers,
	Balbir
