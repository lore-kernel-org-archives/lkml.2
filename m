Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2HGXY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:24:29 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51482 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab2HGXYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 19:24:23 -0400
X-AuditID: 9c930179-b7bdcae000003d91-45-5021a3a42bc8
Date: Wed, 8 Aug 2012 08:25:52 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm: compaction: Update comment in
 try_to_compact_pages
Message-ID: <20120807232552.GA4247@bbox>
References: <1344342677-5845-1-git-send-email-mgorman@suse.de>
 <1344342677-5845-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344342677-5845-2-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 01:31:12PM +0100, Mel Gorman wrote:
> The comment about order applied when the check was
> order > PAGE_ALLOC_COSTLY_ORDER which has not been the case since
> [c5a73c3d: thp: use compaction for all allocation orders]. Fixing
> the comment while I'm in the general area.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
