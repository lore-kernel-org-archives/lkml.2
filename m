Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0GTXMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:12:12 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:44794 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933030Ab0GTXMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:12:10 -0400
Date: Wed, 21 Jul 2010 09:12:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alex Elder <aelder@sgi.com>
Cc: Kulikov Vasiliy <segooon@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
Message-ID: <20100720231201.GQ32635@dastard>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
 <20100715212116.GA7013@infradead.org>
 <1279654533.1859.242.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279654533.1859.242.camel@doink>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 02:35:33PM -0500, Alex Elder wrote:
> On Thu, 2010-07-15 at 17:21 -0400, Christoph Hellwig wrote:
> > On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> > > map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> > > below zero. So, check exact expression instead of map_len.
> > > 
> > > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > 
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Looks good to me too.  Do you want me to pull this
> in via the XFS tree, or do you have other plans?

Already got it, Alex.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
