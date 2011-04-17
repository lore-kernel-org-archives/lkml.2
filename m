Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1DQJbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 05:31:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:59142 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1DQJax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 05:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,226,1301900400"; 
   d="scan'208";a="420676960"
Date: Sun, 17 Apr 2011 17:30:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] IO-less dirty throttling v7
Message-ID: <20110417093048.GA4027@localhost>
References: <20110416132546.765212221@intel.com>
 <4DAA976A.3080007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAA976A.3080007@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 03:31:54PM +0800, Marco Stornelli wrote:
> Il 16/04/2011 15:25, Wu Fengguang ha scritto:
> > Andrew,
> >
> > This revision undergoes a number of simplifications, cleanups and fixes.
> > Independent patches are separated out. The core patches (07, 08) now have
> > easier to understand changelog. Detailed rationals can be found in patch 08.
> >
> > In response to the complexity complaints, an introduction document is
> > written explaining the rationals, algorithm and visual case studies:
> >
> > http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/slides/smooth-dirty-throttling.pdf
> 
> It'd be great if you wrote a summary in the kernel documentation.

Perhaps not in this stage. That will only frighten people away I'm
afraid. The main concerns now are "why the complexities?". People at
this time perhaps won't bother looking into any lengthy documents at
all.

The slides with both description text and graphs should be much easier
for the readers to establish good feelings and understandings, as well
as trust. Seeing is believing, when you see 80ms vs. 30s pause times
in the bumpy NFS workload (pages 29, 30), fast rampup when suddenly
starting 10 or 100 dd tasks (pages 38, 32), and 5ms pause time in
stable workload (page 20), don't you feel the graphs much more
striking than boring texts? :)

That said, the changelog in patches 07 and 08 do offer some text based
introductions, if you are interested in reading more.

Thanks,
Fengguang
