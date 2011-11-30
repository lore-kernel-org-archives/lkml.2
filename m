Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1K3Aol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 19:44:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:1609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab1K3Aoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 19:44:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,594,1315206000"; 
   d="scan'208";a="80436693"
Date: Wed, 30 Nov 2011 08:44:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] readahead: add /debug/readahead/stats
Message-ID: <20111130004424.GC11147@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.666312513@intel.com>
 <20111129152106.GN5635@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129152106.GN5635@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   This looks all inherently racy (which doesn't matter much as you suggest)
> so I just wanted to suggest that if you used per-cpu counters you'd get
> race-free and faster code at the cost of larger data structures and using
> percpu_counter_add() instead of ++ (which doesn't seem like a big
> complication to me).

No problem. I'll switch to per-cpu counters in next post.

Thanks,
Fengguang
