Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1CaEim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:38:42 -0400
Received: from relais.videotron.ca ([24.201.245.36]:55067 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1CaEil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:38:41 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_VbucNmY7XEIiiv8ksBGlZg)"
Date: Thu, 31 Mar 2011 00:38:39 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Dave Airlie <airlied@gmail.com>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103310012500.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_VbucNmY7XEIiiv8ksBGlZg)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Thu, 31 Mar 2011, Dave Airlie wrote:

> > As long as SOC vendors keep producing wildly different architectures
> > besides the core CPU we'll have this problem.  Denying the reality won't
> > make that problem go away either.  And device tree won't stop those
> > vendor from still trying to do things differently (better?) because they
> > are not constrained by having to ensure this single proprietary software
> > stack still boot.
> 
> So you are saying the only way to get the Linux ARM shit cleaned up is
> to hope Microsoft succeeds in making Windows a success on ARM?

Absolutely.  On Intel, it is (still) Windows the reference.  If Windows 
doesn't boot on your motherboard you have a problem.  So motherboard 
vendors won't make crazy incompatible things.  They are constrained to 
fix their hardware because they just cannot alter Windows to suit their 
hardware differences.  That really helps keeping actual differences to a 
minimum and only to things that are not fundamental. So Windows really 
helped making a uniform hardware platform on X86.

On ARM you have no prepackaged "real" Windows.  That let hardware people 
try things.  So they do change the hardware platform all the time to 
gain some edge.  And this is no problem for them because most of the 
time they have access to the OS source code and they modify it 
themselves directly. No wonder why Linux is so popular on ARM. I'm sure 
hardware designers really enjoy this freedom.  We software developers 
would much prefer if the whole hardware platform was standardized and 
set in stone.  That would certainly make our lives so much better and 
then we would have spare cycles to actually abstract all those GPIO 
drivers even further.  But that would benefit Windows on ARM quite 
significantly too.


Nicolas

--Boundary_(ID_VbucNmY7XEIiiv8ksBGlZg)--
