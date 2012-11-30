Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2K3JuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:50:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2K3JuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:50:02 -0500
Date: Fri, 30 Nov 2012 10:49:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com, paul@paulmenage.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, bsingharora@gmail.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
 cgroup core
Message-ID: <20121130094959.GE29317@dhcp22.suse.cz>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
 <50B8263C.7060908@jp.fujitsu.com>
 <50B875B4.2020507@parallels.com>
 <20121130092435.GD29317@dhcp22.suse.cz>
 <50B87F84.7040206@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B87F84.7040206@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 13:42:28, Glauber Costa wrote:
[...]
> Speaking of it: Tejun's tree still lacks the kmem bits. How hard would
> it be for you to merge his branch into a temporary branch of your tree?

review-cpuset-locking is based on a post merge window merges so I cannot
merge it as is. I could cherry-pick the series after it is settled. I
have no idea how much conflicts this would bring, though.
-- 
Michal Hocko
SUSE Labs
