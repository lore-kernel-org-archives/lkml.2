Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1G0EM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 00:12:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1G0EMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 00:12:53 -0400
Date: Tue, 26 Jul 2011 21:07:55 -0700
From: Greg KH <gregkh@suse.de>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [GIT PATCH] TTY/serial driver patches for 3.1
Message-ID: <20110727040755.GA11308@suse.de>
References: <20110726050225.GA2529@kroah.com>
 <CAOZdJXWuRLSZVof1q51yTmk1FXFR28mb9qSYcbChC8KC2awn=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOZdJXWuRLSZVof1q51yTmk1FXFR28mb9qSYcbChC8KC2awn=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 03:05:17PM +0000, Tabi Timur-B04825 wrote:
> On Tue, Jul 26, 2011 at 12:02 AM, Greg KH <gregkh@suse.de> wrote:
> > Here is the big tty/serial patchset for your 3.1 tree.
> >
> > Nothing major at all, lots of line discipline tweaks for the newer ones
> > that were added last release, and some small tty core fixes as well.
> 
> Greg,
> 
> I hate to be a pest, but you didn't include my patch, "[v3]
> tty/powerpc: introduce the ePAPR embedded hypervisor byte channel
> driver".  The other six patches of that patchset are already in Linus'
> tree, so I'd really like to get this one into 3.1 as well.  You even
> tried to apply v2 to tty-next about three weeks ago, but it didn't
> apply so I immediately posted v3.

It is in my queue to review after -rc1 is out.

thanks,

greg k-h
