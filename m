Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0FFDxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 23:53:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:47878 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0FFDxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 23:53:45 -0400
Date: Sat, 5 Jun 2010 20:53:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Russell King <rmk@arm.linux.org.uk>
cc: Daniel Walker <dwalker@codeaurora.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <20100603184104.GC25779@flint.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.01.1006052050220.17462@asgard.lang.hm>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
 <20100603184104.GC25779@flint.arm.linux.org.uk>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Russell King wrote:

> On Thu, Jun 03, 2010 at 11:20:30AM -0700, Daniel Walker wrote:
>> I don't see how we can do without defconfigs altogether tho. I mean , if
>> you want to run a Beagle board or a Nexus one we can't just give the
>> users a slim ARM config and let them troll through 1000's of drivers
>> trying to find just those ones that work on their given board.
>
> Well, Linus does have a point - I can't start a new with Kconfig and
> generate a working defconfig first time mainly because of the
> thounds of options there.
>
> What I can do is get the ARM side of the configuration right, since
> for the majority of cases the only thing that needs doing is selecting
> the platform class and the board itself.
>
> The problem comes with driver configuration, where you have to go
> through lots of menus to find all the drivers for the platform/SoC.
> That's the tedious bit, and more often than not it takes several
> attempts to get everything that's necessary.

Would the resulting kconfig files that Linus is proposing (or whatever 
else goes in) be stable enough across different kernel versions that the 
hardware vendors could create them when the hardware is created and make 
them available?

I'm not just thinking the ARM embedded space here, I'm also thinking 
things like laptops/notebooks which tend to have some unusual hardware as 
well. having a 'this is enough to see everything on the system' config 
would be a wonderful starting place to have.

David Lang
