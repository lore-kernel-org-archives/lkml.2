Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0JSRSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:18:40 -0400
Received: from relais.videotron.ca ([24.201.245.36]:48386 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JSRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:18:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 19 Oct 2010 13:18:38 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1287507806.10071.16.camel@c-dwalke-linux.qualcomm.com>
Message-id: <alpine.LFD.2.00.1010191314020.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.1010181833440.2764@xanadu.home>
 <1287442418.5376.38.camel@Joe-Laptop> <201010191518.04147.arnd@arndb.de>
 <1287507806.10071.16.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Daniel Walker wrote:

> On Tue, 2010-10-19 at 15:18 +0200, Arnd Bergmann wrote:
> > On Tuesday 19 October 2010, Joe Perches wrote:
> > > This could have been done:
> > > 
> > > $ git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl --nogit | wc -l
> > > 35
> > > 
> > > Even then, using 35 CCs is generally silly.
> > > 
> > > It might make some sense for a cover letter and a
> > > patch series where the series made tree-wide changes
> > > in multiple directories.
> > 
> > Probably not even then: When a single mail header gets too long, you usually land
> > in some spam filter and get hate mail from the list owners. The lkml limit is 1024
> > characters (this may come from an official RFC, don't know), which is usually less
> > than 35 recipients.
> 
> Patches just shouldn't be this large. You want smaller patches for a lot
> of reason. Take the BKL, would it have been acceptable to make all the
> BKL changes in a single patch (and what would the CC have looked like)?
> If you do anything remotely sophisticated then , from my perspective, a
> tree wide patch just isn't going to work.

That's why on occasions we do transgress the established process to 
accommodate such changes.  Imagine just for a moment the patch that 
modified the interrupt callback prototype to remove the useless pt_regs 
argument.  Obviously, it had to be done atomically to the _whole_ tree, 
and it was agreed that this patch was to be applied at the end of the 
merge window.  But no one expected a single minute sending a CC to _all_ 
the driver authors.


Nicolas
