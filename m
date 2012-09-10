Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2IJVSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:18:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57402 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2IJVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:18:12 -0400
Date: Mon, 10 Sep 2012 22:17:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arch@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 31/31] arm64: MAINTAINERS update
Message-ID: <20120910211757.GD31998@n2100.arm.linux.org.uk>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-32-git-send-email-catalin.marinas@arm.com> <20120909163156.GA31430@game.jcrosoft.org> <alpine.LFD.2.02.1209101355000.28681@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1209101355000.28681@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 01:57:57PM -0400, Nicolas Pitre wrote:
> On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On 17:27 Fri 07 Sep     , Catalin Marinas wrote:
> > > This patch updates the MAINTAINERS file for the AArch64 Linux kernel
> > > port.
> > > 
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  MAINTAINERS |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index fdc0119..de368a5 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -1209,6 +1209,12 @@ S:	Maintained
> > >  F:	arch/arm/mach-pxa/z2.c
> > >  F:	arch/arm/mach-pxa/include/mach/z2.h
> > >  
> > > +ARM64 PORT (AARCH64 ARCHITECTURE)
> > > +M:	Catalin Marinas <catalin.marinas@arm.com>
> > we should put Russell too
> 
> He is not maintaining the ARM64 code.

And, let's say the rest of it - it doesn't take much inteligence to work
out what that means for me personally.
