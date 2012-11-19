Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2KSPIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:08:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32864 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2KSPID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:08:03 -0500
Date: Mon, 19 Nov 2012 10:07:19 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, tgraf@suug.ch, davem@davemloft.net,
        lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Message-ID: <20121119150719.GB16685@hmsreliant.think-freely.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123062-23193-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:30:59PM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> This patchset implements proper hierarchy support for netcls_cgroup.
> Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> single config value instead of array of them.
> 
> This patchset contains the following three patches.
> 
>  0001-netcls_cgroup-introduce-netcls_mutex.patch
>  0002-netcls_cgroup-introduce-cgroup_cls_state-is_local.patch
>  0003-netcls_cgroup-implement-proper-hierarchy-support.patch
> 
> This patchset is on top of
> 
> cgroup/for-3.8 ef9fe980c6 ("cgroup_freezer: implement proper hierarchy support")
> + [1] "[PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail"
> + [2] "[PATCH 1/2] cgroup: s/CGRP_CLONE_CHILDREN/CGRP_CPUSET_CLONE_CHILDREN/"
>       "[PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()"
> + [3] "[PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy support"
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-netcls_cgroup-hierarchy
> 
> diffstat follows.
> 
>  include/net/cls_cgroup.h |    1
>  net/sched/cls_cgroup.c   |  102 ++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 88 insertions(+), 15 deletions(-)
> 
> Thanks.
> 
> --
> tejun
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5047
> [2] http://thread.gmane.org/gmane.linux.kernel/1393151
> [3] https://lkml.org/lkml/2012/11/16/514
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>

