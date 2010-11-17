Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab0KQEbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:31:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:52243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab0KQEbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:31:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="574575761"
Date: Wed, 17 Nov 2010 12:30:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jens Axboe <axboe@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] writeback: IO-less balance_dirty_pages()
Message-ID: <20101117043039.GA15796@localhost>
References: <20101117035905.525232375@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117035905.525232375@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:58:22AM +0800, Wu, Fengguang wrote:
> Andrew,
> References: <20101117035821.000579293@intel.com>
> Content-Disposition: inline; filename=writeback-bw-throttle.patch

Ah missed an extra empty line to quilt. Sorry, I'll re-submit.

Thanks,
Fengguang
