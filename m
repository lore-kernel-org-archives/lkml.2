Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab2INRBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:01:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48182 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2INRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:01:52 -0400
Date: Fri, 14 Sep 2012 10:01:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH] cgroup: fix invalid rcu dereference
Message-ID: <20120914170147.GB17747@google.com>
References: <5052F78A.7010007@suse.cz>
 <1347615612-11450-1-git-send-email-jslaby@suse.cz>
 <20120914132738.GN19694@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914132738.GN19694@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:27:38AM -0400, Aristeu Rozanski wrote:
> On Fri, Sep 14, 2012 at 11:40:12AM +0200, Jiri Slaby wrote:
> > Commit "device_cgroup: convert device_cgroup internally to policy +
> > exceptions" removed rcu locks which are needed in task_devcgroup
> > called in this chain: devcgroup_inode_mknod OR
> > __devcgroup_inode_permission -> __devcgroup_inode_permission ->
> > task_devcgroup -> task_subsys_state -> task_subsys_state_check.
> 
> ugh, missed that
> 
...
> thanks Jiri
> Acked-by: Aristeu Rozanski <aris@redhat.com>

How should this be routed?

Thanks.

-- 
tejun
