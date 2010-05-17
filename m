Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0EQPeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:34:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab0EQPeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:34:11 -0400
Date: Mon, 17 May 2010 08:30:55 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Message-ID: <20100517153055.GA28137@suse.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
 <20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 02:41:30PM +0100, Alan Cox wrote:
> On Sat, 15 May 2010 22:59:46 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > This is the third attempt to get the BKL out of the
> > TTY code. This version goes much further than the
> > previous one, and eliminates most of the code I
> > had introduced there.
> 
> At this point I think the only way to make further progress is to
> actually push this stuff into the kernel on top of the BKL removal
> patches for the drivers and see what happens. Something will no doubt
> break but we can try and nail them in time or if not revert the series
> and try again next kernel.
> 
> The big nasty remaining after this is drivers/serial, which probably
> wants some serious reconstructive surgery to use kfifo etc. Either way
> its an independent problem to the stuff this lot tackles.
> 
> So this series
> 
> Acked-by: Alan Cox <alan@linux.intel.com>

I'd prefer to do this for .36, not for .35.  Arnd, I'll be glad to queue
these patches up to the tty development tree after .35-rc1 is out, so it
gets lots of testing in the linux-next tree, is that ok?  If so, can you
resend them to me at that time?

thanks,

greg k-h
