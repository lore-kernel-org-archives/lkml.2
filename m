Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab0FDFUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:20:31 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22033 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0FDFU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:20:29 -0400
Date: Fri, 4 Jun 2010 08:18:38 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: ARM defconfig files
Message-ID: <20100604051838.GA21510@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20100603181010.GA25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
 <20100603194559.GF25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
 <20100603211707.GA6499@atomide.com>
 <AANLkTin1UYFfstxPQpmUXawyX1YRqr-PMDCwjFRsJtR_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTin1UYFfstxPQpmUXawyX1YRqr-PMDCwjFRsJtR_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Jun 2010 05:19:41.0197 (UTC) FILETIME=[88EDE3D0:01CB03A5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 12:15:45AM +0200, ext Grant Likely wrote:
>On Thu, Jun 3, 2010 at 3:17 PM, Tony Lindgren <tony@atomide.com> wrote:
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
>(as one who just finishing updating powerpc defconfigs...) ditto here.
> I'd be happy to be rid of all the existing ppc defconfigs.
>
>I like the Kconfig approach, but to be useful (at least for me) there
>would need to be a way to get Kconfig to complain about things like
>broken selects as in your example.

Still selects needs to be improved so we have a 'select_module' option 
that would make that driver a module instead of built-in.

-- 
balbi

DefectiveByDesign.org
