Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2H0UXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab2H0UXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:23:10 -0400
Date: Mon, 27 Aug 2012 17:22:32 -0300
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v9 0/5] make balloon pages movable by compaction
Message-ID: <20120827202231.GB6517@t510.redhat.com>
References: <cover.1345869378.git.aquini@redhat.com>
 <20120826075840.GE19551@redhat.com>
 <503A3565.2060004@redhat.com>
 <20120826154423.GA15478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826154423.GA15478@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 06:44:23PM +0300, Michael S. Tsirkin wrote:
> 
> I am simply asking how was this patchset tested.
> It would be nice to have this info in commit log.
> Since this is an optimization patch it is strange
> to see one with no numbers at all.
> For example, you probably run some workload and
> played with the balloon, and then saw less huge pages
> without the patch and more with?
> Please put this info in the cover letter.

Will do it, for sure. As soon as we get closer to an agreement on how the code
has to behave and looks like. I'll use Mel's mmtests bench suite for that.

Cheers!
