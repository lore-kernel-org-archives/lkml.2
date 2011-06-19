Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1FSPfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:35:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:28572 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1FSPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:35:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,389,1304319600"; 
   d="scan'208";a="15189610"
Date: Sun, 19 Jun 2011 23:35:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] writeback: add parameters to
 __bdi_update_bandwidth()
Message-ID: <20110619153531.GA12387@localhost>
References: <20110619150108.691351746@intel.com>
 <20110619150510.130768812@intel.com>
 <20110619153110.GA20424@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619153110.GA20424@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 11:31:10PM +0800, Christoph Hellwig wrote:
> On Sun, Jun 19, 2011 at 11:01:10PM +0800, Wu Fengguang wrote:
> > The added parameters will be used by the next patch and more future patches.
> > 
> > It's separated out for easier review, and will be merged either with the
> > next patch or with the previous write bandwidth patch in future posts.
> 
> I don't think adding parameters separately from the code using it is
> useful.  Please fold this into the later patches.

OK. Folded into the next patch in local queue :)

Thanks,
Fengguang
