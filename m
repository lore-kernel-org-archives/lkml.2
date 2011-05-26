Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1EZKOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:14:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab1EZKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:14:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Thu, 26 May 2011 12:13:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
References: <201105181047.17309.arnd@arndb.de> <alpine.LFD.2.02.1105261030560.3078@ionos> <20110526095919.GA31268@opensource.wolfsonmicro.com>
In-Reply-To: <20110526095919.GA31268@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261213.46804.arnd@arndb.de>
X-Provags-ID: V02:K0:aD3c+xbE+ulqQS9hJGSqQSnVOggjUaXCB6j5piO82eB
 G8dX1GjV3hyJWlNu358nYzSe9eTkXOD/IO/ezA/kn/XhGSqMJ5
 iiw/6XajAjZeddmWDcDFzTJh5ERCicZjUPqiZ7PtKPP3+GqmPD
 jLuxwnllJAvc5iNZS9UIVnhQu2glgYGSwdekooY474XUsEvWtS
 mMiATwx9rXl6nX+z8gA1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, Mark Brown wrote:
> 
> On Thu, May 26, 2011 at 10:33:55AM +0200, Thomas Gleixner wrote:
> > On Thu, 26 May 2011, Mark Brown wrote:
> 
> > > I think the question is about the existing -next branches people already
> > > have - should they contain code that hasn't yet gone to you guys?  We're
> > > doing that for audio at the minute (having subtrees in -next directly)
> > > and it's pretty helpful for miniising hassle for the maintainers of the
> > > core tree.
> 
> > We obviously talk about arch/arm/[mach|plat]* stuff, drivers/ sound/
> > etc. should go through the relevant maintainer trees.
> 
> Right, but the question is what to do with the subtrees that are in
> -next currently.  I'm mentioning sound as an example of a tree with
> subtrees in -next directly.

I think all the subarch maintainers should basically stop having their
stuff included directly in linux-next, but instead have it pulled into
our tree, which has one aggregate -next branch that gets included there.

	Arnd
