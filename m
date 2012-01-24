Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2AXGBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:01:25 -0500
Received: from ozlabs.org ([203.10.76.45]:35765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2AXGBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:01:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: Linux 3.3-1 out - merge window closed
In-Reply-To: <201201231518.26158.arnd@arndb.de>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com> <CADMYwHxhyExw8jzAVT6PEdfXT-vCSLxg_eGbbqCwRNh0q3Q6eQ@mail.gmail.com> <20120123131808.GC23571@ponder.secretlab.ca> <201201231518.26158.arnd@arndb.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 24 Jan 2012 11:02:00 +1030
Message-ID: <87y5sydjpb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 15:18:25 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 23 January 2012, Grant Likely wrote:
> > On Mon, Jan 23, 2012 at 11:17:46AM +0200, Ohad Ben-Cohen wrote:
> >
> > > I realize there's a slim chance to get it merged at this point, but I
> > > do think that both remoteproc and rpmsg are not so scary:
> > > 
> > > * The code is completely self contained, and the only few external
> > > places it changes amount to grabbing a new virtio id (which is
> > > Acked-by Rusty) and some OMAP init platform code (which is Acked-by
> > > Tony). People who aren't explicitly using it won't notice it's there;
> > > even its Kconfig entries get selected automatically when relevant
> > > (i.e. only on OMAP4 at this point) and would never show up otherwise.
> > 
> > Hi Linus,
> > 
> > I'd also like to see this merged.  Rather than going off and inventing
> > something completely new, Ohad has built on the existing virtio
> > infrastructure to implement IPC between CPUs and DSPs running
> > different operating environments.  This is a strong step in the
> > RightDirection(tm) in my opinion and such behaviour should be
> > encouraged.  :-)
> > 
> 
> Agreed. I had reviewed earlier versions of this and they looked very
> good.

Plus I don't think delay will help in any way; it'll just go in as-is,
one merge window later...

Thanks,
Rusty.
