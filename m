Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761079Ab2J2X0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:26:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42835 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab2J2X0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:26:15 -0400
Date: Mon, 29 Oct 2012 16:26:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: memcg/cgroup: do not fail fail on pre_destroy callbacks
Message-ID: <20121029232602.GF4066@htj.dyndns.org>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

> Tejun is planning to build on top of that and make some more cleanups
> in the cgroup core (namely get rid of of the whole retry code in
> cgroup_rmdir).

I applied 1-3 to the following branch which is based on top of v3.6.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-destroy-updates

I'll follow up with updates to the destroy path which will replace #4.
#5 and #6 should be stackable on top.  So, Andrew, there's likely be a
conflict in the near future.  Just dropping #4-#6 till Michal and I
sort it out should be enough.

Thanks.

-- 
tejun
