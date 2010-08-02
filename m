Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0HBIO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:14:28 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:52195 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab0HBIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:14:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADYaVkx5LclT/2dsb2JhbACgDXK/BoU5BA
Date: Mon, 2 Aug 2010 18:14:22 +1000
From: Nick Piggin <npiggin@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nick Piggin <npiggin@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Linux 2.6.35
Message-ID: <20100802081422.GA8892@amd>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802103204.3d1b2863.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802103204.3d1b2863.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 10:32:04AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Sun, 1 Aug 2010 16:52:42 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > On a slightly happier note: one thing I do hope we can merge in the
> > upcoming merge window is Nick Piggin's cool VFS scalability series.
> > I've been using it on my own machine, and gone through all the commits
> > (not that I shouldn't go through some of them some more), and am
> > personally really excited about it. It's seldom we see major
> > performance improvements in core code that are quite that noticeable,
> > and Nick's whole RCU pathname lookup in particular just tickles me
> > pink.
> 
> To that end, Nick, can you please submit that tree for inclusion in
> linux-next in case there are some interactions with some of the other
> stuff there?  (or send it all to Al, instead (or both), I guess.)

Hi Stephen,

I will work something out with Al and try to have something in
linux-next ASAP.

