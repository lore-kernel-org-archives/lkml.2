Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0HaGY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:24:59 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37589 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab0HaGY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:24:58 -0400
Message-ID: <003c01cb48d5$3b8b4d10$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <meego-dev@meego.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <gregkh@suse.de>, "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>
References: <4C77BD91.9070302@dsn.okisemi.com> <AANLkTikwZ1CHxup29nEPg9Jobz5B9SC5AftWorwWhUC9@mail.gmail.com> <alpine.LFD.2.00.1008272046410.2768@localhost.localdomain> <AANLkTimsPE2dpVdTNZXR-Yx0fX93Wk_vQDpFJc4xSaTX@mail.gmail.com> <001401cb4814$fb4bdd70$66f8800a@maildom.okisemi.com> <alpine.LFD.2.00.1008301442290.9874@localhost6.localdomain6> <000801cb48a8$9f907060$66f8800a@maildom.okisemi.com> <AANLkTima_bfgguJv8-KTXadWzeTmRGtrzyppH4h=bDW8@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35
Date: Tue, 31 Aug 2010 15:24:51 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "David
Brownell" <dbrownell@users.sourceforge.net>; <qi.wang@intel.com>; <yong.y.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <gregkh@suse.de>; "Tomoya MORINAGA"
<morinaga526@dsn.okisemi.com>; "David Woodhouse" <dwmw2@infradead.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sent: Tuesday, August 31, 2010 2:51 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_SPI driver to 2.6.35


> On Mon, Aug 30, 2010 at 7:05 PM, Masayuki Ohtake
> <masa-korg@dsn.okisemi.com> wrote:
> > Hi Thomas
> >
> >> > Yes, Intel Topcliff is new concept device.
> >>
> >> Thats right, but the question was whether the SPI peripheral is a new
> >> IP design or similar to some already supported AMBA SPI peripheral.
> >>
> >> Maybe the Intel folks can shed some light on that.
> >
> > My answer was not appropriate.
> > Though the Topcliff is new concept LSI, SPI in Topcliff is not a new design hardware but a reuse from other
AMBA-based
> > products.
>
> Which product?  Is that product already supported by Linux?
>
Reused SPI module is from our ML673520(OKI Semiconductor).

Thanks, Ohtake(OKISemi)


