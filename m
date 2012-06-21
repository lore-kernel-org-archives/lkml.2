Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2FULlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:41:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44516 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab2FULle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:41:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE307E2.3010803@jp.fujitsu.com>
Date: Thu, 21 Jun 2012 20:39:14 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        cgroups@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v4 05/25] memcg: Always free struct memcg through schedule_work()
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-6-git-send-email-glommer@parallels.com> <4FDF1A0D.6080204@jp.fujitsu.com> <4FDF1AAE.4080209@parallels.com> <alpine.LFD.2.02.1206201031150.2989@tux.localdomain> <4FE18C6B.1020503@parallels.com>
In-Reply-To: <4FE18C6B.1020503@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/20 17:40), Glauber Costa wrote:
> On 06/20/2012 11:32 AM, Pekka Enberg wrote:
>>> >Maybe Pekka can merge the current -mm with his tree?
>> I first want to have a stable base from Christoph's "common slab" series
>> before I am comfortable with going forward with the memcg parts.
>>
>> Feel free to push forward any preparational patches to the slab
>> allocators, though.
>>
>> Pekka
>
> Kame and others:
>
> If you are already comfortable with the general shape of the series, it would do me good to do the same with the memcg preparation patches, so we have less code to review and merge in the next window.
>
> They are:
>
> memcg: Make it possible to use the stock for more than one page.
> memcg: Reclaim when more than one page needed.
> memcg: change defines to an enum
>
> Do you see any value in merging them now ?
>

I'll be okay with the 3 patches for memcg.

Thanks,
-Kame

