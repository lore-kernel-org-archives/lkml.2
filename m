Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0FCSla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:41:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab0FCSl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:41:29 -0400
Date: Thu, 3 Jun 2010 19:41:04 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603184104.GC25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:20:30AM -0700, Daniel Walker wrote:
> I don't see how we can do without defconfigs altogether tho. I mean , if
> you want to run a Beagle board or a Nexus one we can't just give the
> users a slim ARM config and let them troll through 1000's of drivers
> trying to find just those ones that work on their given board.

Well, Linus does have a point - I can't start a new with Kconfig and
generate a working defconfig first time mainly because of the
thounds of options there.

What I can do is get the ARM side of the configuration right, since
for the majority of cases the only thing that needs doing is selecting
the platform class and the board itself.

The problem comes with driver configuration, where you have to go
through lots of menus to find all the drivers for the platform/SoC.
That's the tedious bit, and more often than not it takes several
attempts to get everything that's necessary.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
