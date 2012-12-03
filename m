Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2LCP4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:56:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2LCPz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:55:59 -0500
Date: Mon, 3 Dec 2012 16:55:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: drop cpuset->stack_list and
 ->parent
Message-ID: <20121203155556.GC17093@dhcp22.suse.cz>
References: <1354141621-11906-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354141621-11906-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-11-12 14:26:58, Tejun Heo wrote:
[...]
> 0001 implements cgroup_rightmost_descendant() which can be used to
> skip subtree during pre-order tree walk.  Michal, maybe memcg can use
> it too?

I like this but I do not see any immediate use for it because we do not
have any generic conditions when the whole subtree might be skipped at
the moment.
Maybe it will turn out being useful for the soft limit reclaim but I
haven't thought about it more.
[...]
-- 
Michal Hocko
SUSE Labs
