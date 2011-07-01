Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1GAPSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:18:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38240
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab1GAPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:18:03 -0400
Date: Fri, 1 Jul 2011 11:18:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] writeback: trace global_dirty_state
Message-ID: <20110701151801.GA6661@infradead.org>
References: <20110629145245.835998321@intel.com>
 <20110629145554.698086654@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145554.698086654@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:52:54PM +0800, Wu Fengguang wrote:
> Add trace event balance_dirty_state for showing the global dirty page
> counts and thresholds at each global_dirty_limits() invocation.  This
> will cover the callers throttle_vm_writeout(), over_bground_thresh()
> and each balance_dirty_pages() loop.

Given that this is a rather uncontoversial diagnostics patch I'd
move it to the front of the queue.

