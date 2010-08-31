Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab0HaBFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:05:40 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1454 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756130Ab0HaBFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:05:39 -0400
Message-ID: <000801cb48a8$9f907060$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Grant Likely" <grant.likely@secretlab.ca>, <meego-dev@meego.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <gregkh@suse.de>, "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com> <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain> <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com> <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com> <alpine.LFD.2.00.1008301442290.9874@localhost6.localdomain6>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Tue, 31 Aug 2010 10:05:30 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

> > Yes, Intel Topcliff is new concept device.
>
> Thats right, but the question was whether the SPI peripheral is a new
> IP design or similar to some already supported AMBA SPI peripheral.
>
> Maybe the Intel folks can shed some light on that.

My answer was not appropriate.
Though the Topcliff is new concept LSI, SPI in Topcliff is not a new design hardware but a reuse from other AMBA-based
products.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Thomas Gleixner" <tglx@linutronix.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Grant Likely" <grant.likely@secretlab.ca>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David
Brownell" <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
<morinaga526@dsn.okisemi.com>; "David Woodhouse" <dwmw2@infradead.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sent: Monday, August 30, 2010 9:44 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35


> On Mon, 30 Aug 2010, Masayuki Ohtake wrote:
> > > Indeed.  BTW, Ohtak-san, is this spi bus device something brand new,
> > > or is it derived from an existing spi device?
> >
> > Yes, Intel Topcliff is new concept device.
>
> Thats right, but the question was whether the SPI peripheral is a new
> IP design or similar to some already supported AMBA SPI peripheral.
>
> Maybe the Intel folks can shed some light on that.
>
> Thanks,
>
> tglx
>


