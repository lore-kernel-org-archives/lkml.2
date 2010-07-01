Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0GAJxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:53:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45896 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab0GAJxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:53:36 -0400
Date: Thu, 1 Jul 2010 10:53:18 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 01/14] vmscan: Fix mapping use after free
Message-ID: <20100701095318.GE31741@csn.ul.ie>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie> <1277811288-5195-2-git-send-email-mel@csn.ul.ie> <AANLkTilwzGf2rikXYAe4Evl41lqjk8voVSG4ICfAgUI1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTilwzGf2rikXYAe4Evl41lqjk8voVSG4ICfAgUI1@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 11:27:05PM +0900, Minchan Kim wrote:
> On Tue, Jun 29, 2010 at 8:34 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > From: Nick Piggin <npiggin@suse.de>
> >
> > Use lock_page_nosync in handle_write_error as after writepage we have no
> > reference to the mapping when taking the page lock.
> >
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Trivial.
> Please modify description of the function if you have a next turn.
> "run sleeping lock_page()" -> "run sleeping lock_page_nosync"
> 

Fixed, thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
