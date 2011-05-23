Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1EWJ2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:28:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:30940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1EWJ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:28:41 -0400
X-ExtLoop1: 1
Date: Mon, 23 May 2011 17:28:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/18] writeback fixes and cleanups for 2.6.40 (v3)
Message-ID: <20110523092838.GA25829@localhost>
References: <20110519214530.939830917@intel.com>
 <20110523090739.GA27894@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523090739.GA27894@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 05:07:39PM +0800, Christoph Hellwig wrote:
> Wu, Andrew,
> 
> what's the plan for these for 2.6.40?  We'll need to make some progress
> in this area, and even if we can't get everything it we should make sure
> to at least include the updated versions of those in -mm.  But even
> some of the later ones are pretty low risk.

Yes, except for patch 14 which does not include external behavior
changes besides the good full write chunk size for large files, the
patches not in -mm are pretty trivial ones.

Aside from my simple tests, Alex also helped going through the LKP
tests with the patchset and find no writeback regressions.

Thanks,
Fengguang
