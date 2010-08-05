Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab0HEO4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:56:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:1328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0HEO4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,322,1278313200"; 
   d="scan'208";a="825018569"
Date: Thu, 5 Aug 2010 22:55:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] writeback: kill writeback_control.more_io
Message-ID: <20100805145537.GA7889@localhost>
References: <20100722050928.653312535@intel.com>
 <20100722061822.763629019@intel.com>
 <20100801153424.GA8204@barrios-desktop>
 <20100805145053.GA6161@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805145053.GA6161@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:50:53PM +0800, Wu Fengguang wrote:
> > include/trace/events/ext4.h also have more_io field. 
> 
> I didn't find it in linux-next. What's your kernel version?

Oh it's in mmotm :)

Thanks,
Fengguang
