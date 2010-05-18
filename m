Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0ERE1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:27:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:57112 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab0ERE1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:27:14 -0400
Date: Mon, 17 May 2010 21:27:52 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Message-ID: <20100518042752.GA20470@suse.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <20100517144130.1d8aa313@lxorguk.ukuu.org.uk> <20100517153055.GA28137@suse.de> <201005172030.23741.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005172030.23741.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 08:30:23PM +0200, Arnd Bergmann wrote:
> On Monday 17 May 2010, Greg KH wrote:
> > 
> > I'd prefer to do this for .36, not for .35.  Arnd, I'll be glad to queue
> > these patches up to the tty development tree after .35-rc1 is out, so it
> > gets lots of testing in the linux-next tree, is that ok?  If so, can you
> > resend them to me at that time?
> 
> Ok, I'll make sure it still works with .35-rc1 when it's out and add
> Alan's ACK, then send a you a pull request. Did you already merge the
> series from Alan that this is based on, or do you want those patches
> to wait as well? They are in my git tree, so they will be included
> in my pull request if they are not in -rc1.

No, I do not have his patches anywhere, as I didn't expect that they
were being sent to me to apply :)

> Also, it would be nice if you could merge the first patch of my
> series, which should be completely harmless (it just renames
> function calls) but having it upstream means that we can
> keep the remaining patches that are required for BKL-less
> kernels a lot smaller.

Can you resend this patch to me so that I can include it?

thanks,

greg k-h
