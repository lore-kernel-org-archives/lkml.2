Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2IMX6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:58:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44064 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab2IMX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:58:17 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-8a-50527317490b
Date: Fri, 14 Sep 2012 09:00:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] enable CONFIG_COMPACTION by default
Message-ID: <20120914000028.GC5085@bbox>
References: <20120913162104.1458bea2@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913162104.1458bea2@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Thu, Sep 13, 2012 at 04:21:04PM -0400, Rik van Riel wrote:
> Now that lumpy reclaim has been removed, compaction is the
> only way left to free up contiguous memory areas. It is time
> to just enable CONFIG_COMPACTION by default.
>     
> Signed-off-by: Rik van Riel <riel@redhat.com>

I tried this a few month ago and Mel had a concern on size
bloating (compaction.o + migration.o) where system doesn't
use higher order allocation.

Now that I think about it, admin should configure carefully
and manually if he has a size concern of vmlinux without
depending auto-generating config.
So I really want this.

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
