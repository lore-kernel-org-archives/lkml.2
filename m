Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab1CaN0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:26:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49546 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610Ab1CaN0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:26:16 -0400
Date: Thu, 31 Mar 2011 14:25:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nicolas Pitre <nico@fluxnic.net>, david@lang.hm,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331132533.GC17547@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu> <20110331083044.GB14323@n2100.arm.linux.org.uk> <20110331104152.GB3723@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331104152.GB3723@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:41:52PM +0200, Ingo Molnar wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Thu, Mar 31, 2011 at 10:06:34AM +0200, Ingo Molnar wrote:
> > > Having strong, effective platform abstractions inside the kernel really helps 
> > > even if the hardware space itself is inevitably fragmented: both powerpc and 
> > > x86 has shown that. Until you realize and appreciate that you really have not 
> > > understood the problem i think.
> > 
> > No, I think it is the other way around.  Folk like me and Nicolas over the 
> > last ten years have put considerable amounts of effort into trying to keep 
> > the ARM support code as clean and maintainable as possible.
> 
> Absolutely no argument about that, whenever i have read core ARM code it was 
> always a pleasure. You guys are doing a fine job there.

Thanks for your vote of confidence.  It's really appreciated.
