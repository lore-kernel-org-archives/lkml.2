Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902Ab2FVJej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:34:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758748Ab2FVJeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:34:37 -0400
Date: Fri, 22 Jun 2012 10:34:32 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 01/17] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20120622093432.GA8271@suse.de>
References: <1340192652-31658-1-git-send-email-mgorman@suse.de>
 <1340192652-31658-2-git-send-email-mgorman@suse.de>
 <4FE39290.8020609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4FE39290.8020609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 05:30:56PM -0400, Rik van Riel wrote:
> On 06/20/2012 07:43 AM, Mel Gorman wrote:
> 
> >+/* Clears ac->pfmemalloc if no slabs have pfmalloc set */
> >+static void check_ac_pfmemalloc(struct kmem_cache *cachep,
> >+						struct array_cache *ac)
> >+{
> 
> >+	pfmemalloc_active = false;
> >+out:
> >+	spin_unlock_irqrestore(&l3->list_lock, flags);
> >+}
> 
> The comment and the function do not seem to match.
> 

Well spotted. There used to be ac->pfmemalloc and obviously I failed to
update the comment when it was removed.

> Otherwise, the patch looks reasonable.

Thanks.

-- 
Mel Gorman
SUSE Labs
