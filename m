Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0CXCjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:39:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0CXCi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:38:58 -0400
Date: Tue, 23 Mar 2010 19:38:37 -0700
From: Greg KH <gregkh@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Corrado Zoccolo <czoccolo@gmail.com>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone
	pressure
Message-ID: <20100324023837.GH4359@suse.de>
References: <20100315130935.f8b0a2d7.akpm@linux-foundation.org> <20100322235053.GD9590@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322235053.GD9590@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 11:50:54PM +0000, Mel Gorman wrote:
> 2. TTY using high order allocations more frequently
> 	fix title: ttyfix
> 	fixed in mainline? yes, in 2.6.34-rc2
> 	affects: 2.6.31 to 2.6.34-rc1
> 
> 	2.6.31 made pty's use the same buffering logic as tty.	Unfortunately,
> 	it was also allowed to make high-order GFP_ATOMIC allocations. This
> 	triggers some high-order reclaim and introduces some stalls. It's
> 	fixed in 2.6.34-rc2 but needs back-porting.

It will go to the other stable kernels for their next round of releases
now that it is in Linus's tree.

> Next Steps
> ==========
> 
> Jens, any problems with me backporting the async/sync fixes from 2.6.31 to
> 2.6.30.x (assuming that is still maintained, Greg?)?

No, .30 is no longer being maintained.

thanks,

greg k-h
