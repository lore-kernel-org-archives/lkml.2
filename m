Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1LVXiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:38:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab1LVXis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:38:48 -0500
Date: Thu, 22 Dec 2011 15:38:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
        x86@kernel.org
Subject: Re: linux-next: Tree for Dec 21
Message-ID: <20111222233843.GR17084@google.com>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
 <20111221151503.4d78f94f.akpm@linux-foundation.org>
 <20111222150836.af172886.akpm@linux-foundation.org>
 <20111222232036.GP17084@google.com>
 <20111222152427.c944c747.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222152427.c944c747.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 03:24:27PM -0800, Andrew Morton wrote:
> > Hmmm... probably cic allocation failure?
> 
> Dunno, it's an 8Gb 8 CPU x86_64 box.
> 
> >  It's just that those cases happened infrequently
> > enough that nobody really noticed (or at least tracked it down).  How
> > can you reproduce the problem?
> 
> Easily.  One time it got to a login prompt and hung quickly during a
> make.  Every other time (ten times, maybe) it hung during initscripts.

Weird, I can't reproduce the problem on block/for-3.3/core.  Trying
linux-next... hmmm, it works there too.  Can you please share .config?

Thanks.

-- 
tejun
