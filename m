Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2AIU7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:59:13 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31267 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605Ab2AIU7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:59:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJVTC095LbVq/2dsb2JhbABErFKBBoFyAQEEATocIwULCAMYLhQlAyETh3q2bxOLG2MElQeJH4kv
Date: Tue, 10 Jan 2012 07:59:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109205907.GE4198@dastard>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:30:59AM -0800, Linus Torvalds wrote:
> On Mon, Jan 9, 2012 at 9:30 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Resend would be nice; I can try to dig the series out and rebase it, but...
> 
> Here's a TOTALLY UNTESTED rebase of just that single patch from Dave.
> 
> I did not check if the rest of the series did something that this
> patch needs, so the patch may be entirely broken, but it does look
> sane on its own (ie I do not see anything obviously broken in it). So
> it still looks like a nice cleanup, but maybe I'm missing something
> subtle, and maybe the rest of Dave's series really is required.

Nothing else is required - that patch is a OK by itself as a bug
fix/cleanup.

> It compiles. That's all I'm going to say about my extensive testing.
> Which is also why I haven't added my sign-off to it.

I did quite a bit of load and stress testing on the series back when
I first posted it, so the dcache changes don't have any problems I
know of.

> Comments?

Looks OK to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
