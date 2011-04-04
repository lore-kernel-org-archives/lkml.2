Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1DDJ3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:29:04 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56477 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1DDJ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:29:03 -0400
Message-ID: <4D998F0D.8070300@atmel.com>
Date: Mon, 04 Apr 2011 11:27:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Detlef Vollmann <dv@vollmann.ch>
CC: Arnd Bergmann <arnd@arndb.de>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>	<201104011554.07924.arnd@arndb.de> <4D95E112.4020400@vollmann.ch>	<201104011659.40443.arnd@arndb.de> <4D95EF8E.9080902@vollmann.ch>
In-Reply-To: <4D95EF8E.9080902@vollmann.ch>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/04/2011 17:30, Detlef Vollmann :
> On 04/01/11 16:59, Arnd Bergmann wrote:
>> On Friday 01 April 2011, Detlef Vollmann wrote:
>>> On 04/01/11 15:54, Arnd Bergmann wrote:
>>
>>>> 9. All interesting work is going into a handful of platforms, all of
>>>> which
>>>>      are ARMv7 based.
>>> Define interesting.
>>
>> The ones that are causing the churn that we're talking about.
>> Platforms that have been working forever and only need to get
>> the occasional bug fix are boring, i.e. not the problem.
> In the ARM tree I only know mach-at91.
> Atmel still introduces new SOCs based on ARM926EJ-S, and that makes
> perfect sense for lots of applications.
> And if they add support for a new SOC, they just copy an existing one,
> change some GPIOs, and submit it as new files (sorry, I'm over-
> simplifying here).
> And if you happen to wire your board a bit differently than they do,
> you have to patch theur generic file (in addidtion to add your own
> board file).
> And though I only know the mach-at91 closely, I'm pretty sure quite
> a number of other mach-* are not better.
> So this is actually why the ARM tree has such a bad reputation:
> lot's of code repetition, and still more of that.

Yes, certainly time has come for a change.

Note however that AT91 community is making great effort to:
- publish and maintain every single chip/board support since more than 5
years (and far before for first venerable at91rm9200) : if you recall
well, it was before most of code that appeared in arch/arm/mach-*
directories ;-)
- integrate ideas and patches from contributors for simplifying and
reducing board duplication
- try to conform to new infrastructures that are appearing on ARM Linux
for better convergence of code: gpiolib, leds, buttons, clocks (work in
progress)...

We know that work has to be done and we will for sure follow this effort
of consolidation. And remember: contributions welcomed ;-).

Best regards,
-- 
Nicolas Ferre

