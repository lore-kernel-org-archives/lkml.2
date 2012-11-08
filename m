Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2KHAea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:34:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2KHAe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:34:29 -0500
Date: Wed, 7 Nov 2012 22:34:04 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v11 5/7] virtio_balloon: introduce migration primitives
 to balloon pages
Message-ID: <20121108003403.GE10444@optiplex.redhat.com>
References: <cover.1352256081.git.aquini@redhat.com>
 <265aaff9a79f503672f0cdcdff204114b5b5ba5b.1352256088.git.aquini@redhat.com>
 <87625h3tl1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87625h3tl1.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 09:32:18AM +1030, Rusty Russell wrote:
> The first one can be delayed, the second one can be delayed if the host
> didn't ask for VIRTIO_BALLOON_F_MUST_TELL_HOST (qemu doesn't).
> 
> We could implement a proper request queue for these, and return -EAGAIN
> if the queue fills.  Though in practice, it's not important (it might
> help performance).

I liked the idea. Give me the directions to accomplish it and I'll give it a try
for sure.

