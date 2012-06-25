Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2FYKly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:41:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46620 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2FYKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:41:53 -0400
Date: Mon, 25 Jun 2012 18:41:43 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v3 4/4] memcg: cleanup all typo in memory cgroup
Message-ID: <20120625104143.GA12148@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340613910-9629-1-git-send-email-liwp.linux@gmail.com>
 <4FE83BE9.7050701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE83BE9.7050701@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 07:22:33PM +0900, Kamezawa Hiroyuki wrote:
>(2012/06/25 17:45), Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>
>my thunderbird's spell checker founds some more ;)
>
>> ---
>>   mm/memcontrol.c |   21 ++++++++++-----------
>>   1 file changed, 10 insertions(+), 11 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4520b57..d474bf6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -115,8 +115,8 @@ static const char * const mem_cgroup_events_names[] = {
>>   
>>   /*
>>    * Per memcg event counter is incremented at every pagein/pageout. With THP,
>> - * it will be incremated by the number of pages. This counter is used for
>> - * for trigger some periodic events. This is straightforward and better
>> + * it will be incremented by the number of pages. This counter is used to
>> + * trigger some periodic events. This is straightforward and better
>>    * than using jiffies etc. to handle periodic memcg event.
>>    */
>>   enum mem_cgroup_events_target {
>> @@ -667,7 +667,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>>    * Both of vmstat[] and percpu_counter has threshold and do periodic
>>    * synchronization to implement "quick" read. There are trade-off between
>>    * reading cost and precision of value. Then, we may have a chance to implement
>> - * a periodic synchronizion of counter in memcg's counter.
>> + * a periodic synchronization of counter in memcg's counter.
>>    *
>>    * But this _read() function is used for user interface now. The user accounts
>>    * memory usage by memory cgroup and he _always_ requires exact value because
>> @@ -677,7 +677,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>>    *
>>    * If there are kernel internal actions which can make use of some not-exact
>>    * value, and reading all cpu value can be performance bottleneck in some
>> - * common workload, threashold and synchonization as vmstat[] should be
>> + * common workload, threshold and synchonization as vmstat[] should be
>
>synchronization
>
>>    * implemented.
>>    */
>>   static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
>> @@ -1304,7 +1304,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>>    *
>>    * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
>>    *			  under hierarchy of moving cgroups. This is for
>> - *			  waiting at hith-memory prressure caused by "move".
>> + *			  waiting at hit-memory pressure caused by "move".
>>    */
>>   
>>   static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
>> @@ -1597,7 +1597,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>>   /*
>>    * Check all nodes whether it contains reclaimable pages or not.
>>    * For quick scan, we make use of scan_nodes. This will allow us to skip
>> - * unused nodes. But scan_nodes is lazily updated and may not cotain
>> + * unused nodes. But scan_nodes is lazily updated and may not contain
>>    * enough new information. We need to do double check.
>>    */
>>   static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
>> @@ -2211,7 +2211,6 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>   	if (mem_cgroup_wait_acct_move(mem_over_limit))
>>   		return CHARGE_RETRY;
>>   
>> -	/* If we don't need to call oom-killer at el, return immediately */
>>   	if (!oom_check)
>>   		return CHARGE_NOMEM;
>>   	/* check OOM */
>> @@ -2289,7 +2288,7 @@ again:
>>   		 * In that case, "memcg" can point to root or p can be NULL with
>>   		 * race with swapoff. Then, we have small risk of mis-accouning.
>accounting 
>
>Could you update ?
>
>Thanks,
>-Kame
>
>(*) In my experience, too rapid update doesn't work well, maintainers cannot review it.

Thank you Kame. Now I will drop disputed patch, if it really need,
anyone can tell me fix it and resend.

Regards,
Wanpeng Li 
