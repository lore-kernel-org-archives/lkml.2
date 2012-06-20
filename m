Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2FTXCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:02:36 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17495 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757506Ab2FTXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:02:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKANVV4k95LOQs/2dsb2JhbABFtCQDgS+BCIIYAQEFOhwjEAgDDgouFCUDIROICrodFIsagRGFCgOVKYknhluCcQ
Date: Thu, 21 Jun 2012 09:02:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Engelhardt <jengelh@inai.de>, xfs@oss.sgi.com, joe@perches.com,
        bpm@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120620230232.GN30705@dastard>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
 <20120620075216.GA24798@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620075216.GA24798@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 03:52:16AM -0400, Christoph Hellwig wrote:
> I'd really like to get Jans type cleanups in XFS in for the next
> merge window.  Given the lack of feedback on lkml in favor or
> against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
> and then do another push to propagate them to kernel-wide types later.
> 
> Is that fine with everybody?

I'd just push it into the XFS tree and into linux-next. It's a
relatively harmless set of changes, and if nobody cares enough about
it except us, just push it and see what happens when people start
noticing the conflicts it might cause....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
