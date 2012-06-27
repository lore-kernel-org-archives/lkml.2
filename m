Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2F0I7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:59:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2F0I7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:59:20 -0400
Date: Wed, 27 Jun 2012 10:59:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v2] memcg: unify mem_control_xxx to memcg_xxx
Message-ID: <20120627085917.GA5683@tiehlicka.suse.cz>
References: <1340756175-3420-1-git-send-email-liwp.linux@gmail.com>
 <4FEAC7C6.7030601@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEAC7C6.7030601@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-06-12 12:43:50, Glauber Costa wrote:
> On 06/27/2012 04:16 AM, Wanpeng Li wrote:
> >From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> >
> >Changelog:
> >
> >V2 -> V1:
> >
> >* replace memory_cgroup_xxx by memcg_xxx
> >
> >Unify memcg functions to memcg_xxx.
> 
> 
> This patch achieves nothing.
> You're changing a couple of function names. Andrew stated goal was
> to change *all* function names from mem_cgroup_xxx to memcg_xxx, not
> just one or two.

No mass things now, please.
git grep mem_cgroup_ mm/ include/ | wc -l
863

This will be real pain for merging.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
