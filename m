Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1ATSta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:49:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:44980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab1ATSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:49:29 -0500
Date: Thu, 20 Jan 2011 10:48:38 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial driver movement for .38
Message-ID: <20110120184838.GA31717@suse.de>
References: <20110120174910.GA30124@kroah.com>
 <201101201932.51560.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101201932.51560.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:32:51PM +0100, Arnd Bergmann wrote:
> On Thursday 20 January 2011 18:49:10 Greg KH wrote:
> > As mentioned before in previous TTY git pull for .38, here's the big
> > movement of the serial drivers into the drivers/tty/ subdirectory that
> > needed to wait until after .38-rc1 was out.
> > 
> > It merely moves the hvc drivers to drivers/tty/hvc/ and the
> > drivers/serial/ directory to drivers/tty/serial/ and fixes up the
> > MAINTAINERS file to point to the proper locations of the files now that
> > they have been moved.
> 
> Hi Greg,
> 
> Thanks for following up on this!
> 
> I noticed that this moves the majority of all the tty drivers, but not
> the serial drivers from the drivers/char directory as my original patch
> series did. Is that something you still plan to do, or would you like
> me to respin that part of my patches for the next merge window?

I was going to do that for the next set of patches, for .39.  I will be
moving some of the drivers into the staging tree as well, as was
discussed.  I figured it was better to move things slower, making merges
from other trees easier, than to do it in all one big jump.

I still have your original patch series here which is what I am working
off of, so don't worry, it's not forgotten :)

thanks,

greg k-h
