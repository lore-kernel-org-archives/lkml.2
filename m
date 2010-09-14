Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0INDUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:20:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:21205 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757Ab0INDUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:20:14 -0400
X-Greylist: delayed 1659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 23:20:14 EDT
Message-ID: <003001cb53b7$e118ca90$65f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>,
        "Linus Walleij" <linus.ml.walleij@gmail.com>
Cc: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>, <meego-dev@meego.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <gregkh@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
        "David Woodhouse" <dwmw2@infradead.org>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com> <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com> <20100910045558.GA8436@angua.secretlab.ca>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Tue, 14 Sep 2010 11:52:30 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1933
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1933
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Linus Walleij" <linus.ml.walleij@gmail.com>
Cc: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>; <meego-dev@meego.com>;
"LKML" <linux-kernel@vger.kernel.org>; "David Brownell"
<dbrownell@users.sourceforge.net>; <qi.wang@intel.com>;
<yong.y.wang@intel.com>; <andrew.chih.howe.khor@intel.com>;
<arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
<morinaga526@dsn.okisemi.com>; "Thomas Gleixner" <tglx@linutronix.de>;
"David Woodhouse" <dwmw2@infradead.org>
Sent: Friday, September 10, 2010 1:55 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35


> On Thu, Sep 09, 2010 at 10:58:38PM +0200, Linus Walleij wrote:
> > 2010/9/3 Masayuki Ohtake <masa-korg@dsn.okisemi.com>:
> >
> > > Each instance of our SPI device has the same vendor ID and device ID.
> > > Thus, I think it is impossible to be called probe() for each instance.
> >
> > Looking at you latest patch it appears you could :-)
> > That solves the problem pretty nicely.
>
> Actually, it doesn't look like he did.  It looks to me that the
> ability to support multiple spi bus instances on a single PCI device
> has simply been removed.  I don't know if that is because it simply
> isn't needed yet, or if it is because Ohtake-san doesn't quite
> understand what were suggesting.

We wanted you to accept multi-instance the SPI patch.
But seeing maintainer's comments, I felt it is difficult to be accepted.
Thus, I have deleted whole of multi-instance code.

>
> Regardless it doesn't matter.  When or if the driver does need to be
> modified to support multiple instances, it is a relatively straight
> forward matter to refactor the current code into a platform_driver,
> and create a new pci_driver that simply registers the matching
> platform_device for each spi bus instance supported by the device.
>
> g.
>

