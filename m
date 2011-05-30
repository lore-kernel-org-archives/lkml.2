Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1E3OvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:51:02 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39912 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab1E3Ou7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:50:59 -0400
X-Sasl-enc: M9ZZG666mEpIfFzgICWqIxAtNhLXAatCVyKa7EEwySiI 1306767058
Date: Mon, 30 May 2011 22:45:02 +0800
From: Greg KH <greg@kroah.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ury Stankevich <urykhy@gmail.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] mm: compaction: Abort compaction if too many
 pages are isolated and caller is asynchronous
Message-ID: <20110530144502.GA2689@kroah.com>
References: <20110530131300.GQ5044@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530131300.GQ5044@csn.ul.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 02:13:00PM +0100, Mel Gorman wrote:
> Asynchronous compaction is used when promoting to huge pages. This is
> all very nice but if there are a number of processes in compacting
> memory, a large number of pages can be isolated. An "asynchronous"
> process can stall for long periods of time as a result with a user
> reporting that firefox can stall for 10s of seconds. This patch aborts
> asynchronous compaction if too many pages are isolated as it's better to
> fail a hugepage promotion than stall a process.
> 
> If accepted, this should also be considered for 2.6.39-stable. It should
> also be considered for 2.6.38-stable but ideally [11bc82d6: mm:
> compaction: Use async migration for __GFP_NO_KSWAPD and enforce no
> writeback] would be applied to 2.6.38 before consideration.
> 
> Reported-and-Tested-by: Ury Stankevich <urykhy@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/compaction.c |   32 ++++++++++++++++++++++++++------
>  1 files changed, 26 insertions(+), 6 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
