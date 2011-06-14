Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1FNNrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:47:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:3951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1FNNrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:47:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,364,1304319600"; 
   d="scan'208";a="12487540"
Date: Tue, 14 Jun 2011 21:46:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: trace global_dirty_state
Message-ID: <20110614134655.GB13768@localhost>
References: <20110610144805.GA9986@localhost>
 <20110613143356.GG4907@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613143356.GG4907@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 10:33:56PM +0800, Jan Kara wrote:
> On Fri 10-06-11 22:48:05, Wu Fengguang wrote:
> > [It seems beneficial to queue this simple trace event for
> >  next/upstream after the review?]
> > 
> > Add trace event balance_dirty_state for showing the global dirty page
> > counts and thresholds at each global_dirty_limits() invocation.  This
> > will cover the callers throttle_vm_writeout(), over_bground_thresh()
> > and each balance_dirty_pages() loop.
>   OK, this might be useful. But shouldn't we also add similar trace point
> for bdi limits? Otherwise the information is of limited use...

Good point. The bdi limits will be exported in another
balance_dirty_pages trace point.

Thanks,
Fengguang
