Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1AJVTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:19:15 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15125 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab1AJVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:19:12 -0500
Date: Mon, 10 Jan 2011 22:19:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: linux-mmc@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Chris Ball <cjb@laptop.org>, David Vrabel <david.vrabel@csr.com>
Subject: Re: [PATCH] USB SD Host Controller: Including usb.h once is enough
In-Reply-To: <20110110210509.GD31011@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1101102214500.32164@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net> <20110110210509.GD31011@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Wolfram Sang wrote:

> On Mon, Jan 10, 2011 at 09:56:08PM +0100, Jesper Juhl wrote:
> > 
> > Including usb.h once is enough in drivers/mmc/host/ushc.c
> > This removes the duplicate.
> > 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Correct. Why the newlines in the commit-msg?
> 
No reason.
Didn't think of it as "newlines in the commit-msg", just as newlines 
providing a nice seperation between patch description and the patch 
itself. It never occurred to me that anyone would actually copy those 
blank lines into an actual commit message.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

