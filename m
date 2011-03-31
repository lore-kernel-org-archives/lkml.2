Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1CaAbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:31:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54531 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1CaAbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<alpine.LFD.2.00.1103301531420.28032@xanadu.home>
	<AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
	<alpine.LFD.2.00.1103301814250.28032@xanadu.home>
Date: Wed, 30 Mar 2011 19:31:07 -0500
Message-ID: <AANLkTikPqkxUGPAAjHRTg2pSn5DfDFp14gO0AKX-d+ZF@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Bill Gatliff <bgat@billgatliff.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico:

On Wed, Mar 30, 2011 at 6:31 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>
> But X86 is peanuts.  Really.

Finally, a voice of reason!

> On ARM there is simply not such thing as a single machine design to
> clone, and a closed source test bench to design for.

... and there almost certainly won't ever be.

I recognize the problems present in the ARM code.  But any attempt to
homogenize the ARM platform code just doesn't fit with reality.  ARM
machines are created to solve different problems from PCs, and the
diversity in the ARM platform community is a reflection of that.

I don't think that all the chaos in the ARM kernel code comes from
shite programming; I think it comes from the chaos that is ARM
hardware.

And I'm highly skeptical that any of these problems can be simply
pushed into a bootloader.  Most of my clients struggle with the
bare-minimum that is required of bootloaders now, and I don't think
they are in any way out of the ordinary.

I think that the ARM beast has to be tamed with kernel code, because
kernel programmers are the best minds available to do it.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
