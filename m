Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1LMOUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:20:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab1LMOUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:20:00 -0500
Date: Tue, 13 Dec 2011 15:19:57 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <dhillf@gmail.com>, Hugh Dickins <hughd@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: clean up soft_limit_tree properly new
Message-ID: <20111213141957.GC30440@tiehlicka.suse.cz>
References: <CAJd=RBB_AoJmyPd7gfHn+Kk39cn-+Wn-pFvU0ZWRZhw2fxoihw@mail.gmail.com>
 <alpine.LSU.2.00.1112111520510.2297@eggly>
 <20111212131118.GA15249@tiehlicka.suse.cz>
 <CAJd=RBAZT0zVnMm7i7P4J9Qg+LvTYh25RwFP7JZnN9dxwWp55g@mail.gmail.com>
 <20111212140750.GE14720@tiehlicka.suse.cz>
 <20111212140935.GF14720@tiehlicka.suse.cz>
 <20111213140844.GB1818@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213140844.GB1818@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-12-11 15:08:44, Johannes Weiner wrote:
> On Mon, Dec 12, 2011 at 03:09:35PM +0100, Michal Hocko wrote:
> > And a follow up patch for the proper clean up:
> > ---
> > >From 4b9f5a1e88496af9f336d1ef37cfdf3754a3ba48 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Mon, 12 Dec 2011 15:04:18 +0100
> > Subject: [PATCH] memcg: clean up soft_limit_tree properly
> > 
> > If we are not able to allocate tree nodes for all NUMA nodes then we
> > should better clean up those that were allocated otherwise we will leak
> > a memory.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks

> 
> That being said, I think it's unlikely that the machine even boots
> properly if those allocations fail.  But the code looks better this
> way and one doesn't have to double take, wondering if anyone else is
> taking care of the already allocated objects.

Yes, that was the point of the patch - just a cleanup. I do not think we
want to push it into stable...

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
