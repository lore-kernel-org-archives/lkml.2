Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1HJLPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:15:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1HJLPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:15:50 -0400
Date: Wed, 10 Aug 2011 12:15:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-ID: <20110810111547.GZ19099@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
 <20110810110056.GA31756@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110810110056.GA31756@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 07:00:56AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 10, 2011 at 11:47:13AM +0100, Mel Gorman wrote:
> >   o Dropped btrfs warning when filesystems are called from direct
> >     reclaim. The fallback method for migration looks indistinguishable
> >     from direct reclaim.
> 
> The right fix is to simply remove that fallback, possibly in combination
> with implementating real migration support for btrfs.
> 

Removing the fallback entirely is overkill as proper migration support
is not going to get 100% coverage but I agree that btrfs should have
real migration support. I didn't think it belonged in this series
though.

-- 
Mel Gorman
SUSE Labs
