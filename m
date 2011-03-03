Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab1CCUu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:50:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665Ab1CCUu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:50:27 -0500
Date: Thu, 3 Mar 2011 15:48:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/27] IO-less dirty throttling v6
Message-ID: <20110303204827.GJ16720@redhat.com>
References: <20110303064505.718671603@intel.com>
 <20110303201226.GI16720@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303201226.GI16720@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 03:12:26PM -0500, Vivek Goyal wrote:
> On Thu, Mar 03, 2011 at 02:45:05PM +0800, Wu Fengguang wrote:
> 
> [..]
> > - serve as simple IO controllers: if provide an interface for the user
> >   to set task_bw directly (by returning the user specified value
> >   directly at the beginning of dirty_throttle_bandwidth(), plus always
> >   throttle such tasks even under the background dirty threshold), we get
> >   a bandwidth based per-task async write IO controller; let the user
> >   scale up/down the @priority parameter in dirty_throttle_bandwidth(),
> >   we get a priority based IO controller. It's possible to extend the
> >   capabilities to the scope of cgroup, too.
> > 
> 
> Hi Fengguang,
> 
> Above simple IO controller capabilities sound interesting and I was
> looking at the patch to figure out the details. 
> 
> You seem to be mentioning that user can explicitly set the upper rate
> limit per task for async IO. Can't really figure that out where is the
> interface for setting such upper limits. Can you please point me to that.

Never mind. Jeff moyer pointed out that you mentioned above as possible
future enhancements on top of this patchset.

Thanks
Vivek
