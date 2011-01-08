Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab1AHWZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:25:30 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:52466 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab1AHWZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:25:30 -0500
Date: Sat, 8 Jan 2011 23:25:25 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/7] tlbfs: Change remove_from_page_cache
Message-ID: <20110108222302.GD23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
 <8fb992356ab4f24f0bcb47b8a59b298508e48745.1293031046.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fb992356ab4f24f0bcb47b8a59b298508e48745.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:32:45AM +0900, Minchan Kim wrote:
> This patch series changes remove_from_page_cache's page ref counting
> rule. Page cache ref count is decreased in delete_from_page_cache.
> So we don't need decreasing page reference by caller.
> 
> Cc: William Irwin <wli@holomorphy.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

As Mel pointed out, that should be hugetlbfs in the subject.
Otherwise, the patch looks good.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
