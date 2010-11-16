Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab0KPJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:58:25 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47430 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab0KPJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:58:24 -0500
Date: Tue, 16 Nov 2010 09:58:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] set_pgdat_percpu_threshold() don't use
	for_each_online_cpu
Message-ID: <20101116095809.GO27362@csn.ul.ie>
References: <1288169256-7174-2-git-send-email-mel@csn.ul.ie> <20101028100920.5d4ce413.kamezawa.hiroyu@jp.fujitsu.com> <20101114163727.BEE0.A69D9226@jp.fujitsu.com> <20101115102617.GK27362@csn.ul.ie> <alpine.DEB.2.00.1011150802470.19175@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011150802470.19175@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 08:04:23AM -0600, Christoph Lameter wrote:
> On Mon, 15 Nov 2010, Mel Gorman wrote:
> 
> > With recent per-cpu allocator changes, are we guaranteed that the per-cpu
> > structures exist and are valid?
> 
> We always guarantee that all per cpu areas for all possible cpus exist.
> That has always been the case. There was a discussion about changing
> that though. Could be difficult given the need for additional locking.
> 

In that case, I do not have any more concerns about the patch. It's
unfortunate that more per-cpu structures will have to be updated but I
doubt it'll be noticable.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
