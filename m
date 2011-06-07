Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1FGVLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:11:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:47009 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab1FGVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:11:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="10370433"
Date: Wed, 8 Jun 2011 05:11:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: writeback merge status, was Re: [PATCH 00/18] writeback fixes
 and cleanups for 2.6.40 (v3)
Message-ID: <20110607211116.GA4793@localhost>
References: <20110519214530.939830917@intel.com>
 <20110523090739.GA27894@infradead.org>
 <20110523092838.GA25829@localhost>
 <20110524032859.GA17429@localhost>
 <20110601153142.0bf83332.akpm@linux-foundation.org>
 <20110602022919.GB6015@localhost>
 <20110607121335.GA14080@infradead.org>
 <20110607131512.bf27eb68.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607131512.bf27eb68.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 04:15:12AM +0800, Andrew Morton wrote:
> On Tue, 7 Jun 2011 08:13:36 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > It looks like we once again got no writeback fixes merged for $NEXT,
> > even with Wu having a very nice, well reviewed and tested series of 
> > fairly trivial patches.
> 
> We're waiting for the v4 series:
 
The v4 series was posted here:

https://lkml.org/lkml/2011/5/24/20

> : I'll rearrange the series and move patch 14 to the end, so that the
> : patches come in order
> :
> : - 10 (updated) patches in -mm
> : - 6 more trivial patches that is safe to go upstream after -rc1 
> : - the current patch 14 and patch 16 (that depends on 14)

Anyway, I'll make the series straight and resubmit.

Thanks,
Fengguang
