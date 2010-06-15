Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab0FOLpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:45:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54450 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755Ab0FOLpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:45:41 -0400
Date: Tue, 15 Jun 2010 12:45:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/12] Avoid overflowing of stack during page reclaim V2
Message-ID: <20100615114523.GF26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <20100614151011.GA24948@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100614151011.GA24948@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:10:11AM -0400, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 12:17:41PM +0100, Mel Gorman wrote:
> > This is a merging of two series - the first of which reduces stack usage
> > in page reclaim and the second which writes contiguous pages during reclaim
> > and avoids writeback in direct reclaimers.
> 
> This stuff looks good to me from the filesystem POV.
> 
> You might want to throw in a follow on patch to remove the PF_MEMALLOC
> checks from the various ->writepage methods.
> 

Will do, thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
