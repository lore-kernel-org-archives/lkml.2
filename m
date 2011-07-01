Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1GAPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:45:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:37088 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab1GAPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:45:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,458,1304319600"; 
   d="scan'208";a="20604787"
Date: Fri, 1 Jul 2011 23:45:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] writeback: trace global_dirty_state
Message-ID: <20110701154509.GB17881@localhost>
References: <20110629145245.835998321@intel.com>
 <20110629145554.698086654@intel.com>
 <20110701151801.GA6661@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701151801.GA6661@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 11:18:01PM +0800, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 10:52:54PM +0800, Wu Fengguang wrote:
> > Add trace event balance_dirty_state for showing the global dirty page
> > counts and thresholds at each global_dirty_limits() invocation.  This
> > will cover the callers throttle_vm_writeout(), over_bground_thresh()
> > and each balance_dirty_pages() loop.
> 
> Given that this is a rather uncontoversial diagnostics patch I'd
> move it to the front of the queue.

Yeah it was.. since then it's expanded with the global dirty limit
field, which is newly introduced in [PATCH 6/9].

I'll move it before the larger-chunk-size patch :)

Thanks,
Fengguang
