Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab1CaPrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:47:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:45656 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab1CaPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:47:07 -0400
Date: Thu, 31 Mar 2011 08:45:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Thomas Gleixner <tglx@linutronix.de>, Kevin Hilman <khilman@ti.com>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <20110331150517.GA19452@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1103310843530.29543@asgard.lang.hm>
References: <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <20110331080634.GA18022@elte.hu> <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6> <87d3l7jqpr.fsf@ti.com> <alpine.LFD.2.00.1103311647300.22418@localhost6.localdomain6>
 <20110331150517.GA19452@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Russell King - ARM Linux wrote:

> 
> On Thu, Mar 31, 2011 at 05:01:40PM +0200, Thomas Gleixner wrote:
>> On Thu, 31 Mar 2011, Kevin Hilman wrote:
>>
>>> Thomas Gleixner <tglx@linutronix.de> writes:
>>
>>> Yes, ARM SoC maintainers have to make up some ground.  But compare this
>>> to just a couple years ago where the common complaint was "why aren't
>>> embedded SoC people contributing code to mainline", and you'll see we
>>> have come a long way.
>>
>> Well, code comes in, which is progress. But we need to figure out how
>> to deal with the increasingly growing flood before we drown in it.
>
> How about we declare the remainder of this cycle and the next merge window
> as being only for bug and regression fixes, and consolidation of stuff like
> the IRQ controller and GPIO controller code for the next merge window?

well, now that -rc1 has been released, the remainder of this cycleis 
already only bug and regression fixes.

declaring the next merge window as the same may or may not help, depending 
on if it pushes people to do more consolodations work or just delay 
submitting the work they are doing.

David Lang
