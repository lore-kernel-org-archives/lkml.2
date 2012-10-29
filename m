Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934Ab2J2U6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:58:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2J2U6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:58:11 -0400
Date: Mon, 29 Oct 2012 21:58:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.linux-foundation.org
Subject: Re: [V5 PATCH 08/26] memcontrol: use N_MEMORY instead N_HIGH_MEMORY
Message-ID: <20121029205806.GB21640@dhcp22.suse.cz>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
 <1351524078-20363-7-git-send-email-laijs@cn.fujitsu.com>
 <20121029162212.GE20757@dhcp22.suse.cz>
 <alpine.DEB.2.00.1210291340100.18552@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210291340100.18552@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-10-12 13:40:39, David Rientjes wrote:
> On Mon, 29 Oct 2012, Michal Hocko wrote:
> 
> > > N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> > > N_MEMORY stands for the nodes that has any memory.
> > 
> > What is the difference of those two?
> > 
> 
> Patch 5 in the series 

Strange, I do not see that one at the mailing list.

> introduces it to be equal to N_HIGH_MEMORY, so 

So this is just a rename? If yes it would be much esier if it was
mentioned in the patch description.

> accepting this patch would be an implicit ack of the direction taken 
> there.

-- 
Michal Hocko
SUSE Labs
