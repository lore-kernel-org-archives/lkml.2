Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1GMPbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:31:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab1GMPbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:31:35 -0400
Date: Wed, 13 Jul 2011 16:31:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 0/5] Reduce filesystem writeback from page reclaim
 (again)
Message-ID: <20110713153130.GH7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1310567487-15367-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 03:31:22PM +0100, Mel Gorman wrote:
> <SNIP>
> The objective of the series - reducing writes from reclaim - is
> met with filesystem writes from reclaim reduced to 0 with reclaim
> in general doing less work. ext3, ext4 and xfs all showed marked
> improvements for fs_mark in this configuration. btrfs looked worse
> but it's within the noise and I'd expect the patches to have little
> or no impact there due it ignoring ->writepage from reclaim.
> 

My bad, I accidentally looked at an old report for btrfs based on
older patches. In the report posted with all patches applied, the
performance of btrfs does look better but as the patches should make
no difference, it's still in the noise.

-- 
Mel Gorman
SUSE Labs
