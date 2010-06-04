Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0FDIxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:53:10 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35518 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0FDIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:53:06 -0400
Subject: Re: ARM defconfig files
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <AANLkTimCXB5r5unDgcZApyO0hbCSYgNgZNV-aHrxg12E@mail.gmail.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603164623.GM30622@atomide.com>
	 <20100603181303.GB25779@flint.arm.linux.org.uk>
	 <1275613325.1931.849.camel@pasglop>
	 <AANLkTimCXB5r5unDgcZApyO0hbCSYgNgZNV-aHrxg12E@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM Australia
Date: Fri, 04 Jun 2010 18:52:59 +1000
Message-ID: <1275641579.1931.939.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 08:30 +0200, Geert Uytterhoeven wrote:
> 
> > warrant a different thread. However it's interesting because we do
> that
> > quite well on powerpc :-)
> 
> So you could easily have one big common defconfig... 

Well, there are things we still don't allow in one binary, and I suspect
it would be nasty on ARM too, such as widely different core arch (which
in ARM land would translate into widely different ARM architecture
version).

But yeah, we can pretty much make giant defconfigs. They are not very
useful tho. In the embedded world, size constraints are quite strong and
so you really need to be able to target only the subset of things you
want for some types of devices.

Of course, for things like ARM netbooks, it would be nice to have one
giant defconfig that boots them all, and that's probably an achievable
goal if the variants between bootloaders can be sorted out.

Cheers,
Ben.

