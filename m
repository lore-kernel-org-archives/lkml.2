Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2J2BwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 21:52:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47354 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2J2BwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 21:52:08 -0400
X-AuditID: 9c930197-b7c4aae000004160-5f-508de14618a2
Date: Mon, 29 Oct 2012 10:57:52 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/5] mm, highmem: remove page_address_pool list
Message-ID: <20121029015752.GH15767@bbox>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
 <1351451576-2611-4-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351451576-2611-4-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:12:54AM +0900, Joonsoo Kim wrote:
> We can find free page_address_map instance without the page_address_pool.
> So remove it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

See below a nitpick. :)

> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index 017bad1..731cf9a 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -323,11 +323,7 @@ struct page_address_map {
>  	void *virtual;
>  	struct list_head list;
>  };
> -

Let's leave a blank line.

-- 
Kind regards,
Minchan Kim
