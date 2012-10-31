Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423236Ab2JaQfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:35:25 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45558 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab2JaQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:35:23 -0400
Date: Wed, 31 Oct 2012 09:35:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Message-ID: <20121031163518.GB2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <20121031163134.GH22809@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031163134.GH22809@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:31:34PM +0100, Michal Hocko wrote:
> Thanks for this cleanup. The code looks much better now and:
> $ git diff --stat mmotm...tj-cgroups/review-cgroup-rmdir-updates
>  block/blk-cgroup.c     |    3 +-
>  include/linux/cgroup.h |   41 +-------
>  kernel/cgroup.c        |  256 ++++++++++++------------------------------------
>  mm/hugetlb_cgroup.c    |   11 +--
>  mm/memcontrol.c        |   51 ++--------
>  5 files changed, 75 insertions(+), 287 deletions(-)
> 
> speaks for itself.

Oh, yeah, I've been wanting to do this for so long.  :)

Thanks.

-- 
tejun
