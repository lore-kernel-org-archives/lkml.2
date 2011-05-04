Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1EDKGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:06:17 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:38907 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab1EDKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:06:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHMjwU15LBza/2dsb2JhbACmFnjEIQ6FeQSeAQ
Date: Wed, 4 May 2011 20:06:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/6] writeback fixes and trace events
Message-ID: <20110504100609.GE9114@dastard>
References: <20110504091707.910929441@intel.com>
 <20110504094654.GA31151@infradead.org>
 <20110504095637.GA2101@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504095637.GA2101@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 05:56:37PM +0800, Wu Fengguang wrote:
> On Wed, May 04, 2011 at 05:46:54PM +0800, Christoph Hellwig wrote:
> > On Wed, May 04, 2011 at 05:17:07PM +0800, Wu Fengguang wrote:
> > > Andrew,
> > > 
> > > Here are one more collection of simple writeback patches.
> > 
> > How does this relate to the other floating writeback patches?  We
> > really need a proper writeback tree to make any sense of the patch
> > queues..
> 
> These patches are based on the writeback patches already in -mm.
> Sorry I should have mentioned it.

Does anyone actaully testing filesystems use the -mm tree? I'm
pretty sure that no-one in the XFS world does, and I don't think
that any ext4 or btrfs folk do, either....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
