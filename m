Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab0HEITY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:19:24 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52770 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0HEITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:19:19 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 04:19:19 EDT
Date: Thu, 5 Aug 2010 10:09:53 +0200
From: Andreas Mohr <andi@lisas.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Bill Davidsen <davidsen@tmr.com>, Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Why PAGEOUT_IO_SYNC stalls for a long time
Message-ID: <20100805080953.GA3366@rhlx01.hs-esslingen.de>
References: <20100801174229.4B08.A69D9226@jp.fujitsu.com> <20100804111005.GA17745@csn.ul.ie> <20100805151630.31CF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805151630.31CF.A69D9226@jp.fujitsu.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:20:44PM +0900, KOSAKI Motohiro wrote:
> Yup, I posted them today. While my lite testing, they works intentionally. it mean
>  - reduce low order reclaim latency
>  - keep high successfull rate order-9 reclaim under heavy io workload
> 
> However, they obviously need more test. comment are welcome :)

Thanks a lot!

I've been following recent discussions,
however testing is planned to be done in nearer future
since I'm currently "recovering" from large backlog (Thesis).

Andreas Mohr
