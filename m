Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0GBGgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:36:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47164 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab0GBGgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:36:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Jul 2010 15:31:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 14/14] fs,xfs: Allow kswapd to writeback pages
Message-Id: <20100702153143.44c5fec8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100702152643.36019b4e.kamezawa.hiroyu@jp.fujitsu.com>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
	<1277811288-5195-15-git-send-email-mel@csn.ul.ie>
	<20100629123722.GA725@infradead.org>
	<20100629125143.GB31561@csn.ul.ie>
	<20100630091411.49f92cff.kamezawa.hiroyu@jp.fujitsu.com>
	<20100701103032.GG31741@csn.ul.ie>
	<20100702152643.36019b4e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010 15:26:43 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > I see the direction you are thinking of but I have big concerns about clean
> > pages getting delayed for too long on the LRU_CLEANING pages before kswapd
> > puts them back in the right place. I think a safer direction would be for
> > memcg people to investigate Andrea's "switch stack" suggestion.
> > 
> Hmm, I may have to consider that. My concern is that IRQ's switch-stack works
> well just because no-task-switch in IRQ routine. (I'm sorry if I misunderstand.)
> 
Ok, I'll think about this 1st.

Thanks,
-Kame

