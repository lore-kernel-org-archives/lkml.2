Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab0KEO4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 10:56:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:39993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0KEO4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 10:56:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,303,1286175600"; 
   d="scan'208";a="854501358"
Date: Fri, 5 Nov 2010 22:56:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>,
        "Li, Shaohua" <shaohua.li@intel.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 00/17] [RFC] soft and dynamic dirty throttling limits
Message-ID: <20101105145639.GA6300@localhost>
References: <20100912154945.758129106@intel.com>
 <20101012141716.GA26702@infradead.org>
 <20101013030733.GV4681@dastard>
 <20101013082611.GA6733@localhost>
 <20101013092627.GY4681@dastard>
 <20101101062446.GK2715@dastard>
 <20101104034119.GA18910@localhost>
 <20101104131228.GA22718@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104131228.GA22718@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 09:12:28PM +0800, Christoph Hellwig wrote:
> On Thu, Nov 04, 2010 at 11:41:19AM +0800, Wu Fengguang wrote:
> > I'm feeling relatively good about the first 14 patches to do IO-less
> > balance_dirty_pages() and larger writeback chunk size. I'll repost
> > them separately as v2 after returning to Shanghai.
> 
> Going for as small as possible patchsets is a pretty good idea.  Just
> getting the I/O less balance_dirty_pages on it's own would be a really
> good start, as that's one of the really criticial pieces of
> infrastructure that a lot of people are waiting for.  Getting it into
> linux-mm/linux-next ASAP so that it gets a lot of testing would be
> highly useful.

OK, I'll do a smaller IO-less balance_dirty_pages() patchset (it's
good to know which part is the most relevant one, which is not always
obvious by my limited field experiences), which will further reduce
the possible risk of unexpected regressions.

Currently the -mm tree includes Greg's patchset "memcg: per cgroup
dirty page accounting". I'm going to rebase my patches onto it,
however I'd like to first make sure if Greg's patches are going to be
pushed in the next merge window. I personally have no problem with
that.  Andrew?

Thanks,
Fengguang
