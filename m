Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2JRWDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:03:22 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59523 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2JRWDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:03:20 -0400
Date: Thu, 18 Oct 2012 18:03:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Jiang Liu <liuj97@gmail.com>, mhocko@suse.cz, bsingharora@gmail.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH] memory cgroup: update root memory cgroup when node is
 onlined
Message-ID: <20121018220306.GA1739@cmpxchg.org>
References: <505187D4.7070404@cn.fujitsu.com>
 <20120913205935.GK1560@cmpxchg.org>
 <alpine.LSU.2.00.1209131816070.1908@eggly.anvils>
 <507CF789.6050307@cn.fujitsu.com>
 <alpine.LSU.2.00.1210181129180.2137@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210181129180.2137@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:03:44PM -0700, Hugh Dickins wrote:
> On Tue, 16 Oct 2012, Wen Congyang wrote:
> > At 09/14/2012 09:36 AM, Hugh Dickins Wrote:
> > > 
> > > Description to be filled in later: would it be needed for -stable,
> > > or is onlining already broken in other ways that you're now fixing up?
> > > 
> > > Reported-by: Tang Chen <tangchen@cn.fujitsu.com>
> > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > 
> > Hi, all:
> > 
> > What about the status of this patch?
> 
> Sorry I'm being so unresponsive at the moment (or, as usual).
> 
> When I sent the fixed version afterwards (minus mistaken VM_BUG_ON,
> plus safer mem_cgroup_force_empty_list), I expected you or Konstantin
> to respond with a patch to fix it as you preferred (at offline/online);
> so this was on hold until we could compare and decide between them.
> 
> In the meantime, I assume, we've all come to feel that this way is
> simple, and probably the best way for now; or at least good enough,
> and we all have better things to do than play with alternatives.
> 
> I'll write up the description of the fixed version, and post it for
> 3.7, including the Acks from Hannes and KAMEZAWA (assuming they carry
> forward to the second version) - but probably not today or tomorrow.

Mine does, thanks for asking :-)
