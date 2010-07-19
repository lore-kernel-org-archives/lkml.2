Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab0GSOYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:24:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41175 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108Ab0GSOYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:24:53 -0400
Date: Mon, 19 Jul 2010 15:24:36 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/8] vmscan: tracing: Update trace event to track if
	page reclaim IO is for anon or file pages
Message-ID: <20100719142436.GO13117@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie> <1279545090-19169-3-git-send-email-mel@csn.ul.ie> <20100719141501.GA12510@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100719141501.GA12510@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:15:01AM -0400, Christoph Hellwig wrote:
> On Mon, Jul 19, 2010 at 02:11:24PM +0100, Mel Gorman wrote:
> > It is useful to distinguish between IO for anon and file pages. This
> > patch updates
> > vmscan-tracing-add-trace-event-when-a-page-is-written.patch to include
> > that information. The patches can be merged together.
> 
> I think the trace would be nicer if you #define flags for both
> cases and then use __print_flags on them.  That'll also make it more
> extensible in case we need to add more flags later.
> 

Not a bad idea, I'll check it out. Thanks. The first flags would be;

RECLAIM_WB_ANON
RECLAIM_WB_FILE

Does anyone have problems with the naming?


> And a purely procedural question:  This is supposed to get rolled into
> the original patch before it gets commited to a git tree, right?
> 

That is my expectation.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
