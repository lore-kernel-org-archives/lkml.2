Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab0HEOvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:51:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:5037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760589Ab0HEOvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:51:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,322,1278313200"; 
   d="scan'208";a="542224631"
Date: Thu, 5 Aug 2010 22:50:53 +0800
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
Message-ID: <20100805145053.GA6161@localhost>
References: <20100722050928.653312535@intel.com>
 <20100722061822.763629019@intel.com>
 <20100801153424.GA8204@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801153424.GA8204@barrios-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> include/trace/events/ext4.h also have more_io field. 

I didn't find it in linux-next. What's your kernel version?

Thanks,
Fengguang
