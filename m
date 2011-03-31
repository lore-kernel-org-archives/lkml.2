Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab1CaSKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:10:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34629 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1CaSKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:10:15 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 14:10:14 EDT
Message-ID: <4D94C155.2090406@ahsoftware.de>
Date: Thu, 31 Mar 2011 20:00:53 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: david@lang.hm, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
References: <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <20110331080954.GA14323@n2100.arm.linux.org.uk>
In-Reply-To: <20110331080954.GA14323@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 31.03.2011 10:09, schrieb Russell King - ARM Linux:

> We also need the various SoC designers and ARM architecture people to
> realise that what the hardware situation is rediculous; I have commented
> about this lack of standardisation to ARM in past years.  ARM have had
> a standard set of peripherals for ten years, but the SoC people haven't
> really taken them up - and when they do, they seem to always introduce
> their own tweaks, sometimes with no way to detect those tweaks.

As a user of several ARM boards I fully agree. I've come to the 
conclusion that if device tree or something similiar won't come up, 
which offers a vendor independent description of the hardware, the ARM 
market (at least with Linux as an OS) won't function. It's already 
almost impossible to update an old vendor kernel to a mainline kernel 
version without having schematics. Up to now this isn't a big problem 
because most ARM-HW people are playing with are developer boards, but 
thats already changing and more and more stuff will come without schematics.
And without the help of something like the x86 BIOS (or DT for ARM) you 
are just lost using an ARM-HW where you don't have the schematics, when 
you don't want to use the vendor provided kernel sources (for which you 
almost never get e.g. any security fixes). Finding all the small knobs 
to turn out of vendor provided kernel sources is a pain and just a waste 
of time you almost never can't finish before the HW in question got 
obsolete.

Just my 2¢ on that topic from a somewhat user point of view from one who 
isn't really involved that much in kernel development.

At least I find such a rant from Linus from time to time a good thing. 
Sometimes it helps if someone speaks out loud whats wrong. And if Linus 
wouldn't be that one, who else would be courageous enough to do that? I 
wouldn't (and I can't, I have to thank all kernel developers for their 
hard work).

Regards,

Alexander

