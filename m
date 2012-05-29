Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2E2QCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:02:40 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44061 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab2E2QCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:02:39 -0400
Message-ID: <4FC4F297.4080202@parallels.com>
Date: Tue, 29 May 2012 20:00:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge infrastructure
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290944040.4666@router.home>
In-Reply-To: <alpine.DEB.2.00.1205290944040.4666@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 06:47 PM, Christoph Lameter wrote:
> On Fri, 25 May 2012, Glauber Costa wrote:
>
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -696,7 +696,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
>>   	  then swapaccount=0 does the trick).
>>   config CGROUP_MEM_RES_CTLR_KMEM
>>   	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
>> -	depends on CGROUP_MEM_RES_CTLR&&  EXPERIMENTAL
>> +	depends on CGROUP_MEM_RES_CTLR&&  EXPERIMENTAL&&  !SLOB
>>   	default n
>
> Ok so SLOB is not supported at all.
>
Yes, at least I see no reason to.

