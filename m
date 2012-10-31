Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab2JaTdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:33:35 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39035 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2JaTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:33:33 -0400
Date: Wed, 31 Oct 2012 12:33:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
Message-ID: <20121031193329.GQ2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-3-git-send-email-tj@kernel.org>
 <20121031153926.GC22809@dhcp22.suse.cz>
 <20121031165739.GE2945@htj.dyndns.org>
 <20121031191602.GB1271@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031191602.GB1271@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 08:16:02PM +0100, Michal Hocko wrote:
> Sure, it cannot detect races but this wasn't the intention of the check.
> The more important part is that memcg can outlive css and we want to
> catch bugs when we try to charge to an already dead memcg.

cgroup will provide mechanisms to perform such checks properly
synchronized, so let's not leak internals like CSS rercnt going
negative outside cgroup.c.

Thanks.

-- 
tejun
