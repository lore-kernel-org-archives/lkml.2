Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab2BNERB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:17:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36737 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171Ab2BNERA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:17:00 -0500
X-Sasl-enc: DXCZCO2m72zKZBv5MExXQz5e2tpO5VAWmWyLRx2cyws6 1329193019
Date: Mon, 13 Feb 2012 20:05:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Staging: bcm: Don't leak 'pstAddIndication' in
 CmHost.c::StoreCmControlResponseMessage()
Message-ID: <20120214040546.GA17165@kroah.com>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net>
 <20120209175217.GA13959@kroah.com>
 <alpine.LNX.2.00.1202092329110.32491@swampdragon.chaosbits.net>
 <20120210180037.GA588@kroah.com>
 <alpine.LNX.2.00.1202120051310.7100@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202120051310.7100@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 12:54:31AM +0100, Jesper Juhl wrote:
> On Fri, 10 Feb 2012, Greg KH wrote:
> 
> > On Thu, Feb 09, 2012 at 11:33:25PM +0100, Jesper Juhl wrote:
> > > From: Jesper Juhl <jj@codesealer.com>
> > > 
> > > We allocate memory for 'pstAddIndication' with kmalloc() in
> > > drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then
> > > neglect to free it on a number of exit paths from that function.
> > > 
> > > This could probably be resolved cleaner/nicer, but this file needs a
> > > serious overhaul in any case, so I opted for just fixing the problem
> > > as directly as I could and then we can clean it up generally
> > > later... This at least makes it stop bleeding..
> > > 
> > > Signed-off-by: Jesper Juhl <jj@codesealer.com>
> > 
> > Odd, didn't I already apply this patch?
> > 
> > confused,
> > 
> 
> Well, you were the one who (in email message with Message-ID: 
> <20120209175217.GA13959@kroah.com>) said that it no longer applied and 
> asked for a resubmit against linux-next:
> 
>   "This patch no longer applies, care to redo it against the latest
>   linux-next tree?"
> 
> So I just did what you asked :-)

Yes, but...

> Whether or not you have already applied it somewhere else I have no 
> idea...

I tried to apply this, and it said it was already applied.  So either I
already merged it, or someone else made the same patch, or you created
it reverted.

I'm confused, sorry.

greg k-h
