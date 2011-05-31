Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1EaKsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:48:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1EaKsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:48:51 -0400
Date: Tue, 31 May 2011 12:48:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531104839.GE24172@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530091536.GA2827@elte.hu>
 <1306747629.2029.397.camel@i7.infradead.org>
 <20110530095333.GA8461@elte.hu>
 <1306750004.2029.413.camel@i7.infradead.org>
 <20110530102502.GC17821@elte.hu>
 <BANLkTi=X2PzoqJy_dY0oBA9=y_hGt-fX4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=X2PzoqJy_dY0oBA9=y_hGt-fX4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, May 30, 2011 at 12:25, Ingo Molnar <mingo@elte.hu> wrote:
> >> > I personally prefer 'make ARCH=i386 defconfig' and 'make ARCH=x86_64
> >> > defconfig' because it's a nice conceptual equivalent to:
> >> >
> >> >     make ARCH=arm defconfig
> >> >     make ARCH=mips defconfig
> >>
> >> No, ARCH= is just for cross-compiling. If you're *on* an ARM or MIPS
> >> box, you don't need the ARCH= bit.
> >
> > Still note that 'make ARCH=arm defconfig' will just work fine even
> > without cross-building, so i often use just that if i want to see
> > what default core kernel options ARM (or MIPS) has enabled these
> > days.
> 
> That's still the first part of "cross-building", so the issue is moot.

The .config is sometimes the only bit i'm interested in - does an 
architecture's "most important defconfig" turn on a particular core 
kernel feature or not?

I dont want to pick one of the 123 ARM defconfigs. (123 is the 
current upstream count of ARM defconfigs)

Thanks,

	Ingo
