Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953Ab0HFTh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:37:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:38297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0HFThz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:37:55 -0400
Date: Fri, 6 Aug 2010 12:37:46 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
Message-ID: <20100806193746.GA2022@suse.de>
References: <20100805213528.GA13794@kroah.com>
 <AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com>
 <20100806185147.GB23853@suse.de>
 <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 08:45:52PM +0100, Alan Cox wrote:
> On Fri, 6 Aug 2010 11:51:47 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Fri, Aug 06, 2010 at 11:40:15AM -0700, Linus Torvalds wrote:
> > > 
> > > Do do the highlander thing on that crud. Cut it off at the head, and
> > > make sure it never ever comes back to life.
> > 
> > Arnd and Alan, I'll drop the BKL portion of this patch series and
> > regenerate something to get the other tty patches to Linus.
> 
> Wouldn't it make more sense to simply turn it on as Linus suggested ?

That's fine with me, and drop the option entirely?  Arnd, any objection
to that?

thanks,

greg k-h
