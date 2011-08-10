Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1HJXWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:22:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46581 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab1HJXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <1312973240-32576-8-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-8-git-send-email-mgorman@suse.de>
Date: Thu, 11 Aug 2011 08:22:07 +0900
Message-ID: <CAEwNFnD7rc=eniuCDn5--j3NeF_CJ3fOJ3+Mo=ND6gpq1PbXCg@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm: vmscan: Immediately reclaim end-of-LRU dirty
 pages when writeback completes
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 7:47 PM, Mel Gorman <mgorman@suse.de> wrote:
> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim
> similar to deactivate_page() so that the page gets reclaimed almost
> immediately after the page gets cleaned. This is to avoid reclaiming
> clean pages that are younger than a dirty page encountered at the
> end of the LRU that might have been something like a use-once page.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
