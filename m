Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab1KBPOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:14:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:12974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab1KBPOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,444,1315206000"; 
   d="scan'208";a="69754244"
Date: Wed, 2 Nov 2011 23:13:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
        Curt Wohlgemuth <curtw@google.com>, Michael Rubin <mrubin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Tang Feng <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com
Subject: Re: writeback tree status (for 3.2 merge window)
Message-ID: <20111102151355.GA6717@localhost>
References: <20111101074347.GA23644@localhost>
 <20111102091012.GA25879@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102091012.GA25879@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 05:10:12AM -0400, Christoph Hellwig wrote:
> On Tue, Nov 01, 2011 at 03:43:47PM +0800, Wu Fengguang wrote:
> > Hi,
> > 
> > There are 3 patchsets sitting in the writeback tree.
> > 
> >         1) IO-less dirty throttling v12
> >         https://github.com/fengguang/linux/commits/dirty-throttling-v12
> > 
> >         2) writeback reasons tracing from Curt Wohlgemuth
> >         https://github.com/fengguang/linux/commits/writeback-reason
> > 
> >         3) writeback queuing changes from Jan Kara and me
> >         https://github.com/fengguang/linux/commits/requeue-io-wait
> > 
> > They have been merged into this branch testing in linux-next for a while:
> > 
> > https://github.com/fengguang/linux/commits/writeback-for-next
> > 
> > Since (3) still has an unresolved issue (detailed in the below
> > links), it looks better to hold it back for this merge window.
> 
> Given that we have run into issues so much with it that's proably
> the better idea.
> 
> To fix the originally reported issue with the missing file size updates
> in XFS we plan to simply log all filesize changes in XFS.  Currently I
> had this in the 3.3 queue, but in the worst case we might have to move
> this forward to 3.2.

OK. Anyway I'll report any progress early on (3).

> > The patches from (1,2) together with 2 tracing patches essential for
> > debugging (1) have been pushed to the "writeback-for-linus" branch:
> > 
> >         http://git.kernel.org/?p=linux/kernel/git/wfg/linux.git;a=shortlog;h=refs/heads/writeback-for-linus
> > 
> > If no objections, I'll send a pull request to Linus soon.
> 
> Please do so.  I'm really looking forward to see the I/O-less
> balance_dirty_pages in ASAP.

Done, thanks!

Thanks,
Fengguang
