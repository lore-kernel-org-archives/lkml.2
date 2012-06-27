Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2F0JDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:03:01 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38761 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab2F0JC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:02:59 -0400
Message-ID: <4FEACBA4.10202@parallels.com>
Date: Wed, 27 Jun 2012 13:00:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Wanpeng Li <liwp.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
References: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com> <4FEAC7C6.7030601@parallels.com> <20120627085917.GA5683@tiehlicka.suse.cz>
In-Reply-To: <20120627085917.GA5683@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 12:59 PM, Michal Hocko wrote:
> On Wed 27-06-12 12:43:50, Glauber Costa wrote:
>> On 06/27/2012 04:16 AM, Wanpeng Li wrote:
>>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>>>
>>> Changelog:
>>>
>>> V2 -> V1:
>>>
>>> * replace memory_cgroup_xxx by memcg_xxx
>>>
>>> Unify memcg functions to memcg_xxx.
>>
>>
>> This patch achieves nothing.
>> You're changing a couple of function names. Andrew stated goal was
>> to change *all* function names from mem_cgroup_xxx to memcg_xxx, not
>> just one or two.
>
> No mass things now, please.
> git grep mem_cgroup_ mm/ include/ | wc -l
> 863
>
> This will be real pain for merging.
>
It's either that, or I have my new functions named memcg_ and we live 
with the inconsistency.

Point is, changing one function name as he did, achieves nothing.


