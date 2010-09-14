Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0INC4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:56:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42610 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0INC4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:56:46 -0400
Date: Mon, 13 Sep 2010 20:56:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>, qi.wang@intel.com,
        yong.y.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, gregkh@suse.de,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Message-ID: <20100914025643.GA15022@angua.secretlab.ca>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com>
 <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
 <20100910045558.GA8436@angua.secretlab.ca>
 <003001cb53b7$e118ca90$65f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003001cb53b7$e118ca90$65f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 11:52:30AM +0900, Tomoya MORINAGA wrote:
> ----- Original Message ----- 
> From: "Grant Likely" <grant.likely@secretlab.ca>
> To: "Linus Walleij" <linus.ml.walleij@gmail.com>
> Cc: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>; <meego-dev@meego.com>;
> "LKML" <linux-kernel@vger.kernel.org>; "David Brownell"
> <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>;
> <yong.y.wang@intel.com>; <andrew.chih.howe.khor@intel.com>;
> <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
> <morinaga526@dsn.okisemi.com>; "Thomas Gleixner" <tglx@linutronix.de>;
> "David Woodhouse" <dwmw2@infradead.org>
> Sent: Friday, September 10, 2010 1:55 PM
> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
> 
> 
> > On Thu, Sep 09, 2010 at 10:58:38PM +0200, Linus Walleij wrote:
> > > 2010/9/3 Masayuki Ohtake <masa-korg@dsn.okisemi.com>:
> > >
> > > > Each instance of our SPI device has the same vendor ID and device ID.
> > > > Thus, I think it is impossible to be called probe() for each instance.
> > >
> > > Looking at you latest patch it appears you could :-)
> > > That solves the problem pretty nicely.
> >
> > Actually, it doesn't look like he did.  It looks to me that the
> > ability to support multiple spi bus instances on a single PCI device
> > has simply been removed.  I don't know if that is because it simply
> > isn't needed yet, or if it is because Ohtake-san doesn't quite
> > understand what were suggesting.
> 
> We wanted you to accept multi-instance the SPI patch.
> But seeing maintainer's comments, I felt it is difficult to be accepted.
> Thus, I have deleted whole of multi-instance code.
> 

I've got no problem with the driver supporting multiple instances.  My
comment is simply that it should be implemented in a different way.
But it isn't a big deal.  Multi-instance can be added back into the
driver after the single-instance version is merged.

g.

