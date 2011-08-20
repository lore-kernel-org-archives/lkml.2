Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1HTTd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:33:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1HTTd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:33:57 -0400
Date: Sat, 20 Aug 2011 20:33:52 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-ID: <20110820193351.GA8349@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
 <20110818165420.0a7aabb5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110818165420.0a7aabb5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 04:54:20PM -0700, Andrew Morton wrote:
> On Wed, 10 Aug 2011 11:47:13 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > The new problem is that
> > reclaim has very little control over how long before a page in a
> > particular zone or container is cleaned which is discussed later.
> 
> Confused - where was this discussed?  Please tell us more about
> this problem and how it was addressed.
> 

I'm currently on holiday. I am only online checking train timetables.
I'll be back online properly on August 30th.
