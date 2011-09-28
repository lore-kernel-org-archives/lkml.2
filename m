Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1I1F53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:57:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1I1F50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:57:26 -0400
Date: Wed, 28 Sep 2011 14:57:14 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@google.com>, Mel Gorman <mgorman@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2/4] mm: writeback: cleanups in preparation for
 per-zone dirty limits
Message-ID: <20110928055714.GC14561@barrios-desktop>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
 <1316526315-16801-3-git-send-email-jweiner@redhat.com>
 <20110921160226.1bf74494.akpm@google.com>
 <20110922085242.GA29046@redhat.com>
 <20110923144107.GB2606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110923144107.GB2606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 04:41:07PM +0200, Johannes Weiner wrote:
> On Thu, Sep 22, 2011 at 10:52:42AM +0200, Johannes Weiner wrote:
> > On Wed, Sep 21, 2011 at 04:02:26PM -0700, Andrew Morton wrote:
> > > Should we rename determine_dirtyable_memory() to
> > > global_dirtyable_memory(), to get some sense of its relationship with
> > > zone_dirtyable_memory()?
> > 
> > Sounds good.
> 
> ---
> 
> The next patch will introduce per-zone dirty limiting functions in
> addition to the traditional global dirty limiting.
> 
> Rename determine_dirtyable_memory() to global_dirtyable_memory()
> before adding the zone-specific version, and fix up its documentation.
> 
> Also, move the functions to determine the dirtyable memory and the
> function to calculate the dirty limit based on that together so that
> their relationship is more apparent and that they can be commented on
> as a group.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kinds regards,
Minchan Kim
