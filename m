Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2IJR6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:58:09 -0400
Received: from relais.videotron.ca ([24.201.245.36]:15392 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2IJR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:58:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 10 Sep 2012 13:57:57 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 31/31] arm64: MAINTAINERS update
In-reply-to: <20120909163156.GA31430@game.jcrosoft.org>
Message-id: <alpine.LFD.2.02.1209101355000.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-32-git-send-email-catalin.marinas@arm.com>
 <20120909163156.GA31430@game.jcrosoft.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 17:27 Fri 07 Sep     , Catalin Marinas wrote:
> > This patch updates the MAINTAINERS file for the AArch64 Linux kernel
> > port.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  MAINTAINERS |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index fdc0119..de368a5 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1209,6 +1209,12 @@ S:	Maintained
> >  F:	arch/arm/mach-pxa/z2.c
> >  F:	arch/arm/mach-pxa/include/mach/z2.h
> >  
> > +ARM64 PORT (AARCH64 ARCHITECTURE)
> > +M:	Catalin Marinas <catalin.marinas@arm.com>
> we should put Russell too

He is not maintaining the ARM64 code.


Nicolas
