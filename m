Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2LCQDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:03:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2LCQDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:03:12 -0500
Date: Mon, 3 Dec 2012 17:03:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuset: implement cgroup_rightmost_descendant()
Message-ID: <20121203160310.GD17093@dhcp22.suse.cz>
References: <1354141621-11906-1-git-send-email-tj@kernel.org>
 <1354141621-11906-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354141621-11906-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-11-12 14:26:59, Tejun Heo wrote:
> Implement cgroup_rightmost_descendant() which returns the right most
> descendant of the specified cgroup.  This can be used to skip the
> cgroup's subtree while iterating with
> cgroup_for_each_descendant_pre().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.cz>

Acked-by: Michal Hocko <mhocko@suse.cz>

Just a nit bellow

[...]
> +/**
> + * cgroup_rightmost_descendant - return the rightmost descendant of a cgroup
> + * @cgrp: cgroup of interest
> + *
> + * Return the rightmost descendant of @cgrp.  If there's no descendant,
> + * @cgrp is returned.  This can be used during pre-order traversal to skip
> + * subtree of @cgrp.
> + */

s/cgrp/pos/

> +struct cgroup *cgroup_rightmost_descendant(struct cgroup *pos)
[...]

Thanks
-- 
Michal Hocko
SUSE Labs
