Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0GZKom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:44:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59160 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0GZKok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:44:40 -0400
Date: Mon, 26 Jul 2010 11:44:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/6] writeback: pass writeback_control down to
	move_expired_inodes()
Message-ID: <20100726104424.GJ5300@csn.ul.ie>
References: <20100722050928.653312535@intel.com> <20100722061822.484666925@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100722061822.484666925@intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:09:29PM +0800, Wu Fengguang wrote:
> This is to prepare for moving the dirty expire policy to move_expired_inodes().
> No behavior change.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Can't see any problem.

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
