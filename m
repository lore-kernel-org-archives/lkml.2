Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0KMXuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 18:50:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881Ab0KMXuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 18:50:51 -0500
Date: Sat, 13 Nov 2010 15:49:33 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lawrence Rust <lvr@softsystem.co.uk>
Subject: Re: [boot crash] Re: [GIT PATCH] TTY/serial fixes for .37-rc1
Message-ID: <20101113234933.GB1253@suse.de>
References: <20101112213215.GB9294@kroah.com> <20101113151022.GA29085@elte.hu> <20101113152131.GA2606@elte.hu> <20101113152514.GA3069@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113152514.GA3069@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 04:25:14PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > It crashed almost immediately after i merged Linus's 9457b24a0955 into -tip,
> > > we were on yesterday's f6614b7bb405 before that - so i think the crash is
> > > both pretty generic.
> > 
> > Yes, it crashes with an x86 defconfig too. Appears to be caused by:
> > 
> >  47d3904fe40d: 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang
> > 
> > It crashes any x86 serial console bootup.
> 
> The revert below makes the system boot up fine.

Thanks for this, Linus took it already.

greg k-h
