Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab1ESNuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:50:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab1ESNun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:50:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Thu, 19 May 2011 15:50:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
References: <201105181047.17309.arnd@arndb.de> <alpine.LFD.2.00.1105182234130.14430@xanadu.home> <BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com>
In-Reply-To: <BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191550.20129.arnd@arndb.de>
X-Provags-ID: V02:K0:+w+p18yHq4wNjx+I6Yd+XLMJl2zyQP7Ty1x5dQbIdpJ
 VhtGcIK/uWr5r08fHi1SyrJ+ZSGE82eFoeFD6F2kFayTkyPYPW
 wJy2BU5d5GuM+7jbn0L4z7yrP4owzSfy5JjDxE0+EOv596cZvN
 cgpEsqGiOl637ty/cyvTmONoAfIQVtlFvnjWNe/lbvjTWQEUbN
 +ixxyTxZk8io28/XNWQCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011, Barry Song wrote:
> 2011/5/19 Nicolas Pitre <nico@fluxnic.net>:
> > On Thu, 19 May 2011, Barry Song wrote:
> > Something like that.  The exact details will be fleshed out as we go.
> > The idea is to give a round of review from a higher point of view to
> > make sure no opportunities for code reuse is missed, etc.  The mechanics
> > of how this code transitions from this tree into mainline during the
> > merge window is secondary.
> 
> i asked this because we wanted to send the source codes of
> CSR(http://www.csr.com) to upstream as i have told you in LDS. it
> looks like we need to follow the below new changes to make our source
> codes acceptable?
> 1. arm device tree
> 2. new pinmux framework from Linus Walleij
> 3. move GPIO from plat/mach to drivers/gpio?

I would count at least the last two as mandatory, for the device tree,
it depends on how much work it would be for you to do the conversion
and at what time you submit the series. The longer you wait before
submitting the series, the stricter the requirements will get.

Do you have a diffstat or a git tree with your work available?

	Arnd
