Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0FCTq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:46:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55528 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0FCTqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:46:25 -0400
Date: Thu, 3 Jun 2010 20:45:59 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603194559.GF25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> <20100603185333.GD25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:35:42PM -0700, Daniel Walker wrote:
> On Thu, 2010-06-03 at 11:56 -0700, Linus Torvalds wrote:
> > 
> > On Thu, 3 Jun 2010, Russell King wrote:
> > > 
> > > No amount of reorganising the Kconfig files into a heirarchial manner
> > > (which they already are) helps.  Not one bit.  Because they already are.
> > > That's not where the problem is.
> > 
> > I don't think you read the whole thread.
> > 
> > Earlier on, I explained exactly what I wanted: just add some "select" 
> > statements to pickt he things you need per the particular target 
> > configuration. You seem to have missed that part.
> > 
> > In other words, you _can_ encode the information that is in the 
> > xyz_defconfig files by doing it in Kconfig.xyz files instead. But you do 
> > it in a human-readable manner. And the hierarchical thing is absolutely 
> > required for that - otherwise you'd end up with just another form of the 
> > current xyz_defconfig.
> > 
> > See?
> > 
> > In other words, you should be able to basically use "make allnoconfig" 
> > together with a Kconfig.xyz file input to select _exactly_ the pieces you 
> > need, and nothing else.
> 
> If you did this for drivers, what about disabling a driver? If we used
> "select" wouldn't that force all the drivers on without allowing it to
> be unselected?

I already covered that in my (ignored) email where I brought up a
"STD_CONFIG" config symbol, which could be disabled to turn off all
these additional "select"s.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
