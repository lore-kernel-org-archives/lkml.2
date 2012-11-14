Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423177Ab2KNTB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:01:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55206 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422625Ab2KNTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:01:57 -0500
Date: Wed, 14 Nov 2012 11:01:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.cz
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
Message-ID: <20121114190152.GH21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-6-git-send-email-tj@kernel.org>
 <50A37B0A.7010608@parallels.com>
 <20121114185504.GG21185@mtj.dyndns.org>
 <50A45ABB.3040507@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A45ABB.3040507@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Nov 15, 2012 at 07:00:11AM +0400, Glauber Costa wrote:
> > Ooh, yeah, hmmm... that should happen after this series gets merged.
> > I'll mark it as pending.
> > 
> Btw: I did this because there is no other facility to figure out a
> memcg's "name".
> 
> I wonder if there is anyone else using this, so we could just abstract
> that in cgroup.c?

We have cgroup_path() after all, so I don't think it's crazy to have
cgroup_name().  Please feel free to add.

Thanks.

-- 
tejun
