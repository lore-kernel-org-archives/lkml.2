Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2A3KgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:36:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36084 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2A3KgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:36:16 -0500
Date: Mon, 30 Jan 2012 10:36:13 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3 -mm 1/3] mm: reclaim at order 0 when compaction is
 enabled
Message-ID: <20120130103612.GB25268@csn.ul.ie>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
 <20120126145914.58619765@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120126145914.58619765@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 02:59:14PM -0500, Rik van Riel wrote:
> When built with CONFIG_COMPACTION, kswapd should not try to free
> contiguous pages, because it is not trying hard enough to have
> a real chance at being successful, but still disrupts the LRU
> enough to break other things.
> 
> Do not do higher order page isolation unless we really are in
> lumpy reclaim mode.
> 
> Stop reclaiming pages once we have enough free pages that
> compaction can deal with things, and we hit the normal order 0
> watermarks used by kswapd.
> 
> Also remove a line of code that increments balanced right before
> exiting the function.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
