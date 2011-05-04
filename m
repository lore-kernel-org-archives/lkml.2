Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1EDVBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:01:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1EDVBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:01:04 -0400
Date: Wed, 4 May 2011 23:00:59 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: introduce wbc.tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110504210059.GG6968@quack.suse.cz>
References: <20110502031750.135798606@intel.com>
 <20110502033035.537736600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502033035.537736600@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 02-05-11 11:17:51, Wu Fengguang wrote:
> sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> livelock prevention for it, too.
> 
> Note that writeback_inodes_sb() is called by not only sync(), they are
> treated the same because the other callers need also need livelock
> prevention.
  I was thinking about this and could not find any - which other callers
of writeback_inodes_sb() need the livelock prevention?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
