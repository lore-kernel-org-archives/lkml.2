Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683Ab2CAKf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:35:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:28777 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030531Ab2CAKf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:35:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113232124"
Date: Thu, 1 Mar 2012 18:30:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] mm: dont set __GFP_WRITE on ramfs/sysfs writes
Message-ID: <20120301103014.GA12705@localhost>
References: <20120228140022.614718843@intel.com>
 <20120228144747.440418051@intel.com>
 <20120301101354.GD1665@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301101354.GD1665@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 11:13:54AM +0100, Johannes Weiner wrote:
> On Tue, Feb 28, 2012 at 10:00:30PM +0800, Fengguang Wu wrote:
> > Try to avoid page reclaim waits when writing to ramfs/sysfs etc.
> > 
> > Maybe not a big deal...
> 
> This looks like a separate fix that would make sense standalone.  It's
> not just the waits, there is not much of a point in skipping zones
> during allocation based on the dirty usage which they'll never
> contribute to.  Could you maybe pull this up front?

OK, thanks!

> > CC: Johannes Weiner <jweiner@redhat.com>
> > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
