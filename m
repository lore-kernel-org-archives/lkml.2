Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2GKI4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:56:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36967 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab2GKIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:55:58 -0400
Date: Wed, 11 Jul 2012 09:55:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120711085525.GA22437@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120710101018.GE15120@arm.com>
 <20120710163358.6ae4a576@pyramind.ukuu.org.uk>
 <201207101652.18401.arnd@arndb.de>
 <20120710203527.GA16986@gmail.com>
 <20120710214429.GA4733@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710214429.GA4733@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:44:29PM +0100, Catalin Marinas wrote:
> On Tue, Jul 10, 2012 at 09:35:27PM +0100, Ingo Molnar wrote:
> > Do you *really* think that all of the 32-bit ARM code should 
> > essentially be thrown away when going to 64-bit ARM, that 
> > patches can only touch arch/arm64/ + drivers/ or the highway?
> 
> Definitely not, I don't think anyone claimed this. The 32-bit ARM code
> will have the same important place for a very long time, ARM Ltd isn't
> withdrawing support for this (it's the main revenue generator). I expect
> to see many new 32-bit platforms to appear, MP systems, big.little
> configurations etc. If there is need for bigger physical address space,
> LPAE support (even with its drawbacks) is still the preferred choice for
> mobile systems.

Just to be clear in case it doesn't look aligned with Arnd's comment.
I'm referring to the 32-bit ARM port - it has the same important place
as before, nothing from the 32-bit architecture code is thrown away
(over time, we may want to clean up old architecture versions but that's
a normal thing).

How the 32-bit ARM SoC is refactored and maintained it's up to the
arm-soc team and they are doing a great job.

-- 
Catalin
