Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1IVLVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:21:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51237 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1IVLVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:21:45 -0400
Date: Thu, 22 Sep 2011 12:21:37 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: staticize compact_zone_order
Message-ID: <20110922112137.GB4213@csn.ul.ie>
References: <20110921085843.GA16233@july>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110921085843.GA16233@july>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:58:43PM +0900, Kyungmin Park wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> There's no user to use compact_zone_order. So staticize this function.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
