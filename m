Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1AZIOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:14:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46524 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1AZIOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:14:39 -0500
Date: Wed, 26 Jan 2011 08:14:14 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/3] When migrate_pages returns 0, all pages must have
	been released
Message-ID: <20110126081414.GK18984@csn.ul.ie>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 01:17:05AM +0900, Minchan Kim wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> In some cases migrate_pages could return zero while still leaving a
> few pages in the pagelist (and some caller wouldn't notice it has to
> call putback_lru_pages after commit
> cf608ac19c95804dc2df43b1f4f9e068aa9034ab).
> 
> Add one missing putback_lru_pages not added by commit
> cf608ac19c95804dc2df43b1f4f9e068aa9034ab.
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Better late than never;

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Linux Technology Center
IBM Dublin Software Lab
