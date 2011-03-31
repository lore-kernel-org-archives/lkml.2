Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab1CaSJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:09:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49908 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1CaSI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:08:59 -0400
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <alpine.DEB.2.00.1103310904080.29543@asgard.lang.hm>
Date: Thu, 31 Mar 2011 20:08:54 +0200
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C42A3926-6B43-4BC6-9CAB-572FD8B32475@dominion.thruhere.net>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com> <alpine.LFD.2.00.1103310012500.28032@xanadu.home> <20110331105440.42692165@lxorguk.ukuu.org.uk> <20110331105000.GC14323@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1103310904080.29543@asgard.lang.hm>
To: david@lang.hm
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 31 mrt 2011, om 19:22 heeft david@lang.hm het volgende geschreven:

> On Thu, 31 Mar 2011, Russell King - ARM Linux wrote:
> 
>> On Thu, Mar 31, 2011 at 10:54:40AM +0100, Alan Cox wrote:
>>> If I boot it on a current PC I'm booting on a multiprocessor system with
>>> different timers, totally different IRQ controllers, different keyboard
>>> controllers (USB), PCI Express, an IOMMU, NCQ SATA, ACPI, graphics
>>> running in shared host memory able to give/take pages from the host,
>>> extra instructions, etc etc
>>> 
>>> And the same kernel boots just fine on both just fine.
>> 
>> We've been there for a long time with ARM.  Right from the start I had
>> a single kernel image which booted over a range of ARM CPUs and
>> platforms.
>> 
>> As far as ARM CPU architectures go, today we can have a single kernel
>> image which covers ARMv3 to ARMv5, and a separate kernel image which
>> covers ARMv6 to ARMv7 including SMP and UP variants.  The thing which
>> currently stops ARMv3 to ARMv7 all together is the different page table
>> layouts, the ASID tagging, the exclusive load/store support for cmpxchg
>> and other atomic operations, etc.
> 
> I don't think the push is to get a single kernel image that boots absolutly everywhere. having separate ARM5 and ARM7 kernels doesn't seem to be a big deal to anyone.

You mean ARMv5 and ARMv7, right? ARM5 and ARM7 are completely different things.

The short, but inaccurate version:

ARM9 -> ARMv4t, ARMv5te*
ARM11 -> ARMv6*
CORTEX-A* -> ARMv7a

regards,

Koen