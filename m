Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2KROZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:25:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2KROZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:25:40 -0500
Date: Sun, 18 Nov 2012 06:25:34 -0800
From: Tejun Heo <tj@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com,
        ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch,
        lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy
 support
Message-ID: <20121118142534.GF7306@mtj.dyndns.org>
References: <1353123062-23193-1-git-send-email-tj@kernel.org>
 <20121117.220421.1904738911212014470.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121117.220421.1904738911212014470.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Nov 17, 2012 at 10:04:21PM -0500, David Miller wrote:
> > This patchset implements proper hierarchy support for netcls_cgroup.
> > Pretty simliar to the netprio one[3].  Simpler as each cgroup has
> > single config value instead of array of them.
> > 
> > This patchset contains the following three patches.
> > 
> >  0001-netcls_cgroup-introduce-netcls_mutex.patch
> >  0002-netcls_cgroup-introduce-cgroup_cls_state-is_local.patch
> >  0003-netcls_cgroup-implement-proper-hierarchy-support.patch
> > 
> > This patchset is on top of
> 
> I guess you therefore want to put it through your cgroup tree?

Yeap.

> Acked-by: David S. Miller <davem@davemloft.net>

Great, I forgot to cc you on netprio_cgroup changes.  It's similar to
this one but larger partly because the configuration is per
cgroup-netdev pair.  Would it be okay to route the following through
the cgroup tree?

  https://lkml.org/lkml/2012/11/16/514

Thanks.

-- 
tejun
