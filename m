Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab1HJNyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:54:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:19074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1HJNyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,350,1309762800"; 
   d="scan'208";a="37062992"
Date: Wed, 10 Aug 2011 20:28:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110810122804.GA4120@localhost>
References: <20110806084447.388624428@intel.com>
 <20110806094526.733282037@intel.com>
 <1312811193.10488.33.camel@twins>
 <20110808141128.GA22080@localhost>
 <1312813909.10488.38.camel@twins>
 <20110808224742.GB7176@localhost>
 <1312882304.22367.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312882304.22367.50.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:31:44PM +0800, Peter Zijlstra wrote:
> On Tue, 2011-08-09 at 06:47 +0800, Wu Fengguang wrote:
> > origin is where the control line crosses the X axis (in both the
> > global/bdi setpoint cases). 
> 
> Ah, that's normally called zero, root or or x-intercept:
> 
> http://en.wikipedia.org/wiki/X-intercept

Yes indeed! I'll change the name to x_intercept.

Thanks,
Fengguang
