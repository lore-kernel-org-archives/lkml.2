Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab2FUHN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:13:26 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48788
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab2FUHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:13:25 -0400
Date: Thu, 21 Jun 2012 03:13:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Engelhardt <jengelh@inai.de>,
        xfs@oss.sgi.com, joe@perches.com, bpm@sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120621071319.GC5106@infradead.org>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
 <20120620075216.GA24798@infradead.org>
 <20120620230232.GN30705@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620230232.GN30705@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 09:02:32AM +1000, Dave Chinner wrote:
> On Wed, Jun 20, 2012 at 03:52:16AM -0400, Christoph Hellwig wrote:
> > I'd really like to get Jans type cleanups in XFS in for the next
> > merge window.  Given the lack of feedback on lkml in favor or
> > against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
> > and then do another push to propagate them to kernel-wide types later.
> > 
> > Is that fine with everybody?
> 
> I'd just push it into the XFS tree and into linux-next. It's a
> relatively harmless set of changes, and if nobody cares enough about
> it except us, just push it and see what happens when people start
> noticing the conflicts it might cause....

Given that's it's been out on lkml for a while that sounds at least
okay-ish.  I just fear we might get dragged into a long discussion when
then pull request is sent.  Just adding the types locally and moving
them to types.h in a single patch avoids that.

