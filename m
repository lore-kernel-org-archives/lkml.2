Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0FCSUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:20:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10005 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0FCSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:20:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43222752"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <20100603181010.GA25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603181010.GA25779@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 11:20:30 -0700
Message-ID: <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 19:10 +0100, Russell King wrote:

> config STD_CONFIG
> 	bool "Enable me to generate a standard configuration for your platform"
> 
> and then have platforms conditionally select everything that's
> appropriate for their use.  That provides a way to avoid the ages old
> issue of select forcing options on, but the user still being presented
> with the option and being told the only possible value for it is 'y'.
> 
> And yes, it _is_ necessary - because if you want to turn off something
> on the platform - eg, you're not using MMC and MMC fails to build -
> you can still end up with a working configuration at the end of the
> day.

Check out the SAT solver link I quoted in the prior email.. That sounds
like a really interesting solution. The defconfigs would ultimately hold
just what's unique to a given board, then the solver would figure out
what to else to enable just from those unique properties.

So we would still have defconfigs , but they would not have loads of
duplication like they do now.

I don't see how we can do without defconfigs altogether tho. I mean , if
you want to run a Beagle board or a Nexus one we can't just give the
users a slim ARM config and let them troll through 1000's of drivers
trying to find just those ones that work on their given board.

Daniel

