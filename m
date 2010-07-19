Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025Ab0GSOPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:15:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab0GSOPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:15:06 -0400
Date: Mon, 19 Jul 2010 10:15:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/8] vmscan: tracing: Update trace event to track if page
 reclaim IO is for anon or file pages
Message-ID: <20100719141501.GA12510@infradead.org>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
 <1279545090-19169-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279545090-19169-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 02:11:24PM +0100, Mel Gorman wrote:
> It is useful to distinguish between IO for anon and file pages. This
> patch updates
> vmscan-tracing-add-trace-event-when-a-page-is-written.patch to include
> that information. The patches can be merged together.

I think the trace would be nicer if you #define flags for both
cases and then use __print_flags on them.  That'll also make it more
extensible in case we need to add more flags later.

And a purely procedural question:  This is supposed to get rolled into
the original patch before it gets commited to a git tree, right?

