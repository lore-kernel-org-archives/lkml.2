Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2A3KrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:47:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36213 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2A3KrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:47:21 -0500
Date: Mon, 30 Jan 2012 10:47:18 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3 -mm 3/3] mm: only defer compaction for failed order
 and higher
Message-ID: <20120130104718.GC25268@csn.ul.ie>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
 <20120126150102.30b75cfe@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120126150102.30b75cfe@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 03:01:02PM -0500, Rik van Riel wrote:
> Currently a failed order-9 (transparent hugepage) compaction can
> lead to memory compaction being temporarily disabled for a memory
> zone.  Even if we only need compaction for an order 2 allocation,
> eg. for jumbo frames networking.
> 
> The fix is relatively straightforward: keep track of the highest
> order at which compaction is succeeding, and only defer compaction
> for orders at which compaction is failing.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
