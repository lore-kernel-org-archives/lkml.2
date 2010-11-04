Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab0KDNNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:13:43 -0400
Received: from verein.lst.de ([213.95.11.210]:45582 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0KDNNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:13:41 -0400
Date: Thu, 4 Nov 2010 14:12:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 00/17] [RFC] soft and dynamic dirty throttling limits
Message-ID: <20101104131228.GA22718@lst.de>
References: <20100912154945.758129106@intel.com> <20101012141716.GA26702@infradead.org> <20101013030733.GV4681@dastard> <20101013082611.GA6733@localhost> <20101013092627.GY4681@dastard> <20101101062446.GK2715@dastard> <20101104034119.GA18910@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104034119.GA18910@localhost>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:41:19AM +0800, Wu Fengguang wrote:
> I'm feeling relatively good about the first 14 patches to do IO-less
> balance_dirty_pages() and larger writeback chunk size. I'll repost
> them separately as v2 after returning to Shanghai.

Going for as small as possible patchsets is a pretty good idea.  Just
getting the I/O less balance_dirty_pages on it's own would be a really
good start, as that's one of the really criticial pieces of
infrastructure that a lot of people are waiting for.  Getting it into
linux-mm/linux-next ASAP so that it gets a lot of testing would be
highly useful.

