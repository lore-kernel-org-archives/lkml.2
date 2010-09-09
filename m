Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0IIDVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:21:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43637 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0IIDU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:20:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Sep 2010 12:15:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use
 lock_page() instead trylock_page()
Message-Id: <20100909121547.2e69735a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100909120448.58acc9a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
	<1283770053-18833-6-git-send-email-mel@csn.ul.ie>
	<20100909120448.58acc9a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 12:04:48 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon,  6 Sep 2010 11:47:28 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > With synchrounous lumpy reclaim, there is no reason to give up to reclaim
> > pages even if page is locked. This patch uses lock_page() instead of
> > trylock_page() in this case.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Ah......but can't this change cause dead lock ??

Thanks,
-Kame

