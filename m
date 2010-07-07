Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0GGSKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:10:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0GGSKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:10:05 -0400
Date: Wed, 7 Jul 2010 14:09:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
Message-ID: <20100707180930.GA15616@infradead.org>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
 <1277811288-5195-13-git-send-email-mel@csn.ul.ie>
 <20100702125155.69c02f85.akpm@linux-foundation.org>
 <20100705134949.GC13780@csn.ul.ie>
 <20100707050338.GA5039@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707050338.GA5039@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 01:03:38PM +0800, Wu Fengguang wrote:
> Here is an old patch for fixing this. Sorry for being late. I'll
> pick up and refresh the patch series ASAP.  (I made a mistake last
> year to post too many patches at one time. I'll break them up into
> more manageable pieces.)

Yes, that would be very welcome.  There's a lot of important work
in that series.

