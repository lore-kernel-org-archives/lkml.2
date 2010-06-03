Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0FCT0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:26:55 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43110 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0FCT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:26:54 -0400
Date: Fri, 4 Jun 2010 04:26:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603192626.GA20790@linux-sh.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:21:59AM -0700, Linus Torvalds wrote:
> On Thu, 3 Jun 2010, Daniel Walker wrote:
> > I don't see how we can do without defconfigs altogether tho. I mean , if
> > you want to run a Beagle board or a Nexus one we can't just give the
> > users a slim ARM config and let them troll through 1000's of drivers
> > trying to find just those ones that work on their given board.
> 
> Well, you also don't need the full defconfig's with the kernel.
> 
That's true. We already have things like KCONFIG_ALLCONFIG for these
purposes, and that's primarily what I use for buildig bootable
randconfigs for specific board/CPU combinations on SH.
