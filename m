Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1FIPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:02:12 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:45366 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1FIPCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T70XY00SynSUobet0gntW5GDoAJ/0qmIHeUVEci5nKvnB7ATfBHhcIHjXc70xBMnBu
         hj0PVrPpYgHnHdtw6dgdC0xJ6HmQTnX6nvCfyGJYmFEa29U4QnvhgBHfgODTom9JomBc
         XeP9LA/kjsYjN1iKL8esQ7mh5u2RUFiZ2SDu8=
Date: Fri, 10 Jun 2011 00:02:00 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 05/10] vmscan: make isolate_lru_page with filter
 aware
Message-ID: <20110609150200.GD4878@barrios-laptop>
References: <cover.1307455422.git.minchan.kim@gmail.com>
 <f101a50f11ffac79eff441c58eafbb5eceac0b47.1307455422.git.minchan.kim@gmail.com>
 <20110609140453.GX5247@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609140453.GX5247@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 03:04:53PM +0100, Mel Gorman wrote:
> On Tue, Jun 07, 2011 at 11:38:18PM +0900, Minchan Kim wrote:
> > In __zone_reclaim case, we don't want to shrink mapped page.
> > Nonetheless, we have isolated mapped page and re-add it into
> > LRU's head. It's unnecessary CPU overhead and makes LRU churning.
> > 
> 
> Gack, I should have keep reading. I didn't cop from the subject that

I should have used clear subject.

> __zone_reclaim would be updated. Still, it would have been easier to
> review if one patch introduced ISOLATE_CLEAN and updated the callers and
> this patch introduced ISOLATE_UNMAPPED and updated the relevant callers.

Agree. I will fix in later version.

> 
> > <SNIP>
> 
> -- 
> Mel Gorman
> SUSE Labs

-- 
Kind regards
Minchan Kim
