Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2F3DsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:48:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44949 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2F3DsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:48:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEE7665.6020409@jp.fujitsu.com>
Date: Sat, 30 Jun 2012 12:45:41 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Zhouping Liu <zliu@redhat.com>, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com> <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com> <20120627154827.GA4420@tiehlicka.suse.cz> <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com> <20120627200926.GR15811@google.com> <alpine.DEB.2.00.1206271316070.22162@chino.kir.corp.google.com> <20120627202430.GS15811@google.com> <4FEBD7C0.7090906@jp.fujitsu.com> <20120628183145.GE22641@google.com>
In-Reply-To: <20120628183145.GE22641@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/29 3:31), Tejun Heo wrote:
> Hello, KAME.
>
> On Thu, Jun 28, 2012 at 01:04:16PM +0900, Kamezawa Hiroyuki wrote:
>>> I still wish it's folded into CONFIG_MEMCG and conditionalized just on
>>> CONFIG_SWAP tho.
>>>
>>
>> In old days, memsw controller was not very stable. So, we devided the config.
>> And, it makes size of memory for swap-device double (adds 2bytes per swapent.)
>> That is the problem.
>
> I see.  Do you think it's now reasonable to drop the separate config
> option?  Having memcg enabled but swap unaccounted sounds half-broken
> to me.
>

Hmm. Maybe it's ok if we can keep boot option. I'll cook a patch in the next week.

Thanks,
-Kame

