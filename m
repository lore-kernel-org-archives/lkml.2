Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1HCLGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1HCLGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:06:48 -0400
Date: Wed, 3 Aug 2011 13:06:29 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803110629.GB27199@redhat.com>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
 <1311265730-5324-4-git-send-email-mgorman@suse.de>
 <20110803105819.GA27199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803105819.GA27199@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:58:19PM +0200, Johannes Weiner wrote:
> On Thu, Jul 21, 2011 at 05:28:45PM +0100, Mel Gorman wrote:
> > Direct reclaim should never writeback pages. Warn if an attempt
> > is made.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Acked-by: Johannes Weiner <jweiner@redhat.com>

Oops, too fast.

Shouldn't the WARN_ON() be at the top of the function, rather than
just warn when the write is deferred due to delalloc?
