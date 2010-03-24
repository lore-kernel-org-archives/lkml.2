Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0CXLtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:49:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43408 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab0CXLtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:49:49 -0400
Date: Wed, 24 Mar 2010 11:49:31 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Corrado Zoccolo <czoccolo@gmail.com>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone
	pressure
Message-ID: <20100324114930.GG21147@csn.ul.ie>
References: <20100315130935.f8b0a2d7.akpm@linux-foundation.org> <20100322235053.GD9590@csn.ul.ie> <20100324023837.GH4359@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100324023837.GH4359@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 07:38:37PM -0700, Greg KH wrote:
> On Mon, Mar 22, 2010 at 11:50:54PM +0000, Mel Gorman wrote:
> > 2. TTY using high order allocations more frequently
> > 	fix title: ttyfix
> > 	fixed in mainline? yes, in 2.6.34-rc2
> > 	affects: 2.6.31 to 2.6.34-rc1
> > 
> > 	2.6.31 made pty's use the same buffering logic as tty.	Unfortunately,
> > 	it was also allowed to make high-order GFP_ATOMIC allocations. This
> > 	triggers some high-order reclaim and introduces some stalls. It's
> > 	fixed in 2.6.34-rc2 but needs back-porting.
> 
> It will go to the other stable kernels for their next round of releases
> now that it is in Linus's tree.
> 

Great.

> > Next Steps
> > ==========
> > 
> > Jens, any problems with me backporting the async/sync fixes from 2.6.31 to
> > 2.6.30.x (assuming that is still maintained, Greg?)?
> 
> No, .30 is no longer being maintained.
> 

Right, I won't lose any sleep over 2.6.30.dodo so :)

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
