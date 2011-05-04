Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1EDLSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:18:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1EDLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:18:04 -0400
Date: Wed, 4 May 2011 07:18:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/6] writeback fixes and trace events
Message-ID: <20110504111801.GA23222@infradead.org>
References: <20110504091707.910929441@intel.com>
 <20110504094654.GA31151@infradead.org>
 <20110504095637.GA2101@localhost>
 <20110504100609.GE9114@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504100609.GE9114@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 08:06:09PM +1000, Dave Chinner wrote:
> > These patches are based on the writeback patches already in -mm.
> > Sorry I should have mentioned it.
> 
> Does anyone actaully testing filesystems use the -mm tree? I'm
> pretty sure that no-one in the XFS world does, and I don't think
> that any ext4 or btrfs folk do, either....

I doubt it since -mm still hasn't made it into linux-next.

