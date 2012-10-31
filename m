Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011Ab2JaVXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:23:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54413 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965470Ab2JaVXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:23:45 -0400
Date: Wed, 31 Oct 2012 22:23:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: kill
 cgroup_subsys->__DEPRECATED_clear_css_refs
Message-ID: <20121031212342.GA5286@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
 <1351712650-23709-2-git-send-email-tj@kernel.org>
 <20121031201227.GF1271@dhcp22.suse.cz>
 <CAOS58YOHjLyKFeah+h+qOrAWvfi1O5eL7m-AMbqAdcP=EOFb6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOHjLyKFeah+h+qOrAWvfi1O5eL7m-AMbqAdcP=EOFb6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-10-12 13:14:07, Tejun Heo wrote:
> Hey, Michal.
> 
> On Wed, Oct 31, 2012 at 1:12 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > And sorry for being to annoying about this WARN_ON_ONCE but I really
> > don't see any reason for it. pre_destroy can still happen and now it is
> > even reduced to a reasonable condition (somebody shown up). So I would
> > put it out of way as it doesn't give us anything and as I've already
> > mentioned one can trigger it really easily.
> 
> It was there before and goes away in several commits.  I have to
> explain all that to remove it in this patch.  Why do that when the
> whole thing is just gonna disappear anyway?

I would consider it nicer but if you feel it is not worth it then don't
worry. It is not a big deal. The important part is that we do not ignore
the return value now.

Thanks
-- 
Michal Hocko
SUSE Labs
