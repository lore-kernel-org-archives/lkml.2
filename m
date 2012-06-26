Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab2FZOnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:43:31 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37736 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab2FZOna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:43:30 -0400
Message-ID: <4FE9C9ED.5070907@parallels.com>
Date: Tue, 26 Jun 2012 18:40:45 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <20120625161720.ae13ae90.akpm@linux-foundation.org>
In-Reply-To: <20120625161720.ae13ae90.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 03:17 AM, Andrew Morton wrote:
>>   }
>> >+
>> >+#define mem_cgroup_kmem_on 0
>> >+#define __mem_cgroup_new_kmem_page(a, b, c) false
>> >+#define __mem_cgroup_free_kmem_page(a,b )
>> >+#define __mem_cgroup_commit_kmem_page(a, b, c)
> I suggest that the naming consistently follow the model
> "mem_cgroup_kmem_foo".  So "mem_cgroup_kmem_" becomes the well-known
> identifier for this subsystem.
>
> Then, s/mem_cgroup/memcg/g/ - show us some mercy here!
>
I always prefer shorter names, but mem_cgroup, and not memcg, seems to 
be the default for external functions.

I am nothing but a follower =)

