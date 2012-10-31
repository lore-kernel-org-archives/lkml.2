Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2JaRQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:16:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45904 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2JaRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:16:49 -0400
Date: Wed, 31 Oct 2012 10:16:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] cgroup: remove CGRP_WAIT_ON_RMDIR,
 cgroup_exclude_rmdir() and cgroup_release_and_wakeup_rmdir()
Message-ID: <20121031171644.GG2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-6-git-send-email-tj@kernel.org>
 <20121031162735.GF22809@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031162735.GF22809@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:27:35PM +0100, Michal Hocko wrote:
> > ---
> >  include/linux/cgroup.h | 21 ---------------------
> >  kernel/cgroup.c        | 51 --------------------------------------------------
> >  mm/memcontrol.c        | 24 +-----------------------
> >  3 files changed, 1 insertion(+), 95 deletions(-)
> 
> /me likes this

Amen, Michal.  The amount of code deleted isn't much but it was one
ugly thing.  The comment in memcg around the use of exclude_rmdir was
very depressing.

Thanks.

-- 
tejun
