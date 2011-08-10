Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1HJMmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:42:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1HJMmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:42:04 -0400
Date: Wed, 10 Aug 2011 14:41:47 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/7] mm: vmscan: Remove dead code related to lumpy
 reclaim waiting on pages under writeback
Message-ID: <20110810124147.GB24133@redhat.com>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
 <1312973240-32576-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312973240-32576-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:47:15AM +0100, Mel Gorman wrote:
> Lumpy reclaim worked with two passes - the first which queued pages for
> IO and the second which waited on writeback. As direct reclaim can no
> longer write pages there is some dead code. This patch removes it but
> direct reclaim will continue to wait on pages under writeback while in
> synchronous reclaim mode.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <jweiner@redhat.com>
