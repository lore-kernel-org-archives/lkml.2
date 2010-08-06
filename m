Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127Ab0HFKOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:14:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555Ab0HFKOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:14:45 -0400
Subject: Re: [PATCH 02/13] writeback: avoid unnecessary calculation of bdi
 dirty thresholds
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20100805162432.963007535@intel.com>
References: <20100805161051.501816677@intel.com>
	 <20100805162432.963007535@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 06 Aug 2010 12:14:10 +0200
Message-ID: <1281089650.1947.404.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 00:10 +0800, Wu Fengguang wrote:
> plain text document attachment (writeback-less-bdi-calc.patch)
> Split get_dirty_limits() into global_dirty_limits()+bdi_dirty_limit(),
> so that the latter can be avoided when under global dirty background
> threshold (which is the normal state for most systems).
> 
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
