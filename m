Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab2HIXd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:33:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57495 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874Ab2HIXdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:33:25 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-31-502448c2159e
Date: Fri, 10 Aug 2012 08:35:03 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Jim Schutt <jaschut@sandia.gov>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mm: compaction: Capture a suitable high-order page
 immediately when it is made available
Message-ID: <20120809233503.GE21033@bbox>
References: <1344520165-24419-1-git-send-email-mgorman@suse.de>
 <1344520165-24419-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344520165-24419-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 02:49:23PM +0100, Mel Gorman wrote:
> While compaction is migrating pages to free up large contiguous blocks for
> allocation it races with other allocation requests that may steal these
> blocks or break them up. This patch alters direct compaction to capture a
> suitable free page as soon as it becomes available to reduce this race. It
> uses similar logic to split_free_page() to ensure that watermarks are
> still obeyed.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
