Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1K1N4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:56:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:3706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1K1N4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:56:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79783283"
Date: Mon, 28 Nov 2011 21:56:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] dirty throttling bits for 3.3
Message-ID: <20111128135626.GA30388@localhost>
References: <20111121130342.211953629@intel.com>
 <1322052249.14799.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322052249.14799.59.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 08:44:09PM +0800, Peter Zijlstra wrote:
> On Mon, 2011-11-21 at 21:03 +0800, Wu Fengguang wrote:
> > Hi,
> > 
> > I'd like to push these 5 dirty throttling improvements to linux-next,
> > targeting for inclusion in Linux 3.3.
> > 
> > It's a comfortably small series for review ;) And there are no changes since
> > the last v12 post. (I went through them once again but find nothing to change.)
> > 
> >  [PATCH 1/5] writeback: balanced_rate cannot exceed write bandwidth
> >  [PATCH 2/5] writeback: charge leaked page dirties to active tasks
> >  [PATCH 3/5] writeback: fix dirtied pages accounting on sub-page writes
> >  [PATCH 4/5] writeback: fix dirtied pages accounting on redirty
> >  [PATCH 5/5] writeback: dirty ratelimit - think time compensation
> 
> Given the updates I'm ok with this series,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks!

Thank you! I'll post the updated series with your acks :)

Thanks,
Fengguang
