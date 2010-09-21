Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0IUBz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:55:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45335 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0IUBz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:55:27 -0400
Date: Tue, 21 Sep 2010 02:55:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36-rc5
Message-ID: <20100921015525.GH31363@ZenIV.linux.org.uk>
References: <AANLkTinPnUmRsYZ7pxBP4Jv9FNpiei2YxZG=0JrBi=Ft@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinPnUmRsYZ7pxBP4Jv9FNpiei2YxZG=0JrBi=Ft@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 05:24:29PM -0700, Linus Torvalds wrote:
> I should have done this yesterday, but got distracted. So here's -rc5,
> one day late - so it got some extra updates from Greg thanks to my
> procrastination.
> 
> Nothing really stands out. Except perhaps that Al has obviously been
> looking at architecture sigreturn paths, and been finding problems,

s/sigreturn/signal/ and there's more pending patches in that pile; I'd
estimate that as 30-40, unless new classes of bugs show up in that crap.
In that case all bets are off...  And yes, I'm serious - it's that badly
bitrotten.  I'm holding back the obvious cleanups (e.g. there's a bunch
of common helpers asking to be introduced); for now it's plain bugfixes
and the estimate above is just for those.  Cleanups will have to wait for
the merge window...
