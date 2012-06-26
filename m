Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2FZF1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:27:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43142 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2FZF12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:27:28 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE947C0.6040304@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 14:25:20 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwp.linux@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 1/2] memcg: cleanup useless LRU_ALL_EVICTABLE
References: <1340622934-13091-1-git-send-email-liwp.linux@gmail.com>
In-Reply-To: <1340622934-13091-1-git-send-email-liwp.linux@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/25 20:15), Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since LRU_ALL_EVICTABLE is useless, just remove it.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

Thank you for your patience.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

hmm..but this may noe be related to memcg ;)


> ---
>   include/linux/mmzone.h |    1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 68c569f..8b10c35 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -209,7 +209,6 @@ struct lruvec {
>   /* Mask used at gathering information at once (see memcontrol.c) */
>   #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
>   #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
> -#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
>   #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
>   
>   /* Isolate clean file */
> 



