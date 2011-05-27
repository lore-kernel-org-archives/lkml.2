Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab1E0A7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:59:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758668Ab1E0A7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:59:41 -0400
Date: Fri, 27 May 2011 09:00:21 +0800
From: Greg KH <gregkh@suse.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [GIT PATCH] TTY/serial driver patches for .40
Message-ID: <20110527010021.GD23506@suse.de>
References: <20110523190539.GA17519@kroah.com>
 <Pine.LNX.4.64.1105261248060.9307@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1105261248060.9307@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:54:29PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 23 May 2011, Greg KH wrote:
> 
> > Here's the big tty/serial merge for .40
> 
> /me confused: this patch
> 
> > Felipe Balbi (1):
> >       tty: make receive_buf() return the amout of bytes received
> 
> is more than one year old, which I wouldn't care about, if it didn't 
> introduce a regression on my mackerel 
> (arch/arm/mach-shmobile/board-mackerel.c) board. With it in place printing 
> a lot of text over ssh pauses the output multiple times for several 
> seconds. With this patch reverted the behaviour is back to normal. To 
> reproduce one can either cat a few largish files under /etc or just dmesg 
> - if there have been enough messages accumulated.

I think I'll be reverting this one.

thanks,

greg k-h
