Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2F2HTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:19:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45587 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2F2HTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:19:35 -0400
Message-ID: <4FED5661.1030102@parallels.com>
Date: Fri, 29 Jun 2012 11:16:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, Zhouping Liu <zliu@redhat.com>,
        <linux-mm@kvack.org>, Li Zefan <lizefan@huawei.com>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com> <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com> <20120627154827.GA4420@tiehlicka.suse.cz> <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com> <20120627200926.GR15811@google.com> <alpine.DEB.2.00.1206271316070.22162@chino.kir.corp.google.com> <20120627202430.GS15811@google.com> <4FEBD7C0.7090906@jp.fujitsu.com>
In-Reply-To: <4FEBD7C0.7090906@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:04 AM, Kamezawa Hiroyuki wrote:
>>
>> I still wish it's folded into CONFIG_MEMCG and conditionalized just on
>> CONFIG_SWAP tho.
>>
> 
> In old days, memsw controller was not very stable. So, we devided the
> config.
> And, it makes size of memory for swap-device double (adds 2bytes per
> swapent.)
> That is the problem.


That's the tendency to happen with anything new, since we want to add it
without disrupting what's already in there. I am not very fond of config
options explosions myself, so I am for removing it.
