Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab0LHIgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:36:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40124 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0LHIgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:36:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v4 5/7] add profile information for invalidated page reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <AANLkTik4mtr8T6PddQopi4cwWGRmJ+-utykgjywGoxj+@mail.gmail.com>
References: <20101208165944.174D.A69D9226@jp.fujitsu.com> <AANLkTik4mtr8T6PddQopi4cwWGRmJ+-utykgjywGoxj+@mail.gmail.com>
Message-Id: <20101208173520.1759.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  8 Dec 2010 17:36:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi KOSAKI,
> 
> On Wed, Dec 8, 2010 at 5:02 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> This patch adds profile information about invalidated page reclaim.
> >> It's just for profiling for test so it would be discard when the series
> >> are merged.
> >>
> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >> Cc: Rik van Riel <riel@redhat.com>
> >> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >> Cc: Wu Fengguang <fengguang.wu@intel.com>
> >> Cc: Johannes Weiner <hannes@cmpxchg.org>
> >> Cc: Nick Piggin <npiggin@kernel.dk>
> >> Cc: Mel Gorman <mel@csn.ul.ie>
> >> ---
> >>  include/linux/vmstat.h |    4 ++--
> >>  mm/swap.c              |    3 +++
> >>  mm/vmstat.c            |    3 +++
> >>  3 files changed, 8 insertions(+), 2 deletions(-)
> >
> > Today, we have tracepoint. tracepoint has no overhead if it's unused.
> > but vmstat has a overhead even if unused.
> >
> > Then, all new vmstat proposal should be described why you think it is
> > frequently used from administrators.
> 
> It's just for easy gathering the data when Ben will test.
> I never want to merge it in upstream and even mmtom.

Ok, I had not understand your intention. Thank you.



> If you don't like it for just testing, I am happy to change it with tracepoint.





