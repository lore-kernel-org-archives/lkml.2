Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2JPGcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:32:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56165 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2JPGcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:32:00 -0400
Message-ID: <507CFF65.7050109@gmail.com>
Date: Tue, 16 Oct 2012 14:32:05 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Sha Zhengju <handai.szj@taobao.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
References: <1350367837-27919-1-git-send-email-handai.szj@taobao.com> <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 02:12 PM, David Rientjes wrote:
> On Tue, 16 Oct 2012, Sha Zhengju wrote:
>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
>> task in out-of-memory situations, but it only works on overall system-wide oom.
>> But it's also a useful indication in memcg so we take it into consideration
>> while oom happening in memcg. Other sysctl such as panic_on_oom has already
>> been memcg-ware.
>>
> You're working on an old kernel, mem_cgroup_out_of_memory() has moved to
> mm/memcontrol.c.  Please rebase on 3.7-rc1 and send an updated patch,
> which otherwise looks good.

Thanks for reminding!  Yes, I cooked it on memcg-devel git repo but a 
out-of-date
since-3.2 branch... But I notice the latest branch is since-3.5(not 
seeing 3.6/3.7), does
it okay to working on this branch?


Thanks,
Sha
