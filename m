Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1ATUXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:23:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab1ATUXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:23:18 -0500
Date: Thu, 20 Jan 2011 12:23:03 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY/serial driver movement for .38
Message-ID: <20110120202303.GA25385@suse.de>
References: <20110120174910.GA30124@kroah.com>
 <201101201932.51560.arnd@arndb.de>
 <20110120194510.5a5a0d23@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120194510.5a5a0d23@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:45:10PM +0000, Alan Cox wrote:
> > I noticed that this moves the majority of all the tty drivers, but not
> > the serial drivers from the drivers/char directory as my original patch
> > series did. Is that something you still plan to do, or would you like
> > me to respin that part of my patches for the next merge window?
> 
> Please keep the drivers/char ones in another directory. The "serial"
> directory is those using the serial_core, plus a pair of old m68k things
> that want deleting anyway.
> 
> How about drivers/tty/misc for the char ones ?

That's fine with me.  I'll do the movement in a few weeks.

thanks,

greg k-h
