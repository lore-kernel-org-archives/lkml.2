Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204Ab0J2K3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:29:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:45318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026Ab0J2K3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:29:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,259,1286175600"; 
   d="scan'208";a="342065339"
Date: Fri, 29 Oct 2010 12:31:54 +0200
From: Andi Kleen <andi.kleen@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
Message-ID: <20101029103154.GA10823@gargoyle.fritz.box>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
 <op.vlbywq137p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vlbywq137p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I was posting CMA, it had been suggested to create a new migration type
> dedicated to contiguous allocations.  I think I already did that and thanks to
> this new migration type we have (i) an area of memory that only accepts movable
> and reclaimable pages and 

Aka highmem next generation :-(

> (ii) is used only if all other (non-reserved) pages have
> been allocated.

That will be near always the case after some uptime, as memory fills up
with caches. Unless you do early reclaim? 

-Andi

