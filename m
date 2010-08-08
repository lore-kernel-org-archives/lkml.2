Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0HHGnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 02:43:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47857 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0HHGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 02:43:10 -0400
Date: Sun, 8 Aug 2010 15:42:03 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/7] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20100805150232.GE25688@csn.ul.ie>
References: <20100805151125.31BA.A69D9226@jp.fujitsu.com> <20100805150232.GE25688@csn.ul.ie>
Message-Id: <20100808153750.5AC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch (as well as most of the series) will reject against current mmotm
> because of other reclaim-related patches already in there. The resolutions
> are not too hard but bear it in mind.

I was working on latest published mmotm. but yes, current akpm private mmotm
incluse your reclaim related change.

That said, I need to rework them later.



