Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2IXINW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:13:22 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44801 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab2IXINV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:13:21 -0400
Message-ID: <50601551.7070705@parallels.com>
Date: Mon, 24 Sep 2012 12:09:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-5-git-send-email-glommer@parallels.com> <20120921163404.GC7264@google.com>
In-Reply-To: <20120921163404.GC7264@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +
>> +#ifdef CONFIG_MEMCG_KMEM
>> +		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
>> +					   kmem_cgroup_files));
>> +#endif
>> +
> 
> Why not just make it part of mem_cgroup_files[]?
> 
> Thanks.
> 

Done.


