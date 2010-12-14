Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0LNX4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:56:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39308 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0LNX4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:56:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Dec 2010 08:50:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, BooJin Kim <boojin.kim@samsung.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv7 08/10] mm: cma: Contiguous Memory Allocator added
Message-Id: <20101215085047.251778be.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87zks8fyb0.fsf@erwin.mina86.com>
References: <cover.1292004520.git.m.nazarewicz@samsung.com>
	<fc8aa07ac71d554ba10af4943fdb05197c681fa2.1292004520.git.m.nazarewicz@samsung.com>
	<20101214102401.37bf812d.kamezawa.hiroyu@jp.fujitsu.com>
	<87zks8fyb0.fsf@erwin.mina86.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 11:23:15 +0100
Michal Nazarewicz <mina86@mina86.com> wrote:

> > Hmm, it seems __cm_alloc() and __cm_migrate() has no special codes for CMA.
> > I'd like reuse this for my own contig page allocator.
> > So, could you make these function be more generic (name) ?
> > as
> > 	__alloc_range(start, size, mirate_type);
> >
> > Then, what I have to do is only to add "search range" functions.
> 
> Sure thing.  I'll post it tomorrow or Friday. How about
> alloc_contig_range() maybe?
> 

That sounds great. Thank you.

-Kame

