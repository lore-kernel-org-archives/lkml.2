Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1E3UVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:21:04 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63838 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1E3UVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:21:02 -0400
Date: Mon, 30 May 2011 14:20:56 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Xilinx: Adding zynq platform support
Message-ID: <20110530202056.GB32035@ponder.secretlab.ca>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com>
 <alpine.LFD.2.00.1105241435550.3207@xanadu.home>
 <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com>
 <201105261559.41993.arnd@arndb.de>
 <20110526150655.GA26661@ponder.secretlab.ca>
 <20110526220120.GN24876@n2100.arm.linux.org.uk>
 <BANLkTi=mL=J4UeKgFEa9y3C==8f9eKkboA@mail.gmail.com>
 <BANLkTin40KK-SahXEP3c1EH1+fWgB54aFw@mail.gmail.com>
 <20110526222512.GO24876@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526222512.GO24876@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:25:12PM +0100, Russell King - ARM Linux wrote:
> On Thu, May 26, 2011 at 04:16:10PM -0600, Grant Likely wrote:
> > Will you pick up the zynq patch also?
> 
> It's about 1000 new lines, and I'm not sure Linus will take that
> level of addition - certainly not without explanation.
> 
> Also, if we adhere to the policy that we don't introduce new code
> which should be using the consolidated code which we've already
> introduced, this would need to be updated to use the mmio
> clocksource stuff at the very least.
> 
> I'm also not convinced that this platform would have the ICST PLL
> chips on it, so why it needs to select ICST I'm not sure (as well
> as having the PLL parameters in its struct clk.)

This is because it is reusing some of the versatile struct clk
implementation instead of cloning it's own set of plat-zynq stuff.  I
recommended to John to not create a completely new struct clk, and
that Versatile was probable the most generic of the lot.

g.
