Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1AKO4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:56:49 -0500
Received: from www.tglx.de ([62.245.132.106]:52382 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1AKO4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:56:47 -0500
Date: Tue, 11 Jan 2011 15:56:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Hellstrom <daniel@gaisler.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [GIT PATCH] TTY/serial merge for .38
In-Reply-To: <4D2C6260.80403@gaisler.com>
Message-ID: <alpine.LFD.2.00.1101111554120.12146@localhost6.localdomain6>
References: <20110106215404.GA30624@kroah.com> <AANLkTi=mCKWKTcP7JVdwVkk4OVEGDNHYgb5-W+1NJmtQ@mail.gmail.com> <20110107234149.GA18421@suse.de> <4D2C6260.80403@gaisler.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Daniel Hellstrom wrote:

> Greg KH wrote:
> 
> > On Fri, Jan 07, 2011 at 02:44:14PM -0800, Linus Torvalds wrote:
> >  
> > > On Thu, Jan 6, 2011 at 1:54 PM, Greg KH <gregkh@suse.de> wrote:
> > >    
> > > > Here is the big tty and serial merge for .38.  I'll be sending another
> > > > smaller one that just moves drivers around after .38-rc1 is out, as is
> > > > the norm for file moves to handle issues with other trees syncing up
> > > > properly.
> > > >      
> > > Merged. However, the drivers/serial/apbuart.c file conflicted, and
> > > both sides of the merge had some insanity in them.
> > > 
> > > So I did an "evil merge" - a merge that actually changed the code to
> > > match neither side - and it looks better to me. But maybe that's just
> > > the drugs I'm taking talking.
> > > 
> > > So people should check it out. In particular, look at the interaction
> > > of "drivers: serial: apbuart: Handle OF failures gracefully" and the
> > > "Added support for ampopts in APBUART driver. Used in AMP systems"
> > > commit.

Looks good.

Thanks,

	tglx
