Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1AGXmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:42:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:40211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1AGXmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:42:01 -0500
Date: Fri, 7 Jan 2011 15:41:49 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hellstrom <daniel@gaisler.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [GIT PATCH] TTY/serial merge for .38
Message-ID: <20110107234149.GA18421@suse.de>
References: <20110106215404.GA30624@kroah.com>
 <AANLkTi=mCKWKTcP7JVdwVkk4OVEGDNHYgb5-W+1NJmtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=mCKWKTcP7JVdwVkk4OVEGDNHYgb5-W+1NJmtQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:44:14PM -0800, Linus Torvalds wrote:
> On Thu, Jan 6, 2011 at 1:54 PM, Greg KH <gregkh@suse.de> wrote:
> > Here is the big tty and serial merge for .38.  I'll be sending another
> > smaller one that just moves drivers around after .38-rc1 is out, as is
> > the norm for file moves to handle issues with other trees syncing up
> > properly.
> 
> Merged. However, the drivers/serial/apbuart.c file conflicted, and
> both sides of the merge had some insanity in them.
> 
> So I did an "evil merge" - a merge that actually changed the code to
> match neither side - and it looks better to me. But maybe that's just
> the drugs I'm taking talking.
> 
> So people should check it out. In particular, look at the interaction
> of "drivers: serial: apbuart: Handle OF failures gracefully" and the
> "Added support for ampopts in APBUART driver. Used in AMP systems"
> commit.

The merge looks ok to me, but I don't have this hardware, so I can't
test it.  Thomas, can you verify this is ok?

thanks,

greg k-h
