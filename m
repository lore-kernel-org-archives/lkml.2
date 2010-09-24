Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0IXJO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:14:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36560 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab0IXJOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:14:25 -0400
Date: Fri, 24 Sep 2010 10:14:12 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Greg KH <greg@kroah.com>
Cc: Rik van Riel <riel@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [stable] [PATCH 0/3] Reduce watermark-related problems with
	the per-cpu allocator V4
Message-ID: <20100924091412.GA8187@csn.ul.ie>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <20100903160551.05db4a92.akpm@linux-foundation.org> <20100921111741.GB11439@csn.ul.ie> <20100921125814.GF1205@kroah.com> <20100921142309.GA31813@csn.ul.ie> <20100923184942.GW23040@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100923184942.GW23040@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > <SNIP>
> > > If so, for which -stable tree?  .27, .32, and .35 are all
> > > currently active.
> > > 
> > 
> > 2.6.35 for certain.
> > 
> > I would have a strong preference for 2.6.32 as well as it's a baseline for
> > a number of distros. The second commit will conflict with per-cpu changes
> > but the resolution is straight-forward.
> 
> Thanks for the backport, I've queued these up for .32 and .35 now.
> 

Thanks Greg.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
