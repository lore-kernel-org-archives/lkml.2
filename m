Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab0IJA1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 20:27:14 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33094 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0IJA1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 20:27:13 -0400
Message-ID: <000c01cb507e$e8d0a3c0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Linus Walleij" <linus.ml.walleij@gmail.com>
Cc: "Grant Likely" <grant.likely@secretlab.ca>, <meego-dev@meego.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <gregkh@suse.de>, "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "David Woodhouse" <dwmw2@infradead.org>
References: <000a01cb4b2b$f03c6d40$66f8800a@maildom.okisemi.com> <AANLkTimTumguZ7Tm1-zGb=D+0gghsA-b-RyhRDTQieFR@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Fri, 10 Sep 2010 09:27:05 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Thank you for your checking.

> If you incluse ChangeLogs it's easier to follow the development,
> thanks.

The latest patch has included the following Changelog.

> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has SPI I/F. Using this I/F, it is able to access system
> devices connected to SPI.

Do you mean the above our Changelog is lack of something ?

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Linus Walleij" <linus.ml.walleij@gmail.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Grant Likely" <grant.likely@secretlab.ca>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David
Brownell" <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
<morinaga526@dsn.okisemi.com>; "Thomas Gleixner" <tglx@linutronix.de>; "David Woodhouse" <dwmw2@infradead.org>
Sent: Friday, September 10, 2010 5:58 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35


> 2010/9/3 Masayuki Ohtake <masa-korg@dsn.okisemi.com>:
>
> > Each instance of our SPI device has the same vendor ID and device ID.
> > Thus, I think it is impossible to be called probe() for each instance.
>
> Looking at you latest patch it appears you could :-)
> That solves the problem pretty nicely.
> If you incluse ChangeLogs it's easier to follow the development,
> thanks.
>
> Linus Walleij
>


