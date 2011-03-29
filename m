Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1C2B5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 21:57:32 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47740 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550Ab1C2B5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 21:57:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMEAJY5kU15LK5JgWdsb2JhbAClSBUBARYmJcUjDYVdBA
Date: Tue, 29 Mar 2011 12:57:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: Very aggressive memory reclaim
Message-ID: <20110329015727.GE3008@dastard>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
 <20110328215344.GC3008@dastard>
 <m2bp0u23wl.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2bp0u23wl.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 04:58:50PM -0700, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> >
> > First it would be useful to determine why the VM is reclaiming so
> > much memory. If it is somewhat predictable when the excessive
> > reclaim is going to happen, it might be worth capturing an event
> 
> Often it's to get pages of a higher order. Just tracing alloc_pages
> should tell you that.

Yes, the kmem/mm_page_alloc tracepoint gives us that. But in case
that is not the cause, grabbing all the trace points I suggested is
more likely to indicate where the problem is. I'd prefer to get more
data than needed the first time around than have to do multiple
round trips because a single trace point doesn't tell us the cause...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
