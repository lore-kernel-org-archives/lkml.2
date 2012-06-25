Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2FYJno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:43:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2FYJnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:43:43 -0400
Date: Mon, 25 Jun 2012 11:43:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 2/4] memcg: change mem_control_xxx to mem_cgroup_xxx
Message-ID: <20120625094341.GE19805@tiehlicka.suse.cz>
References: <1340613848-9536-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340613848-9536-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-06-12 16:44:08, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Unify memcg functions to mem_cgroup_xxx.
> 
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks
> ---
>  mm/memcontrol.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ccda728..2e81328 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>  #endif
>  
>  #ifdef CONFIG_NUMA
> -static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
> +static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>  				      struct seq_file *m)
>  {
>  	int nid;
> @@ -4058,7 +4058,7 @@ static inline void mem_cgroup_lru_names_not_uptodate(void)
>  	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
>  }
>  
> -static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
> +static int mem_cgroup_stat_show(struct cgroup *cont, struct cftype *cft,
>  				 struct seq_file *m)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> @@ -4572,7 +4572,7 @@ static struct cftype mem_cgroup_files[] = {
>  	},
>  	{
>  		.name = "stat",
> -		.read_seq_string = mem_control_stat_show,
> +		.read_seq_string = mem_cgroup_stat_show,
>  	},
>  	{
>  		.name = "force_empty",
> @@ -4604,7 +4604,7 @@ static struct cftype mem_cgroup_files[] = {
>  #ifdef CONFIG_NUMA
>  	{
>  		.name = "numa_stat",
> -		.read_seq_string = mem_control_numa_stat_show,
> +		.read_seq_string = mem_cgroup_numa_stat_show,
>  	},
>  #endif
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
