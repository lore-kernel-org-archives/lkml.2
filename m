Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0HEXJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:09:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0HEXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:09:05 -0400
Date: Thu, 5 Aug 2010 16:08:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/13] writeback patches for 2.6.36
Message-Id: <20100805160801.a5e0afc1.akpm@linux-foundation.org>
In-Reply-To: <20100805161051.501816677@intel.com>
References: <20100805161051.501816677@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 00:10:51 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> These are writeback patches intended for 2.6.36.

I won't be here Friday.  I need to get my junk into mainline on Monday.
Everybody and his dog is working on writeback, which is good, but
there's a lot of flux here.

So, no, I think it's too late to be thinking about 2.6.36-rc1.  Let's
slow down a bit, review and test each other's proposals and work out
what we want to do in the longer term.  After we've done that, we can
calmly and carefully take a look to see if there are any nice goodies
which we want to slip into 2.6.36-rc3 or thereabouts.

