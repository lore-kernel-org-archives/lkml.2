Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2ASQt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:49:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab2ASQtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:49:24 -0500
Date: Thu, 19 Jan 2012 16:49:19 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Sasha Levin <levinsasha928@gmail.com>, hannes <hannes@cmpxchg.org>,
        mhocko@suse.cz, bsingharora@gmail.com, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
Message-ID: <20120119164919.GE3143@suse.de>
References: <1326949826.5016.5.camel@lappy>
 <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
 <20120119130353.0ca97435.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1201182100010.2830@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1201182100010.2830@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 09:16:09PM -0800, Hugh Dickins wrote:
> > 
> > Another question is who pushes pages to LRU before setting pc->mem_cgroup..
> > Anyway, I think we need to fix memcg to be LRU_IMMEDIATE aware.
> 
> I don't think so: Mel agreed that the patch could not go forward as is,
> without an additional pageflag, and asked Andrew to drop it from mmotm
> in mail on 29th December (I didn't notice an mm-commits message to say
> akpm did drop it, and marc is blacked out in protest for today, so I
> cannot check: but certainly akpm left it out of his push to Linus).
> 
> Oh, and Mel noticed another bug in it on the 30th, that the PageLRU
> check in the function you quote above is wrong: see PATCH 11/11 thread.
> 

Yes, that patch is broken. According to the mm-commits list, it was
"withdrawn" on December 30th. I do not know why it is still in
linux-next but AFAIK, it is not expected to end up in mainline. I do not
have a fixed version of the patch at the moment.

-- 
Mel Gorman
SUSE Labs
