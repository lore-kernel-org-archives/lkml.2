Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2JaQbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:31:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2JaQbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:31:35 -0400
Date: Wed, 31 Oct 2012 17:31:34 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Message-ID: <20121031163134.GH22809@dhcp22.suse.cz>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351657365-25055-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for this cleanup. The code looks much better now and:
$ git diff --stat mmotm...tj-cgroups/review-cgroup-rmdir-updates
 block/blk-cgroup.c     |    3 +-
 include/linux/cgroup.h |   41 +-------
 kernel/cgroup.c        |  256 ++++++++++++------------------------------------
 mm/hugetlb_cgroup.c    |   11 +--
 mm/memcontrol.c        |   51 ++--------
 5 files changed, 75 insertions(+), 287 deletions(-)

speaks for itself.
-- 
Michal Hocko
SUSE Labs
