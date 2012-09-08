Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab2IHAQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:16:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2IHAQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:16:53 -0400
Date: Sat, 8 Sep 2012 09:16:43 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm: support MIGRATE_DISCARD
Message-ID: <20120908001643.GA2538@barrios>
References: <1346832673-12512-1-git-send-email-minchan@kernel.org>
 <1346832673-12512-2-git-send-email-minchan@kernel.org>
 <20120905105611.GI11266@suse.de>
 <20120906053112.GA16231@bbox>
 <20120906082935.GN11266@suse.de>
 <20120906090325.GO11266@suse.de>
 <20120907022434.GG16231@bbox>
 <20120907082145.GV11266@suse.de>
 <20120907093203.GX11266@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907093203.GX11266@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:32:03AM +0100, Mel Gorman wrote:
> On Fri, Sep 07, 2012 at 09:21:45AM +0100, Mel Gorman wrote:
> > 
> > So other than the mix up of order parameters I think this should work.
> > 
> 
> But I'd be wrong, isolated page accounting is not fixed up so it will
> eventually hang on too_many_isolated. It turns out it is necessary

Good spot.

> to pass in zone after all. The following patch passed a high order
> allocation stress test. To actually exercise the path I had compaction
> call reclaim_clean_pages_from_list() in a separate debugging patch.
> 
> Minchan, can you test your CMA allocation latency test with this patch?
> If the figures are satisfactory could you add them to the changelog and
> consider replacing the MIGRATE_DISCARD pair of patches with this version
> please?

Of course, I will do next week.
Thanks!

--
Kind Regards,
Minchan Kim
