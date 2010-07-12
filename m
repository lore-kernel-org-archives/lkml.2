Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0GLClS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:41:18 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:37776 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753913Ab0GLClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:41:16 -0400
Date: Mon, 12 Jul 2010 12:41:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100712024104.GD25335@dastard>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <20100702121304.GA10075@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702121304.GA10075@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 08:13:04AM -0400, Christoph Hellwig wrote:
> Did you plan to resubmit this with the few review comments addressed?
> I'd really hate to not see this in 2.6.36.

I've been doing some more testing on it, and while I can get a 25%
reduction in the time to create and remove 10 million inodes with
per-sb shrinker, I can't get the reclaim pattern stable enough for
my liking.

At this point in the cycle, I'd much prefer just to go with adding a
context to the shrinker API to fix the XFS locking issues (i.e.  the
original patches I sent) and spend a bit more time working out which
combination of Nick's and my bits that improves reclaim speed whilst
retaining the stability of the courrent code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
