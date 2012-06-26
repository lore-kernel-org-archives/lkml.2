Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2FZPEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:04:01 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36395 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab2FZPD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:03:59 -0400
Message-ID: <4FE9CEBB.80108@parallels.com>
Date: Tue, 26 Jun 2012 19:01:15 +0400
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
>> +	memcg_uncharge_kmem(memcg, size);
>> >+	mem_cgroup_put(memcg);
>> >+}
>> >+EXPORT_SYMBOL(__mem_cgroup_free_kmem_page);
>> >  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
>> >
>> >  #if defined(CONFIG_INET) && defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
>> >@@ -5645,3 +5751,69 @@ static int __init enable_swap_account(char *s)
>> >  __setup("swapaccount=", enable_swap_account);
>> >
>> >  #endif
>> >+
>> >+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> gargh.  CONFIG_MEMCG_KMEM, please!
>

Here too. I like it as much as you do.

But that is consistent with the rest of the file, and I'd rather have
it this way.


