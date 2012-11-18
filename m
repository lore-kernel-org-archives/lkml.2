Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2KRDEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 22:04:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2KRDEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 22:04:24 -0500
Date: Sat, 17 Nov 2012 22:04:21 -0500 (EST)
Message-Id: <20121117.220421.1904738911212014470.davem@davemloft.net>
To: tj@kernel.org
Cc: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch,
        lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353123062-23193-1-git-send-email-tj@kernel.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 16 Nov 2012 19:30:59 -0800

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

I guess you therefore want to put it through your cgroup tree?

If so:

Acked-by: David S. Miller <davem@davemloft.net>
