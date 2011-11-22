Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1KVOO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:14:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:52485 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1KVOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:14:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,553,1315206000"; 
   d="scan'208";a="77967280"
Date: Tue, 22 Nov 2011 22:14:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] readahead: add /debug/readahead/stats
Message-ID: <20111122141420.GA29261@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.636765408@intel.com>
 <20111121141759.GE24062@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121141759.GE24062@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Mon, Nov 21, 2011 at 10:17:59PM +0800, Andi Kleen wrote:
> > +static unsigned long ra_stats[RA_PATTERN_MAX][RA_ACCOUNT_MAX];
> 
> Why not make it per cpu?  That should get the overhead down, probably
> even enough that it can be enabled by default.
> 
> BTW I have an older framework to make it really easy to add per
> cpu stats counters to debugfs. Will repost, that would simplify
> it even more.

That's definitely a good facility to have. I would be happy to become
its first user :)

Thanks,
Fengguang
