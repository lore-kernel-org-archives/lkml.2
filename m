Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2FZTyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:54:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2FZTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:54:39 -0400
Date: Tue, 26 Jun 2012 12:54:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v4 2/2] memcg: change mem_control_xxx to mem_cgroup_xxx
Message-Id: <20120626125437.26050bb0.akpm@linux-foundation.org>
In-Reply-To: <1340622959-13136-1-git-send-email-liwp.linux@gmail.com>
References: <1340622959-13136-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012 19:15:59 +0800
Wanpeng Li <liwp.linux@gmail.com> wrote:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Unify memcg functions to mem_cgroup_xxx.

How about we unify memcg functions to memcg_xxx?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>  #endif
>  
>  #ifdef CONFIG_NUMA
> -static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
> +static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>  				      struct seq_file *m)

memcg_numa_stat_show(), etc.


