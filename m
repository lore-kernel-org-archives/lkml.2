Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0FDLcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:32:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51394 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab0FDLcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:32:41 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603181010.GA25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	<20100603185333.GD25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
	<1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
	<20100603194559.GF25779@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
	<20100603211707.GA6499@atomide.com>
	<AANLkTin1UYFfstxPQpmUXawyX1YRqr-PMDCwjFRsJtR_@mail.gmail.com>
Date: Fri, 04 Jun 2010 12:31:46 +0100
In-Reply-To: <AANLkTin1UYFfstxPQpmUXawyX1YRqr-PMDCwjFRsJtR_@mail.gmail.com>
	(Grant Likely's message of "Thu, 3 Jun 2010 16:15:45 -0600")
Message-ID: <tnxocfrc9ul.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jun 2010 11:31:56.0296 (UTC) FILETIME=[89AF8880:01CB03D9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Jun 3, 2010 at 3:17 PM, Tony Lindgren <tony@atomide.com> wrote:
>> * Linus Torvalds <torvalds@linux-foundation.org> [100603 23:30]:
>>>
>>> and now you'd be able to basically generate a OMAP3EVM .config file by
>>> just running "allnoconfig" on that Kconfig.omap3_evm file. But it would
>>> only have to select the parts that are specific for the EVM platform,
>>> because the generic OMAP3 support would be picked by the Kconfig.omap3
>>> file, which in turn would not have to worry about the generic ARM parts
>>> etc.
>>>
>>> See?
>>
>> Sounds like a good improvment to me.
>
> (as one who just finishing updating powerpc defconfigs...) ditto here.
>  I'd be happy to be rid of all the existing ppc defconfigs.
>
> I like the Kconfig approach, but to be useful (at least for me) there
> would need to be a way to get Kconfig to complain about things like
> broken selects as in your example.

There was an attempt to fix this (I can re-post if people are interested):

http://lkml.org/lkml/2009/9/16/413

-- 
Catalin
