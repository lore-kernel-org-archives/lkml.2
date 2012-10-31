Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935827Ab2JaQbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:31:49 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33279 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2JaQbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:31:46 -0400
Date: Wed, 31 Oct 2012 12:31:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 2/6] memcg: root_cgroup cannot reach
 mem_cgroup_move_parent
Message-ID: <20121031163141.GC2305@cmpxchg.org>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
 <1351251453-6140-3-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351251453-6140-3-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:37:29PM +0200, Michal Hocko wrote:
> The root cgroup cannot be destroyed so we never hit it down the
> mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
> even try to do anything if called for the root.
> 
> This means that mem_cgroup_move_parent doesn't have to bother with the
> root cgroup and it can assume it can always move charges upwards.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
