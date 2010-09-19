Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab0ISEU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:20:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab0ISEU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:20:56 -0400
Date: Sat, 18 Sep 2010 21:00:08 -0700
From: Greg KH <gregkh@suse.de>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>
Subject: Re: [Stable-review] [000/123] 2.6.32.22-stable review
Message-ID: <20100919040008.GA30907@suse.de>
References: <20100918190024.GA14388@kroah.com> <20100918213930.GD11678@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100918213930.GD11678@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 11:39:30PM +0200, Willy Tarreau wrote:
> Hi Greg,
> 
> On Sat, Sep 18, 2010 at 12:00:24PM -0700, Greg KH wrote:
> > [Note, I do still have patches that people have sent me for inclusion in
> > the .32-stable tree in my queue, but I figured this series was already
> > big enough that it should go out now.  If you notice, I _did_ apply all
> > patches that went through Linus's tree with a stable@kernel.org marking
> > on it, so people might consider using that method instead...]
> 
> I'll give this a try, however I really miss the tcp_collapse() fix
> (baff42ab1494528907bf4d5870359e31711746ae) without which 2.6.32.21 panics
> several times a day when using splice().
> 
> I don't know if Davem had time to forward it to you though.

He has not done so yet.  I think this is a big enough series for now
this releaase :)

thanks,

greg k-h
