Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1E3HZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:25:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38635 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1E3HZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fvcxjq/cMup0ufRqS653vsscTPFJ5AvfSdADIiBqTJYRIn3lMQKkQkcptg86fwc+qQ
         1WL8ZS23gnmL9HMitLZ7p7nZBnfgtFZAPZNDsw8jW9MAdphZiwGslUsBMAm5yCPYcYG7
         /+WAZnMhUN0YsxjgH6i2iZ3+Cev3zwM7Keabk=
Date: Mon, 30 May 2011 16:25:46 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mgorman@suse.de, riel@redhat.com, aarcange@redhat.com,
        hannes@cmpxchg.org
Subject: Re: [PATCH v2 00/10] Prevent LRU churning
Message-ID: <20110530072546.GA1727@barrios-laptop>
References: <cover.1306689214.git.minchan.kim@gmail.com>
 <4DE2F741.7060109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE2F741.7060109@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:47:45AM +0900, KOSAKI Motohiro wrote:
> > Minchan Kim (10):
> >   [1/10] Make clear description of isolate/putback functions
> >   [2/10] compaction: trivial clean up acct_isolated
> >   [3/10] Change int mode for isolate mode with enum ISOLATE_PAGE_MODE
> >   [4/10] Add additional isolation mode
> >   [5/10] compaction: make isolate_lru_page with filter aware
> >   [6/10] vmscan: make isolate_lru_page with filter aware
> >   [7/10] In order putback lru core
> >   [8/10] migration: make in-order-putback aware
> >   [9/10] compaction: make compaction use in-order putback
> >   [10/10] add tracepoints
> 
> Minchan,
> 
> I'm sorry I have no chance to review this patch in this week. I'm getting
> stuck for LinuxCon. ;)

I hope you will be free from LinuxCon sometime soon.

> That doesn't mean I dislike this series.

Thanks for the positive feedback, KOSAKI.

I don't think no comment is a negative feedback. 
I think they are very busy these days(ex, memcg typhoon, OOM argument, 
reclaim latency and LinuxCon which I have forgotten.)
This patch isn't urgent so I will wait review of mm folks in patience.

> 
> Thanks.
> 
> 
> 
