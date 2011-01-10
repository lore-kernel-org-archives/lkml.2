Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1AJVjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:39:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:43304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1AJVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:39:31 -0500
Date: Mon, 10 Jan 2011 22:39:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Ball <cjb@laptop.org>
Cc: Jesper Juhl <jj@chaosbits.net>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>, David Vrabel <david.vrabel@csr.com>
Subject: Re: [PATCH] USB SD Host Controller: Including usb.h once is enough
In-Reply-To: <20110110213735.GA6509@void.printf.net>
Message-ID: <alpine.LNX.2.00.1101102239030.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net> <20110110210509.GD31011@pengutronix.de> <alpine.LNX.2.00.1101102214500.32164@swampdragon.chaosbits.net> <20110110213735.GA6509@void.printf.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Chris Ball wrote:

> Hi Jesper,
> 
> On Mon, Jan 10, 2011 at 10:19:11PM +0100, Jesper Juhl wrote:
> > > On Mon, Jan 10, 2011 at 09:56:08PM +0100, Jesper Juhl wrote:
> > > > 
> > > > Including usb.h once is enough in drivers/mmc/host/ushc.c
> > > > This removes the duplicate.
> > > > 
> > > > 
> > > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Thanks, queued for .38.

Perfect, dropped from my queue, thanks Chris.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
