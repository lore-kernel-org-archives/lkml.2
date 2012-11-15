Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423549Ab2KOCNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:13:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58095 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2KOCNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:13:17 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A44FA0.5010305@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 11:12:48 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Ying Han <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC] rework mem_cgroup iterator
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz> <50A2F9FC.5050303@huawei.com>
In-Reply-To: <50A2F9FC.5050303@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/14 10:55), Li Zefan wrote:
> On 2012/11/13 23:30, Michal Hocko wrote:
>> Hi all,
>> this patch set tries to make mem_cgroup_iter saner in the way how it
>> walks hierarchies. css->id based traversal is far from being ideal as it
>> is not deterministic because it depends on the creation ordering.
>>
>> Diffstat looks promising but it is fair the say that the biggest cleanup is
>> just css_get_next removal. The memcg code has grown a bit but I think it is
>> worth the resulting outcome (the sanity ;)).
>>
> 
> So memcg won't use css id at all, right? Then we can remove the whole css_id
> stuff, and that's quite a bunch of code.
> 
It's used by swap information recording for saving spaces.

Thanks,
-Kame


