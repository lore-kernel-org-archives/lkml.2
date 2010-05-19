Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0ESCGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:06:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab0ESCGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:06:21 -0400
Date: Tue, 18 May 2010 18:50:36 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Message-ID: <20100519015036.GA22900@suse.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201005172030.23741.arnd@arndb.de> <20100518042752.GA20470@suse.de> <201005182352.01711.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005182352.01711.arnd@arndb.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 11:52:01PM +0200, Arnd Bergmann wrote:
> > 
> > Can you resend this patch to me so that I can include it?
> 
> I think we should only merge this patch if you also want to
> take the patches from Alan mentioned above, otherwise it would
> cause more trouble to rebase everything than we can gain from
> merging it now.

Then I'll just wait, is that ok?

> If this makes sense to you, please pull
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git tty-for-2.6.35
> 
> This contains all of Alan's patches, plus the first one of my
> series on top of that.

I'll wait for you all to redo this and resend it to me for the .36
kernel.

Oh, and I really don't like to have a git pull, can you just email me
the patches?

thanks,

greg k-h
