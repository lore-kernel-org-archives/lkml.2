Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0JHOJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:09:25 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:58977 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752417Ab0JHOJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:09:24 -0400
Date: Sat, 9 Oct 2010 01:09:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Message-ID: <20101008140920.GG4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
 <20101008093202.GX19804@ZenIV.linux.org.uk>
 <20101008101549.GC4681@dastard>
 <20101008135303.GA15316@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008135303.GA15316@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 09:53:04AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 09:15:49PM +1100, Dave Chinner wrote:
> > > You are overdoing the information hiding here; _way_ too many small
> > > functions that don't buy you anything so far, AFAICS.
> > 
> > See akpm's comments on the previous version of the series.
> 
> It's one persons opinion.  I tend to disagree with lots of it.  iref
> is a good new helper for filesystems to use, but for the unlocked
> read it's reather pointless.  iref_locked is even more pointless -
> it's only used in core fs code (fs/inode.c, fs/fs-writeback.c,
> fs/drop_caches.c, fs/notify/inode_mark.c and fs/quota/dquot.c) and
> an opencoded increment would be a lot more readable.

I don't care one way or the other and certainly not enough to argue
about it. I'll change the code to match whatever is decreed as the
Right Way To Do Stuff.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
