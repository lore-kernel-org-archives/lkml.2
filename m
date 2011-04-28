Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1D1IpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:45:17 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54822 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab1D1IpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:45:14 -0400
Date: Thu, 28 Apr 2011 10:45:00 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 4/8] Make clear description of putback_lru_page
Message-ID: <20110428084500.GG12437@cmpxchg.org>
References: <cover.1303833415.git.minchan.kim@gmail.com>
 <bb2acc3882594cf54689d9e29c61077ff581c533.1303833417.git.minchan.kim@gmail.com>
 <20110427171157.3751528f.kamezawa.hiroyu@jp.fujitsu.com>
 <BANLkTik2FTKgSSYkyP4XT4pkhOYvpjgSTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik2FTKgSSYkyP4XT4pkhOYvpjgSTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 08:20:32AM +0900, Minchan Kim wrote:
> On Wed, Apr 27, 2011 at 5:11 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed, 27 Apr 2011 01:25:21 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> Commonly, putback_lru_page is used with isolated_lru_page.
> >> The isolated_lru_page picks the page in middle of LRU and
> >> putback_lru_page insert the lru in head of LRU.
> >> It means it could make LRU churning so we have to be very careful.
> >> Let's clear description of putback_lru_page.
> >>
> >> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >> Cc: Mel Gorman <mgorman@suse.de>
> >> Cc: Rik van Riel <riel@redhat.com>
> >> Cc: Andrea Arcangeli <aarcange@redhat.com>
> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >
> > seems good...
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > But is there consensus which side of LRU is tail? head?
> 
> I don't know. I used to think it's head.
> If other guys raise a concern as well, let's talk about it. :)
> Thanks

I suppose we add new pages to the head of the LRU and reclaim old
pages from the tail.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
