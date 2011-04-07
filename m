Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab1DGBqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:46:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab1DGBqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:46:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Thu, 7 Apr 2011 03:44:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <Will.Deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <BANLkTinDgAwu7jg+rciMUU19fj+TKPRwmg@mail.gmail.com> <1302079304.8718.7.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1302079304.8718.7.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104070344.44568.arnd@arndb.de>
X-Provags-ID: V02:K0:LhaKxr88MbU1gR9e8EMCHJAy/9rHYccJFBk+DSu6YHn
 lpLPKierd3TbA6w+CJ1o3XvN9Q3HdK++7ezzdm5GMkPAlwK9Sa
 bERSZBvbXdUb1l7ni4cKQNzpfNUJ7Oop9VcMucSvRjTAkGf0IV
 0W+hPbPuWLioHWpQ0QyfwkXwhAeUUdPz+aJnD2SYK4Hb9SQrNS
 XBSntqieRQr4lL3exBb+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 April 2011, Catalin Marinas wrote:
> On Wed, 2011-04-06 at 00:19 +0100, Linus Walleij wrote:
> > 2011/4/1 Linus Torvalds <torvalds@linux-foundation.org>:
> > Basically it requires you to get the physical address and size of
> > each peripheral, then at offset -0x10 from the end address (usually
> > at even 4K pages), if you find the magic number 0xB105F00D
> > (ARM has a sense of humour, obviously) you can find something
> > alike the PCI IDs at offset -0x20, manufacturer ID, version number
> > and revision of the hardware.
> 
> I don't think this was ever part of the AMBA specification. It was just
> some convention used within ARM for the PrimeCell peripherals. Other
> AMBA licensees did something else so it's not a reliable mechanism (I
> think ARM gave up on this as well in recent peripherals).

Do you think there is a way to get ARM ltd to make a better effort
at this with a future specification? I suppose it would be extremely
helpful if there was a way to specify more of the required information,
and to require everybody to fill in correct data, in the same way that
architecture compliance gets enforced on the CPU core.

	Arnd
