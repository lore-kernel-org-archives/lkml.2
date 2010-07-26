Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0GZLr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 07:47:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:57752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab0GZLrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 07:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,261,1278313200"; 
   d="scan'208";a="538777877"
Date: Mon, 26 Jul 2010 19:47:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/6] [RFC] writeback: try to write older pages first
Message-ID: <20100726114724.GE6284@localhost>
References: <20100722050928.653312535@intel.com>
 <20100726192837.1cac842e.kitayama@cl.bb4u.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726192837.1cac842e.kitayama@cl.bb4u.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a touch up patch on top of your changes against the latest
> mmotm.
>
> Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

Applied, Thanks!
