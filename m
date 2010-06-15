Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0FOHqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:46:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36586 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0FOHqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:46:46 -0400
Date: Tue, 15 Jun 2010 09:46:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       xfs@oss.sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [16/23] XFS: Fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100615074641.GF6727@basil.fritz.box>
References: <20100610110.764742110@firstfloor.org> <20100610111052.3DDC5B1A2B@basil.firstfloor.org> <20100614042700.GC6590@dastard> <20100614074309.GA17092@basil.fritz.box> <20100614133755.GE6590@dastard> <20100614143720.GI17092@basil.fritz.box> <20100614222458.GF6590@dastard> <20100615070244.GD6727@basil.fritz.box> <20100615074028.GA15322@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615074028.GA15322@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 03:40:28AM -0400, Christoph Hellwig wrote:
> On Tue, Jun 15, 2010 at 09:02:45AM +0200, Andi Kleen wrote:
> > I suspect you miss quite a lot of valuable information from
> > your user base by not supporting kerneloops.org. On the other
> > hand it would likely also save you from spending time on 
> > flakes.
> > 
> > That said you don't need BUG_ON to support it (WARN etc. work
> > too), it's just the easiest way.
> 
> Note that a XFS filesystem shutdown already gives a stack trace.
> But picking up every filesystem shutdown on kerneloops.org seems
> to be quite a bit too much.  It's usually due to IO errors from
> the underlying device.

Yes, but known race check asserts should be probably there, right?
Maybe you need a special kind of ASSERT (or shutdown) for those? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
