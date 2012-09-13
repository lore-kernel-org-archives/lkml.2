Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2IMGtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:49:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:29220 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2IMGtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:49:15 -0400
Message-ID: <505181A2.1040004@huawei.com>
Date: Thu, 13 Sep 2012 14:48:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Glauber Costa <glommer@parallels.com>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
References: <20120910223125.GC7677@google.com> <20120910223355.GD7677@google.com> <504F30DB.60808@huawei.com> <20120911170837.GM7677@google.com> <20120911174319.GO7677@google.com> <505057D8.4010908@parallels.com> <20120912163433.GL7677@google.com>
In-Reply-To: <20120912163433.GL7677@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/9/13 0:34, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 12, 2012 at 01:37:28PM +0400, Glauber Costa wrote:
>> "If a cpuset is cpu or mem exclusive, no other cpuset, other than
>> a direct ancestor or descendant, may share any of the same CPUs or
>> Memory Nodes."
>>
>> So I think it tricked me as well. I was under the impression that
>> "exclusive" would also disallow the kids.
> 
> You two are confusing me even more.  AFAICS, the hierarchical
> properties don't seem to change whether exclusive is set or not.  It
> still ensures children can't have something parent doesn't allow and
> exclusive applies to whether to share something with siblings, so I
> don't think anything is broken hierarchy-wise.  Am I missing
> something?  If so, please be explicit and elaborate where and how it's
> broken.
> 

Ignore it. I misunderstood the exclusive flag. Sorry for the noise.

