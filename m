Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2IGCYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:24:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43039 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2IGCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:24:23 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-38-50495ad59a59
Date: Fri, 7 Sep 2012 11:26:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm: support MIGRATE_DISCARD
Message-ID: <20120907022601.GH16231@bbox>
References: <1346832673-12512-1-git-send-email-minchan@kernel.org>
 <1346832673-12512-2-git-send-email-minchan@kernel.org>
 <20120905105611.GI11266@suse.de>
 <20120906053112.GA16231@bbox>
 <20120906082935.GN11266@suse.de>
 <20120906090325.GO11266@suse.de>
 <CAH9JG2VS62qU1FozAAhTmL0cgcsVBoXCg4X7kLVwciQps7iURg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9JG2VS62qU1FozAAhTmL0cgcsVBoXCg4X7kLVwciQps7iURg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:57:12AM +0900, Kyungmin Park wrote:
> Hi Mel,
> 
> After apply your patch, It got the below message.
> Please note that it's not the latest kernel. it's kernel v3.0.31 + CMA
> + your patch.
> It seems it should not be active but it contains active field.

Yeb. At the moment, shrink_page_list shouldn't handle active pages
so we should clear PG_active bit in reclaim_clean_pages_from_list.

-- 
Kind regards,
Minchan Kim
