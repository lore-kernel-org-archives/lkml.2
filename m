Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1AXVGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:06:48 -0500
Received: from void.printf.net ([89.145.121.20]:52761 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1AXVGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:06:46 -0500
Date: Mon, 24 Jan 2011 21:06:45 +0000
From: Chris Ball <cjb@laptop.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@csr.com>, Axel Lin <axel.lin@gmail.com>,
        trivial@kernel.org
Subject: Re: [PATCH] MMC, USHC: Don't double include usb.h in ushc.c
Message-ID: <20110124210645.GB11110@void.printf.net>
References: <alpine.LNX.2.00.1101242156050.10252@swampdragon.chaosbits.net> <20110124210202.GA11110@void.printf.net> <alpine.LNX.2.00.1101242204020.10252@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101242204020.10252@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 24, 2011 at 10:05:05PM +0100, Jesper Juhl wrote:
> > I've already replied to you ACKing this patch, and pushed it to mmc-next. 
> > 
> Odd, I don't see that in my mailbox :-( But then I've had a few incidents 
> of being bling in that regard lately, so it's probably my fault. Sorry.

It's okay.  Here's an archive of the thread:
  https://patchwork.kernel.org/patch/469621/

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
