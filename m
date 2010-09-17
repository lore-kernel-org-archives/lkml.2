Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0IQREN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:04:13 -0400
Received: from kroah.org ([198.145.64.141]:43394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0IQREJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:04:09 -0400
Date: Fri, 17 Sep 2010 10:01:33 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ian Kent <raven@themaw.net>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, autofs@linux.kernel.org
Subject: Re: [PATCH 04/12] BKL: Remove BKL from autofs4
Message-ID: <20100917170133.GA13570@kroah.com>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
 <201009161955.48854.arnd@arndb.de>
 <1284687191.3083.8.camel@localhost>
 <201009170917.29522.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009170917.29522.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 09:17:29AM +0200, Arnd Bergmann wrote:
> On Friday 17 September 2010 03:33:11 Ian Kent wrote:
> > On Thu, 2010-09-16 at 19:55 +0200, Arnd Bergmann wrote:
> > > Ah, sorry about this. I looked at the wrong MAINTAINERS entry.
> > > 
> > > I also forgot to Cc you about autofs3, adding more to the confusion. ;)
> > > 
> > > Do you think the time has come to move autofs3 to drivers/staging
> > > as we deprecate the BKL?
> > 
> > Umm ... what's this process, the drivers/staging?
> 
> We use drivers/staging now both for getting code into the kernel
> and for getting it out of there. Moving autofs3 to drivers/staging/autofs/
> would serve as a last warning to everyone using it, but users could
> still use it while it's there. If anyone is interested, they can submit
> fixes (BKL removal and whatever else is needed) to get it back into
> the mainline. If it doesn't happen, Greg would finally remove it two
> kernel releases later.
> 
> My hope is that we can move all modules that still use the BKL after
> 2.6.37 to drivers/staging, unless we have someone already working
> on the patches.

That sounds fine with me, send me patches whenever you want to and I
will gladly take them.

thanks,

greg k-h
