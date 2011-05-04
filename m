Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1EDLNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:13:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:32196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab1EDLNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:13:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="637750757"
Date: Wed, 4 May 2011 19:13:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Chinner <david@fromorbit.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] writeback: pass writeback_control down to
 move_expired_inodes()
Message-ID: <20110504111310.GB5191@localhost>
References: <20110420080336.441157866@intel.com>
 <20110420080917.759855316@intel.com>
 <20110504110430.GA4646@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504110430.GA4646@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 07:04:32PM +0800, Christoph Hellwig wrote:
> On Wed, Apr 20, 2011 at 04:03:37PM +0800, Wu Fengguang wrote:
> > No behavior change. This will add debug visibility to the code, for
> > example, to dump the wbc contents when kprobing queue_io().
> 
> I don't think it's a good idea.  The writeback_control should move
> back to just controlling per-inode writeback and not be passed to
> more routines dealing with high-level writeback.

Good point. I can do without this patch.

Thanks,
Fengguang
