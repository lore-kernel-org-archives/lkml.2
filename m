Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0FCSNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:13:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43684 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0FCSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:13:32 -0400
Date: Thu, 3 Jun 2010 19:13:03 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603181303.GB25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603164623.GM30622@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603164623.GM30622@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
> Compiling in multiple ARM platforms is trickier, we would have to get
> rid of the duplicate defines like NR_IRQS, then have some common clock
> framework etc. Then figure out some way to get rid of Makefile.boot.
> Russell probably has some other things in mind that would have to be
> changed to make this happen.

- Find someway to handle the wide variety of interrupt controllers.
- Be able to handle any multitude of V:P translations, including non-linear
  alongside linear transations.
- Different PAGE_OFFSETs
- Different kernel VM layouts allowing for a variety of different ioremap
  region sizes

and so the list goes on...

> That way maybe you can wait a bit longer for the other defconfigs
> and as an extra bonus I won't get flamed for removing these omap
> defconfigs ;)

Note that Linus is talking about removing all but one or two ARM
defconfigs - which means your omap3_defconfig will probably be
eventually culled.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
