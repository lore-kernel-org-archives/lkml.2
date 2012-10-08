Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2JHGqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:46:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62150 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2JHGqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:46:30 -0400
X-AuditID: 9c930197-b7b6dae000000e70-4c-507276c31c9b
Date: Mon, 8 Oct 2012 15:50:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] mm: compaction: Iron out isolate_freepages_block() and
 isolate_freepages_range() -fix2
Message-ID: <20121008065035.GB13817@bbox>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <20120927151159.4427fc8f.akpm@linux-foundation.org>
 <20120928054330.GA27594@bbox>
 <20121004140017.GW29125@suse.de>
 <20121005095945.GC29125@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005095945.GC29125@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 10:59:45AM +0100, Mel Gorman wrote:
> Thierry reported offline that the strict check "mm: compaction: Iron out
> isolate_freepages_block() and isolate_freepages_range() -fix1" check is
> still too strict because it's possible for more pages to be isolated
> than required. This patch corrects the check.
> 
> There are still CMA-related problems but they are "somewhere else" yet
> to be determined.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
