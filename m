Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2KKTWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 14:22:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2KKTWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 14:22:35 -0500
Date: Sun, 11 Nov 2012 17:22:07 -0200
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v11 7/7] mm: add vm event counters for balloon pages
 compaction
Message-ID: <20121111192206.GB4290@x61.redhat.com>
References: <cover.1352256081.git.aquini@redhat.com>
 <8dde7996f3e36a5efbe569afe1aadfc84355e79e.1352256088.git.aquini@redhat.com>
 <20121110155538.GC13846@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121110155538.GC13846@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 05:55:38PM +0200, Michael S. Tsirkin wrote:
> >  	mutex_unlock(&vb->balloon_lock);
> > +	balloon_event_count(COMPACTBALLOONMIGRATED);
> >  
> >  	return MIGRATEPAGE_BALLOON_SUCCESS;
> >  }
> 
> Looks like any ballon would need to do this.
> Can this  chunk go into caller instead?
>

Good catch. It's done, already (v12 just hit the wild).

Thanks!
-- Rafael
