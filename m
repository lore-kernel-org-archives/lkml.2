Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2K3KXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:23:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2K3KXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:23:20 -0500
Date: Fri, 30 Nov 2012 11:23:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 5/6] memcg: further simplify mem_cgroup_iter
Message-ID: <20121130102318.GG29317@dhcp22.suse.cz>
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz>
 <1353955671-14385-6-git-send-email-mhocko@suse.cz>
 <50B87793.7000104@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B87793.7000104@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 13:08:35, Glauber Costa wrote:
> On 11/26/2012 10:47 PM, Michal Hocko wrote:
> > The code would be much more easier to follow if we move the iteration
> > outside of the function (to __mem_cgrou_iter_next) so the distinction
> > is more clear.
> totally nit: Why is it call __mem_cgrou ?
> 
> What happened to your p ?

It was a fight against p as a source of all evil but the fight is over
and we can put it back :p 

Thanks for noticing
-- 
Michal Hocko
SUSE Labs
