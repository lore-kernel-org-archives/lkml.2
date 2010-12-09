Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0LILTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 06:19:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47804 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab0LILTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 06:19:47 -0500
Date: Thu, 9 Dec 2010 11:19:30 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Prevent kswapd dumping excessive amounts of memory
	in response to high-order allocations V3
Message-ID: <20101209111930.GQ5422@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, this should have been PATCH 0/6 of course :(

On Thu, Dec 09, 2010 at 11:18:14AM +0000, Mel Gorman wrote:
> There was a minor bug in V2 that led to this release.  I'm hopeful it'll
> stop kswapd going mad on Simon's machine and might also alleviate some of
> the "too much free memory" problem.
> 
> Changelog since V2
>   o Add clarifying comments
>   o Properly check that the zone is balanced for order-0
>   o Treat zone->all_unreclaimable properly
> 
> Changelog since V1
>   o Take classzone into account
>   o Ensure that kswapd always balances at order-09
>   o Reset classzone and order after reading
>   o Require a percentage of a node be balanced for high-order allocations,
>     not just any zone as ZONE_DMA could be balanced when the node in general
>     is a mess
> 
> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
