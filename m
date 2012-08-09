Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab2HINu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:50:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34612 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab2HINu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:50:56 -0400
Date: Thu, 9 Aug 2012 14:50:53 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] compaction: fix deferring compaction mistake
Message-ID: <20120809135053.GE10288@csn.ul.ie>
References: <1344387464-10037-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1344387464-10037-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 09:57:44AM +0900, Minchan Kim wrote:
> [1] fixed bad deferring policy but made mistake about checking
> compact_order_failed in __compact_pgdat so it can't update
> compact_order_failed with new order. It ends up preventing working
> of deffering policy rightly. This patch fixes it.
> 
> [1] aff62249, vmscan: only defer compaction for failed order and higher
> 
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
