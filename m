Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0GLCwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:52:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0GLCwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:52:49 -0400
Date: Sun, 11 Jul 2010 22:52:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100712025247.GA16784@infradead.org>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
 <20100702121304.GA10075@infradead.org>
 <20100712024104.GD25335@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712024104.GD25335@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 12:41:04PM +1000, Dave Chinner wrote:
> At this point in the cycle, I'd much prefer just to go with adding a
> context to the shrinker API to fix the XFS locking issues (i.e.  the
> original patches I sent) and spend a bit more time working out which
> combination of Nick's and my bits that improves reclaim speed whilst
> retaining the stability of the courrent code....

That approach sounds good to me.

