Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1HLNAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:00:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:17112 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1HLM77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 08:59:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,362,1309762800"; 
   d="scan'208";a="37828345"
Date: Fri, 12 Aug 2011 20:59:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110812125952.GA16675@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312814501.10488.41.camel@twins>
 <20110808230535.GC7176@localhost>
 <1313153657.6576.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313153657.6576.40.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 08:54:17PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-12 at 00:56 +0200, Peter Zijlstra wrote:
> > 
> >                s - x 3
> >  f(x) :=  1 + (-----)
> >                  d
> > 
> btw, if you want steeper slopes for rampup and brake you can add another
> factor like:
> 
>                  s - x 3
>   f(x) :=  1 + a(-----)
>                    d
>  
> And solve the whole f(l)=0 thing again to determine d in l and a.
> 
> For 0 < a < 1 the slopes increase.

Yes, we can leave it as a future tuning option. For now I'm pretty
satisfied with the current function's shape :)

Thanks,
Fengguang
