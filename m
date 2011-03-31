Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab1CaQE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:04:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:56424 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab1CaQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:04:26 -0400
Date: Thu, 31 Mar 2011 09:03:28 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <20110331083044.GB14323@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Russell King - ARM Linux wrote:

> On Thu, Mar 31, 2011 at 10:06:34AM +0200, Ingo Molnar wrote:
>> Having strong, effective platform abstractions inside the kernel really helps
>> even if the hardware space itself is inevitably fragmented: both powerpc and
>> x86 has shown that. Until you realize and appreciate that you really have not
>> understood the problem i think.
>
> No, I think it is the other way around.  Folk like me and Nicolas over
> the last ten years have put considerable amounts of effort into trying
> to keep the ARM support code as clean and maintainable as possible.

In this case I owe you and Nicolas an apology.

I think that part of the issue is that when Linus points out a problem, 
the response isn't "we agree and are working on it, here's what we are 
doing", instead it seems to be mostly "there is no problem, this is just 
because there is so much variation in ARM"

Linus does look at the code he pulls, if he is pulling changesets that are 
described as consolodations and cleanups, he won't be whining about code 
churn.

but if he is just pulling chnagesets that are described as "addsupport for 
board X" or "modify defconfig defaults" he is going to complain.

it's not the total amount of code, and it's not even the total amount of 
change to the code that's the issue. It's that the changes are conflicting 
with each other (due to things like central config tables that multiple 
people are updating in different ways) and the same files getting modified 
frequently, many times in ways that don't seem to have a clear direction 
(defconfigs for example)

David Lang
