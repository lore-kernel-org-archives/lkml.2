Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2ATRIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:08:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51025 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2ATRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:08:17 -0500
Date: Fri, 20 Jan 2012 09:08:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] cgroup: make sure memcg margin is 0 when over limit
Message-ID: <20120120170810.GB3086@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1327071436-20763-1-git-send-email-glommer@parallels.com>
 <1327071436-20763-3-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327071436-20763-3-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 06:57:15PM +0400, Glauber Costa wrote:
> For the memcg sock code, we'll need to register allocations
> that are temporarily over limit. Let's make sure that margin
> is 0 in this case.
> 
> I am keeping this as a separate patch, so that if any weirdness
> interaction appears in the future, we can now exactly what caused
> it.
> 
> Suggested by Johannes Weiner 
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Tejun Heo <tj@kernel.org>
> CC: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
