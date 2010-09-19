Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab0ISFqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 01:46:13 -0400
Received: from 1wt.eu ([62.212.114.60]:45099 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab0ISFqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 01:46:12 -0400
Date: Sun, 19 Sep 2010 07:45:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>
Subject: Re: [Stable-review] [000/123] 2.6.32.22-stable review
Message-ID: <20100919054520.GB15598@1wt.eu>
References: <20100918190024.GA14388@kroah.com> <20100918213930.GD11678@1wt.eu> <20100919040008.GA30907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100919040008.GA30907@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 09:00:08PM -0700, Greg KH wrote:
> On Sat, Sep 18, 2010 at 11:39:30PM +0200, Willy Tarreau wrote:
> > Hi Greg,
> > 
> > On Sat, Sep 18, 2010 at 12:00:24PM -0700, Greg KH wrote:
> > > [Note, I do still have patches that people have sent me for inclusion in
> > > the .32-stable tree in my queue, but I figured this series was already
> > > big enough that it should go out now.  If you notice, I _did_ apply all
> > > patches that went through Linus's tree with a stable@kernel.org marking
> > > on it, so people might consider using that method instead...]
> > 
> > I'll give this a try, however I really miss the tcp_collapse() fix
> > (baff42ab1494528907bf4d5870359e31711746ae) without which 2.6.32.21 panics
> > several times a day when using splice().
> > 
> > I don't know if Davem had time to forward it to you though.
> 
> He has not done so yet.  I think this is a big enough series for now
> this releaase :)

Yes, I certainly share your concerns with the size of the release. I
just wanted to ensure we don't delay that fix too much because it's
always very embarrassing to have a userland triggerable panic. I've
seen David's mail so I assume we'll have that in .23 which is fine.

Thanks,
Willy

