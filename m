Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0LPPi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:38:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab0LPPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:38:27 -0500
Date: Thu, 16 Dec 2010 10:38:26 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 3/3] xfs: demultiplex xfs_icsb_modify_counters()
Message-ID: <20101216153826.GB24185@infradead.org>
References: <1292203313-15570-1-git-send-email-david@fromorbit.com>
 <1292203313-15570-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292203313-15570-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:21:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the conversion to percpu counters, xfs_icsb_modify_counters() really does
> not need to exist. Convert the inode counter modifications to use a common
> helper function for the one place that calls them, and add another function for
> the free block modification and convert all the callers to use that.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
