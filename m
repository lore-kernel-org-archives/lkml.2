Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1EDJ4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:56:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:16370 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1EDJ4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:56:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="917818105"
Date: Wed, 4 May 2011 17:56:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/6] writeback fixes and trace events
Message-ID: <20110504095637.GA2101@localhost>
References: <20110504091707.910929441@intel.com>
 <20110504094654.GA31151@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504094654.GA31151@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 05:46:54PM +0800, Christoph Hellwig wrote:
> On Wed, May 04, 2011 at 05:17:07PM +0800, Wu Fengguang wrote:
> > Andrew,
> > 
> > Here are one more collection of simple writeback patches.
> 
> How does this relate to the other floating writeback patches?  We
> really need a proper writeback tree to make any sense of the patch
> queues..

These patches are based on the writeback patches already in -mm.
Sorry I should have mentioned it.

Thanks,
Fengguang
