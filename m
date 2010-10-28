Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab0J1IBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 04:01:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35019 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab0J1IBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 04:01:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 4/7] vmscan: narrowing synchrounous lumply reclaim condition
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20101027180333.GE29304@random.random>
References: <20101027171643.GA4896@csn.ul.ie> <20101027180333.GE29304@random.random>
Message-Id: <20101028162522.B0B5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 28 Oct 2010 17:00:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> My tree uses compaction in a fine way inside kswapd too and tons of
> systems are running without lumpy and floods of order 9 allocations
> with only compaction (in direct reclaim and kswapd) without the
> slighest problem. Furthermore I extended compaction for all
> allocations not just that PAGE_ALLOC_COSTLY_ORDER (maybe I already
> removed all PAGE_ALLOC_COSTLY_ORDER checks?). There's no good reason
> not to use compaction for every allocation including 1,2,3, and things
> works fine this way.

Interesting. I parsed this you have compaction improvement. If so,
can you please post them? Generically, 1) improve the feature 2) remove
unused one is safety order. In the other hand, reverse order seems to has
regression risk.



