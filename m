Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2F0ANG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:13:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61703 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2F0AMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:12:49 -0400
Date: Wed, 27 Jun 2012 08:12:33 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v4 2/2] memcg: change mem_control_xxx to mem_cgroup_xxx
Message-ID: <20120627001233.GA2289@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340622959-13136-1-git-send-email-liwp.linux@gmail.com>
 <20120626125437.26050bb0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626125437.26050bb0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 12:54:37PM -0700, Andrew Morton wrote:
>On Mon, 25 Jun 2012 19:15:59 +0800
>Wanpeng Li <liwp.linux@gmail.com> wrote:
>
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Unify memcg functions to mem_cgroup_xxx.
>
>How about we unify memcg functions to memcg_xxx?

OK, I will resend the patch. Thank you!

Regards,
Wanpeng Li 

>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3999,7 +3999,7 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
>>  #endif
>>  
>>  #ifdef CONFIG_NUMA
>> -static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>> +static int mem_cgroup_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>>  				      struct seq_file *m)
>
>memcg_numa_stat_show(), etc.
>
>
