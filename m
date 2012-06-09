Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2FILyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 07:54:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:48216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab2FILyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 07:54:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163365806"
Date: Sat, 9 Jun 2012 19:54:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/page-writeback.c: fix comments error in
 page-writeback.c
Message-ID: <20120609115413.GA15811@localhost>
References: <1339242333-3080-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339242333-3080-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 07:45:33PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
> ---
>  mm/page-writeback.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 93d8d2f..c833bf0 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -930,7 +930,7 @@ static void bdi_update_dirty_ratelimit(struct backing_dev_info *bdi,
>  	 */
>  
>  	/*
> -	 * dirty_ratelimit will follow balanced_dirty_ratelimit iff
> +	 * dirty_ratelimit will follow balanced_dirty_ratelimit if

That 'iff' means 'if and only if'.

>  	 * task_ratelimit is on the same side of dirty_ratelimit, too.
>  	 * For example, when
>  	 * - dirty_ratelimit > balanced_dirty_ratelimit
> @@ -941,7 +941,7 @@ static void bdi_update_dirty_ratelimit(struct backing_dev_info *bdi,
>  	 * feel and care are stable dirty rate and small position error.
>  	 *
>  	 * |task_ratelimit - dirty_ratelimit| is used to limit the step size
> -	 * and filter out the sigular points of balanced_dirty_ratelimit. Which
> +	 * and filter out the singular points of balanced_dirty_ratelimit. Which
>  	 * keeps jumping around randomly and can even leap far away at times
>  	 * due to the small 200ms estimation period of dirty_rate (we want to
>  	 * keep that period small to reduce time lags).

I'll fold the above chunk into the previous patch.

Thanks,
Fengguang
