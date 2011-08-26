Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HZMHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:07:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:3601 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1HZMHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:07:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42708000"
Date: Fri, 26 Aug 2011 20:07:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] writeback: trace balance_dirty_pages
Message-ID: <20110826120733.GB26666@localhost>
References: <20110826113813.895522398@intel.com>
 <20110826114619.661085405@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826114619.661085405@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	TP_printk("bdi %s: "
> +		  "limit=%lu goal=%lu dirty=%lu "
> +		  "bdi_goal=%lu bdi_dirty=%lu "
> +		  "base_rate=%lu task_ratelimit=%lu "
> +		  "dirtied=%u dirtied_pause=%u "
> +		  "period=%lu think=%ld pause=%ld paused=%lu",

Sorry, forgot the rename: base_rate => dirty_ratelimit.

Thanks,
Fengguang
