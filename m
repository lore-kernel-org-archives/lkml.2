Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0GZKx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:53:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42220 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab0GZKxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:53:24 -0400
Date: Mon, 26 Jul 2010 11:53:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/6] writeback: kill writeback_control.more_io
Message-ID: <20100726105308.GL5300@csn.ul.ie>
References: <20100722050928.653312535@intel.com> <20100722061822.763629019@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100722061822.763629019@intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:09:31PM +0800, Wu Fengguang wrote:
> When wbc.more_io was first introduced, it indicates whether there are
> at least one superblock whose s_more_io contains more IO work. Now with
> the per-bdi writeback, it can be replaced with a simple b_more_io test.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
