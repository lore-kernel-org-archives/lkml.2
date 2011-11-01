Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1KAHnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:43:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:64402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1KAHny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,437,1315206000"; 
   d="scan'208";a="69160597"
Date: Tue, 1 Nov 2011 15:43:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
        Curt Wohlgemuth <curtw@google.com>, Michael Rubin <mrubin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Tang Feng <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: writeback tree status (for 3.2 merge window)
Message-ID: <20111101074347.GA23644@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are 3 patchsets sitting in the writeback tree.

        1) IO-less dirty throttling v12
        https://github.com/fengguang/linux/commits/dirty-throttling-v12

        2) writeback reasons tracing from Curt Wohlgemuth
        https://github.com/fengguang/linux/commits/writeback-reason

        3) writeback queuing changes from Jan Kara and me
        https://github.com/fengguang/linux/commits/requeue-io-wait

They have been merged into this branch testing in linux-next for a while:

https://github.com/fengguang/linux/commits/writeback-for-next

Since (3) still has an unresolved issue (detailed in the below
links), it looks better to hold it back for this merge window.

http://permalink.gmane.org/gmane.linux.kernel/1206315
http://permalink.gmane.org/gmane.linux.kernel/1206316

The patches from (1,2) together with 2 tracing patches essential for
debugging (1) have been pushed to the "writeback-for-linus" branch:

        http://git.kernel.org/?p=linux/kernel/git/wfg/linux.git;a=shortlog;h=refs/heads/writeback-for-linus

If no objections, I'll send a pull request to Linus soon.

Thanks,
Fengguang
