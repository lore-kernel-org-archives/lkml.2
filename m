Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2KNSzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:55:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43313 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2KNSzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:55:09 -0500
Date: Wed, 14 Nov 2012 10:55:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.cz
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
Message-ID: <20121114185504.GG21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
 <1352775704-9023-6-git-send-email-tj@kernel.org>
 <50A37B0A.7010608@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A37B0A.7010608@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Nov 14, 2012 at 03:05:46PM +0400, Glauber Costa wrote:
> Will memcontrol.c need similar amendments?
> 
> The code that lives in -mm and includes kmemcg includes the following
> excerpt:
> 
>         rcu_read_lock();
>         dentry = rcu_dereference(memcg->css.cgroup->dentry);
>         rcu_read_unlock();

Ooh, yeah, hmmm... that should happen after this series gets merged.
I'll mark it as pending.

Thanks.

-- 
tejun
