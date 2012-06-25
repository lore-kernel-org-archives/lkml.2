Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2FYLJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:09:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab2FYLJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:09:28 -0400
Date: Mon, 25 Jun 2012 13:09:26 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 3/4] memcg: optimize memcg_get_hierarchical_limit
Message-ID: <20120625110926.GJ19805@tiehlicka.suse.cz>
References: <1340613872-9581-1-git-send-email-liwp.linux@gmail.com>
 <4FE834D9.8070903@jp.fujitsu.com>
 <20120625104357.GB12148@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625104357.GB12148@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-06-12 18:43:57, Wanpeng Li wrote:
> On Mon, Jun 25, 2012 at 06:52:25PM +0900, Kamezawa Hiroyuki wrote:
> >(2012/06/25 17:44), Wanpeng Li wrote:
> >> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> >> 
> >> Optimize memcg_get_hierarchical_limit to save cpu cycle.
> >> 
> >> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> >
> >I can't understand the benefit of this patch to the real world...
> >
> >So, if you wrote the patch description as "clean up" rather than optimize,
> >ok, I'll agree.
> OK, I will change to "Cleanup". Thank you Kame.

Does this really clean something up?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
