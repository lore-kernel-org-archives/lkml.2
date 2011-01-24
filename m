Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1AXVNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:13:39 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15856 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1AXVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:13:38 -0500
Date: Mon, 24 Jan 2011 22:14:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Chris Ball <cjb@laptop.org>
cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>, Axel Lin <axel.lin@gmail.com>,
        trivial@kernel.org
Subject: Re: [PATCH] MMC, USHC: Don't double include usb.h in ushc.c
In-Reply-To: <20110124210645.GB11110@void.printf.net>
Message-ID: <alpine.LNX.2.00.1101242213350.10252@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101242156050.10252@swampdragon.chaosbits.net> <20110124210202.GA11110@void.printf.net> <alpine.LNX.2.00.1101242204020.10252@swampdragon.chaosbits.net> <20110124210645.GB11110@void.printf.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Chris Ball wrote:

> Hi,
> 
> On Mon, Jan 24, 2011 at 10:05:05PM +0100, Jesper Juhl wrote:
> > > I've already replied to you ACKing this patch, and pushed it to mmc-next. 
> > > 
> > Odd, I don't see that in my mailbox :-( But then I've had a few incidents 
> > of being bling in that regard lately, so it's probably my fault. Sorry.
> 
> It's okay.  Here's an archive of the thread:
>   https://patchwork.kernel.org/patch/469621/
> 
Argh, reading it again I clearly remember that mail exchange. Must have 
deleted it from my mailbox by accident. 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

