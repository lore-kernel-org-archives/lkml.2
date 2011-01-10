Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1AJVhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:37:42 -0500
Received: from void.printf.net ([89.145.121.20]:44731 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1AJVhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:37:40 -0500
Date: Mon, 10 Jan 2011 21:37:36 +0000
From: Chris Ball <cjb@laptop.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-mmc@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>, David Vrabel <david.vrabel@csr.com>
Subject: Re: [PATCH] USB SD Host Controller: Including usb.h once is enough
Message-ID: <20110110213735.GA6509@void.printf.net>
References: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net> <20110110210509.GD31011@pengutronix.de> <alpine.LNX.2.00.1101102214500.32164@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101102214500.32164@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Mon, Jan 10, 2011 at 10:19:11PM +0100, Jesper Juhl wrote:
> > On Mon, Jan 10, 2011 at 09:56:08PM +0100, Jesper Juhl wrote:
> > > 
> > > Including usb.h once is enough in drivers/mmc/host/ushc.c
> > > This removes the duplicate.
> > > 
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, queued for .38.

> No reason.
> Didn't think of it as "newlines in the commit-msg", just as newlines 
> providing a nice seperation between patch description and the patch 
> itself. It never occurred to me that anyone would actually copy those 
> blank lines into an actual commit message.

I don't copy anything into the commit message -- I like to run git-am
on the patch mail in my mailbox directly.  In this case, git-am seems
to have removed the extra newlines itself, which was nice of it, but in
general please send mail such that from the start of the body of the
mail up to the "---" separator will become the commit message.  Thanks!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
